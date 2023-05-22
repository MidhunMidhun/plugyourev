import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'dart:math' show asin, cos, pow, sin, sqrt;
import 'package:latlong2/latlong.dart';
import 'package:mapbox_search/mapbox_search.dart';

final myCenter = LatLng(8.5460815, 76.9046274);

class EnRoute extends StatefulWidget {
  static const String ACCESS_TOKEN = String.fromEnvironment(
      "pk.eyJ1IjoibW1pZGh1biIsImEiOiJjbGFxYTIxODcxNDB0M3ZucGlmcWp3cHpuIn0.4ekFwyhXAkUt-zYu9ePDpQ");
  static const String mapBoxStyleId = 'clfgi2vwf00a901rxqoiggpna';

  @override
  State<EnRoute> createState() => _EnRouteState();
}

late TextEditingController _textEditingController;

//Test Comments
class _EnRouteState extends State<EnRoute> {
  double origLat = 0;
  double origLon = 0;
  double destLat = 0;
  double destLon = 0;
  final TextEditingController controller = TextEditingController();
  late final PlacesSearch _searchApi;
  List<MapBoxPlace> places = [];
  List<MapBoxPlace> _places = [];
  List<LatLng> points = [];
  String sourceName = '';
  String destName = '';
  late MapController mapController;

  LatLngBounds? bounds;
  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _textEditingController = TextEditingController();
    _searchApi = PlacesSearch(
      apiKey: apiKey,
      country: 'in',
    );
    places = [];
  }

//navigation directions
  String apiKey =
      'pk.eyJ1IjoibW1pZGh1biIsImEiOiJjbGFxYTIxODcxNDB0M3ZucGlmcWp3cHpuIn0.4ekFwyhXAkUt-zYu9ePDpQ';

  Map<String, dynamic>? data;

  void handleDirectionsButtonPressed() {
    getDirections();
  }

  Future<void> getDirections() async {
    if (destLat != 0 && destLon != 0 && origLat != 0 && origLon != 0) {
      String apiUrl =
          'https://api.mapbox.com/directions/v5/mapbox/driving/$origLon%2C$origLat%3B$destLon%2C$destLat?alternatives=true&geometries=geojson&language=en&overview=simplified&steps=true&access_token=pk.eyJ1IjoibW1pZGh1biIsImEiOiJjbGFxYTIxODcxNDB0M3ZucGlmcWp3cHpuIn0.4ekFwyhXAkUt-zYu9ePDpQ';
      http.Response response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        setState(() {
          data = json.decode(response.body);
          for (var x in data!['routes'][0]['geometry']['coordinates']) {
            points.add(LatLng(x[1], x[0]));
          }
          print(points);
          // Zoom and adjust the map view to fit the directions
          bounds = LatLngBounds.fromPoints(points);
          mapController.fitBounds(
            bounds!,
            options: FitBoundsOptions(padding: EdgeInsets.all(70)),
          );

          getDataFromFirebaseStorage();
        });
      } else {
        // Handle error
      }
    }
  }

  List<LatLng> _point = [];
  FirebaseStorage storage = FirebaseStorage.instance;
  List<dynamic> markersData = []; // list of JSON data representing markers
  List<Marker> markers = [];
  List<dynamic> locations = [];
  String jsonFileName = 'ev_stations_list.json';
  void getDataFromFirebaseStorage() async {
    try {
      // Get the download URL for the JSON file
      String downloadUrl =
          await storage.ref().child(jsonFileName).getDownloadURL();

      // Make an HTTP GET request to the download URL
      http.Response response = await http.get(Uri.parse(downloadUrl));

      // print("response");
      // print(response);

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Parse the JSON data
        locations = json.decode(response.body);

        // Do something with the data

        setState(() {
          markersData = locations;
          //print(markersData);
          _buildMarkers(locations);
        });
      } else {
        // Handle the error
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error:here $e');
    }
  }

  void _buildMarkers(List<dynamic> data) {
    // Iterate through the data and build a Marker widget for each item
    for (int i = 0; i < data.length; i++) {
      LatLng point = LatLng(data[i]['lat'], data[i]['long']);
      _point.add(point);

      markers.add(Marker(
        point: point,
        builder: (context) {
          return Container(
            child: const Icon(
              Icons.ev_station,
              color: Colors.green,
              size: 30,
            ),
          );
        },
      ));
    }
    print('markers coordinates:$_point');
    calculateDistances();
  }

  void calculateDistances() {
    List<double> distances = [];

    for (LatLng p in points) {
      for (LatLng x in _point) {
        double distance =
            haversineDistance(p.latitude, p.longitude, x.latitude, x.longitude);
        distances.add(distance);
      }
    }
    print('Distances : $distances');
  }

  double haversineDistance(double lat1, double lon1, double lat2, double lon2) {
    const int earthRadius = 6371; // Radius of the earth in kilometers

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = pow(sin(dLat / 2), 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * pow(sin(dLon / 2), 2);
    double c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * (pi / 180);
  }

  Future<void> _onSearch(String query) async {
    if (query.isNotEmpty) {
      final places = await _searchApi.getPlaces(
        query,
        // types: [PlaceType.address, PlaceType.poi],
      );
      setState(() {
        _places = places ?? [];
      });
    }
  }

  List<MapBoxPlace> searchResults = [];

  Future<void> getPlaces(String searchQ) async {
    print("calling with " + searchQ);
    PlacesSearch placesSearch = PlacesSearch(
      apiKey:
          'pk.eyJ1IjoibW1pZGh1biIsImEiOiJjbGFxYTIxODcxNDB0M3ZucGlmcWp3cHpuIn0.4ekFwyhXAkUt-zYu9ePDpQ',
      limit: 5,
    );

    List<MapBoxPlace>? results = await placesSearch.getPlaces(searchQ);

    setState(() {
      searchResults = results ?? [];
      print(searchResults);
      // print(results);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              zoom: 10,
              center: myCenter,
            ),
            children: [
              TileLayer(
                  urlTemplate:
                      'https://api.mapbox.com/styles/v1/mmidhun/clfgi2vwf00a901rxqoiggpna/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibW1pZGh1biIsImEiOiJjbGFxYTIxODcxNDB0M3ZucGlmcWp3cHpuIn0.4ekFwyhXAkUt-zYu9ePDpQ',
                  additionalOptions: {
                    'mapStyleId': EnRoute.mapBoxStyleId,
                    'accessToken': EnRoute.ACCESS_TOKEN,
                  }),
              PolylineLayer(
                polylines: [
                  Polyline(points: points, strokeWidth: 4, color: Colors.blue)
                ],
              ),
              MarkerLayer(markers: markers),
            ],
          ),
          Positioned(
            top: 25,
            left: 10,
            right: 10,
            child: Container(
                height: 120,
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: Colors.white,
                        style: BorderStyle.solid,
                        width: 1),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 110,
                      decoration: BoxDecoration(
                          // border: Border.all(
                          //     color: Colors.grey,
                          //     style: BorderStyle.solid,
                          //     width: 1),
                          ),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: ((context) {
                                    return ListView(
                                      children: [
                                        SizedBox(
                                          height: 40,
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 20),
                                              child: Icon(
                                                Icons.arrow_back,
                                                size: 40,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              child: CupertinoSearchTextField(
                                                controller:
                                                    _textEditingController,
                                                onChanged: (v) {
                                                  print(v);

                                                  setState(() {
                                                    getPlaces(v);
                                                  });
                                                },
                                                backgroundColor: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                placeholder: 'Search',
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          height: 500,
                                          child: ListView.builder(
                                            itemCount: searchResults.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              MapBoxPlace item =
                                                  searchResults[index];
                                              return ListTile(
                                                onTap: () {
                                                  print(item
                                                      .geometry!.coordinates);
                                                  origLon = item.geometry!
                                                      .coordinates![0];
                                                  origLat = item.geometry!
                                                      .coordinates![1];
                                                  setState(() {
                                                    sourceName =
                                                        item.placeName!;
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                                title: Text(item.placeName!),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  }));
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.8,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey,
                                      style: BorderStyle.solid,
                                      width: 1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: sourceName == ''
                                  ? Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Enter source',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    )
                                  : Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(sourceName)),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: ((context) {
                                    return ListView(
                                      children: [
                                        SizedBox(
                                          height: 40,
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 20),
                                              child: Icon(
                                                Icons.arrow_back,
                                                size: 40,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              child: CupertinoSearchTextField(
                                                controller:
                                                    _textEditingController,
                                                onChanged: (v) {
                                                  print(v);
                                                  setState(() {
                                                    getPlaces(v);
                                                  });
                                                },
                                                backgroundColor: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                placeholder: 'Search',
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          height: 500,
                                          child: ListView.builder(
                                            itemCount: searchResults.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              MapBoxPlace item =
                                                  searchResults[index];
                                              return ListTile(
                                                onTap: () {
                                                  print(item
                                                      .geometry!.coordinates);
                                                  destLon = item.geometry!
                                                      .coordinates![0];
                                                  destLat = item.geometry!
                                                      .coordinates![1];
                                                  setState(() {
                                                    destName = item.placeName!;
                                                  });

                                                  Navigator.of(context).pop();
                                                },
                                                title: Text(item.placeName!),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                    ;
                                  }));
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.8,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey,
                                      style: BorderStyle.solid,
                                      width: 1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: destName == ''
                                  ? Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Enter destination',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    )
                                  : Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(destName)),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 95,
                      width: 55,
                      child: IconButton(
                          onPressed: handleDirectionsButtonPressed,
                          iconSize: 50,
                          icon: Icon(
                            Icons.directions,
                            color: Colors.blue,
                          )),
                    )
                  ],
                )),
          )
          // SizedBox(
          //   height: 400,
          //   child: Expanded(
          //     child: ListView.builder(
          //       itemCount: places.length,
          //       itemBuilder: (context, index) {
          //         return ListTile(
          //           title: Text(places[index].placeName ?? ''),
          //           subtitle: Text(places[index].text ?? ''),
          //           onTap: () {
          //             Navigator.pop(context, places[index]);
          //           },
          //         );
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class MapBoxPlaceSearch {
  getPlaces(String value) {}
}
