import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
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
        });
      } else {
        // Handle error
      }
    }
  }

  Future<void> _onSearch(String query) async {
    if (query.isNotEmpty) {
      final places = await _searchApi.getPlaces(
        query,
        // types: [PlaceType.address, PlaceType.poi],
      );
      setState(() {
        _places = places!;
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
      searchResults = results!;
      print(searchResults);
      print(results);
    });
  }

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _searchApi = PlacesSearch(
      apiKey: apiKey,
      country: 'in',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
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
              )
            ],
          ),
          Positioned(
            top: 25,
            left: 10,
            right: 10,
            child: SizedBox(
              height: 300,
              width: 350,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
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
                              width: 200,
                              height: 50,
                              color: Colors.white,
                              child: sourceName == ''
                                  ? Text('source')
                                  : Text(sourceName),
                            )),
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
                                                print(
                                                    item.geometry!.coordinates);
                                                destLon = item
                                                    .geometry!.coordinates![0];
                                                destLat = item
                                                    .geometry!.coordinates![1];
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
                            width: 200,
                            height: 50,
                            color: Colors.white,
                            child: destName == ''
                                ? Text('destination')
                                : Text(destName),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 95,
                    padding: EdgeInsets.only(right: 20),
                    color: Colors.white,
                    child: IconButton(
                        onPressed: handleDirectionsButtonPressed,
                        iconSize: 50,
                        icon: Icon(
                          Icons.directions,
                          color: Colors.blue,
                        )),
                  )
                ],
              ),
            ),
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
