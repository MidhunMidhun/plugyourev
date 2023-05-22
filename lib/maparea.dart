// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:plugyourev/profile_page.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:http/http.dart' as http;
import 'package:plugyourev/searchpage.dart';

import 'bottom_navbar.dart';
import 'chat_page.dart';
import 'en_route.dart';
import 'stationpage.dart';

const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoibW1pZGh1biIsImEiOiJjbGFxYTIxODcxNDB0M3ZucGlmcWp3cHpuIn0.4ekFwyhXAkUt-zYu9ePDpQ';

final myCenter = LatLng(8.5460815, 76.9046274);

class MapArea extends StatefulWidget {
  final double lat;
  final double lng;
  static const String ACCESS_TOKEN = String.fromEnvironment(
      "pk.eyJ1IjoibW1pZGh1biIsImEiOiJjbGFxYTIxODcxNDB0M3ZucGlmcWp3cHpuIn0.4ekFwyhXAkUt-zYu9ePDpQ");
  static const String mapBoxStyleId = 'clfgi2vwf00a901rxqoiggpnas';

  const MapArea({super.key, this.lat = 0, this.lng = 0});

  @override
  State createState() => MapAreaState();
}

class MapAreaState extends State<MapArea> {
  double origLat = 0;
  double origLon = 0;
  double destLat = 0;
  double destLon = 0;
  double xlat = 0;
  double xlon = 0;
  double ylat = 0;
  double ylon = 0;

  double flat = 0;
  double flon = 0;
  int selectedMarker = 1;

  List<LatLng> points = [];
  var _mapController;
  // var _selectedIndex = 0;
  List<dynamic> locations = [];
// //search places
//   String baseUrl = 'https://api.mapbox.com/geocoding/v5/mapbox.places';
//   String searchType = 'place%2Cpostcode%2Caddress';
//   String searchResultsLimit = '5';
//   String proximity = 'ip';
//   String country = 'in';

//   Dio _dio = Dio();

//   Future getSearchResultsFromQueryUsingMapbox(String searchtext) async {
//     String url =
//         '$baseUrl/$searchtext.json?&proximity=$proximity&access_token=$MAPBOX_ACCESS_TOKEN';
//     url = Uri.parse(url).toString();
//     // String url =
//     //     '$baseUrl/$searchtext.json?country=$country&limit=$searchResultsLimit&proximity=$proximity&types=$searchType&access_token=$MAPBOX_ACCESS_TOKEN';
//     // url = Uri.parse(url).toString();
//     print(url);
//     try {
//       _dio.options.contentType = Headers.jsonContentType;
//       final responseData = await _dio.get(url);
//       setState(() {
//         _placesList.add(responseData.data['features'][0]['place_name']);
//       });
//       print(responseData.data['features'][0]['place_name']);
//       return responseData.data;
//     } catch (e) {
//       var DioExceptions;
//       final errorMessage = DioExceptions.fromDioError(e as DioError).toString();
//       debugPrint(errorMessage);
//     }
//   }

  //get user location
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  late MapboxMapController mapController;
  late Position currentPosition;
  late TextEditingController _textEditingController;
  late final PlacesSearch _searchApi;
  final TextEditingController _searchController = TextEditingController();
  List<MapBoxPlace> _places = [];
  List<String> _placesList = [];
  List<dynamic> Locations = [];
  @override
  void initState() {
    super.initState();
    getDataFromFirebaseStorage();
    _getCurrentLocation();
    _textEditingController = TextEditingController();
    _searchApi = PlacesSearch(
      apiKey: MAPBOX_ACCESS_TOKEN,
      country: 'in',
    );
  }

  FirebaseStorage storage = FirebaseStorage.instance;
  List<dynamic> markersData = []; // list of JSON data representing markers
  List<Marker> markers = [];
  String jsonFileName = 'ev_stations_list.json';
  final pageController = PageController();

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
          print(markersData);
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

  void _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      currentPosition = position;
      print(currentPosition);
      origLat = currentPosition.latitude;
      origLon = currentPosition.longitude;

      xlat = currentPosition.latitude;
      xlon = currentPosition.longitude;
      ylat = 0;
      ylon = 0;
    });
  }

  // final TextEditingController _textEditingController = TextEditingController();

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
          // print(points);
        });
      } else {
        // Handle error
      }
    }
  }

  void _buildMarkers(List<dynamic> data) {
    // Iterate through the data and build a Marker widget for each item
    for (int i = 0; i < data.length; i++) {
      LatLng point = LatLng(data[i]['lat'], data[i]['long']);

      markers.add(Marker(
        point: point,
        builder: (context) {
          return GestureDetector(
            onTap: () {
              print("i");
              print(i);
              print("s.no");
              print(data[i]['S.no']);

              pageController.animateToPage(
                i,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
              setState(() {
                selectedMarker = data[i]['S.no'];
                print(
                  'selectedMarker $selectedMarker',
                );
              });
            },
            child: Container(
              child: const Icon(
                Icons.ev_station,
                color: Colors.green,
                size: 30,
              ),
            ),
          );
        },
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_new
    print('"xlat xlon"');
    print('$xlat $xlon');
    print('"ylat ylon"');
    print('$ylat $ylon');

    if (xlat == 0 && xlon == 0) {
      if (ylat == 0 && ylon == 0) {
        setState(() {
          flat = 8.5460815;
          flon = 76.9046274;
        });
      } else {
        setState(() {
          flat = ylat;
          flon = ylon;
        });
      }
    } else {
      setState(() {
        flat = xlat;
        flon = xlon;
      });
    }

    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        FlutterMap(
            options: MapOptions(
              center: LatLng(flat, flon),
              zoom: 12,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/mmidhun/clfgi2vwf00a901rxqoiggpna/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibW1pZGh1biIsImEiOiJjbGFxYTIxODcxNDB0M3ZucGlmcWp3cHpuIn0.4ekFwyhXAkUt-zYu9ePDpQ',
                additionalOptions: {
                  'mapStyleId': MapArea.mapBoxStyleId,
                  'accessToken': MapArea.ACCESS_TOKEN,
                },
              ),
              PolylineLayer(
                polylines: [
                  Polyline(points: points, strokeWidth: 4, color: Colors.blue)
                ],
              ),
              MarkerLayer(markers: markers),
            ]),
        Positioned(
            top: 30,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    width: 300,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: GestureDetector(
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: CupertinoSearchTextField(
                                          controller: _textEditingController,
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
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        MapBoxPlace item = searchResults[index];
                                        return ListTile(
                                          onTap: () {
                                            setState(() {
                                              print(item.geometry!.coordinates);
                                              double lng = item
                                                  .geometry!.coordinates![0];
                                              double lat = item
                                                  .geometry!.coordinates![1];

                                              ylat = item
                                                  .geometry!.coordinates![1];
                                              ylon = item
                                                  .geometry!.coordinates![0];

                                              xlat = 0;
                                              xlon = 0;
                                              Navigator.of(context).pop();
                                            });
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
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Search places',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    // controller: _textEditingController,
                    // onChanged: getSearchResultsFromQueryUsingMapbox,
                    //onTap: _search,
                  ),
                  Container(
                    width: 50,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.blue[400]),
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20))),
                            builder: ((context) {
                              return filter_page();
                            }));
                      },
                      child: IconButton(
                          onPressed: null,
                          iconSize: 30,
                          icon: Icon(
                            Icons.filter_list,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ],
              ),
            )),
        Positioned(
            bottom: 200,
            right: 10,
            child: Container(
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              child: IconButton(
                  onPressed: () {
                    _getCurrentLocation();
                  },
                  icon: Icon(
                    Icons.gps_fixed,
                    color: Colors.blue,
                    size: 30,
                  )),
            )),
        Positioned(
          left: 0,
          right: 0,
          bottom: 2,
          height: MediaQuery.of(context).size.height * 0.28,
          child: PageView.builder(
            controller: pageController,
            onPageChanged: (value) {
              // print("value");
              // print(value);
              // pageController.animateToPage(
              //   value,
              //   duration: const Duration(milliseconds: 500),
              //   curve: Curves.easeInOut,
              // );
              // setState(() {});
            },
            itemCount: markers.length,
            itemBuilder: (_, index) {
              final item = markers[index];
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Color.fromARGB(255, 250, 250, 250),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.horizontal,
                                itemCount: locations[index]['rating'],
                                itemBuilder: (BuildContext context, int index) {
                                  return const Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () => Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (builder) => stationpage(
                                                  selectedMarker:
                                                      selectedMarker,
                                                ))),
                                    child: Text(
                                      locations[index]['title'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    locations[index]['city'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: GestureDetector(
                                  onTap: () => Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (builder) => stationpage(
                                                selectedMarker: selectedMarker,
                                              ))),
                                  child: Image(
                                    image: NetworkImage(
                                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR7uynsZtn6oBeQRpyLKY94qwBR-L5BGIAsL1aCR_mL&s",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    destLat = locations[index]['lat'];
                                    destLon = locations[index]['long'];
                                  });

                                  handleDirectionsButtonPressed();
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll(Colors.blue)),
                                child: Text(
                                  'Get Direction',
                                  style: TextStyle(color: Colors.white),
                                ))
                          ],
                        ),
                      ),
                      // const SizedBox(width: 10),
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ]),
    ));
  }
}

// class searchpage extends StatelessWidget {
//   searchpage({
//     super.key,
//   });

//   final TextEditingController _textEditingController = TextEditingController();

//   List<MapBoxPlace> searchResults = [];

//   Future<void> getPlaces(String searchQ) async {
//     print("calling with " + searchQ);
//     PlacesSearch placesSearch = PlacesSearch(
//       apiKey:
//           'pk.eyJ1IjoibW1pZGh1biIsImEiOiJjbGFxYTIxODcxNDB0M3ZucGlmcWp3cHpuIn0.4ekFwyhXAkUt-zYu9ePDpQ',
//       limit: 5,
//     );

//     List<MapBoxPlace>? results = await placesSearch.getPlaces(searchQ);

//     print(results);

//     setState(() {
//       print(results);
//       searchResults = results!;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       children: [
//         SizedBox(
//           height: 40,
//         ),
//         Row(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 10, right: 20),
//               child: Icon(
//                 Icons.arrow_back,
//                 size: 40,
//                 color: Colors.grey,
//               ),
//             ),
//             Container(
//               width: MediaQuery.of(context).size.width * 0.8,
//               child: CupertinoSearchTextField(
//                 controller: _textEditingController,
//                 onChanged: (v) {
//                   print(v);
//                   getPlaces(v);
//                 },
//                 backgroundColor: Colors.white,
//                 borderRadius: BorderRadius.circular(10.0),
//                 placeholder: 'Search',
//               ),
//             ),
//           ],
//         ),
//         Container(
//           height: 500,
//           child: ListView.builder(
//             itemCount: resul.length,
//             itemBuilder: (BuildContext context, int index) {
//               MapBoxPlace item = searchResults[index];
//               return ListTile(
//                 onTap: () {
//                   print(item.geometry!.coordinates);
//                   double lng = item.geometry!.coordinates![0];
//                   double lat = item.geometry!.coordinates![1];
//                 },
//                 title: Text(item.placeName!),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   void setState(Null Function() param0) {}
// }

class filter_page extends StatefulWidget {
  const filter_page({Key? key}) : super(key: key);

  @override
  State<filter_page> createState() => _filter_pageState();
}

class _filter_pageState extends State<filter_page> {
  String selectedDistance = '';
  String selectedConnectionType = '';
  String selectedVehicleType = '';

  void selectDistance(String distance) {
    setState(() {
      selectedDistance = distance;
    });
  }

  void selectConnectionType(String connectionType) {
    setState(() {
      selectedConnectionType = connectionType;
    });
  }

  void selectVehicleType(String vehicleType) {
    setState(() {
      selectedVehicleType = vehicleType;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Center(
            child: Text(
              'Filter',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          SizedBox(height: 20),
          // By distance
          Column(
            children: [
              Container(
                width: double.maxFinite,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'By distance',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedDistance == '500M'
                                    ? Colors.blue
                                    : Colors.grey.shade300,
                                style: BorderStyle.solid,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextButton(
                              onPressed: () {
                                selectDistance('500M');
                              },
                              child: Text(
                                '500M',
                                style: TextStyle(
                                  color: selectedDistance == '500M'
                                      ? Colors.blue
                                      : Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedDistance == '1KM'
                                    ? Colors.blue
                                    : Colors.grey.shade300,
                                style: BorderStyle.solid,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextButton(
                              onPressed: () {
                                selectDistance('1KM');
                              },
                              child: Text(
                                '1KM',
                                style: TextStyle(
                                  color: selectedDistance == '1KM'
                                      ? Colors.blue
                                      : Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedDistance == '2KM'
                                    ? Colors.blue
                                    : Colors.grey.shade300,
                                style: BorderStyle.solid,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextButton(
                              onPressed: () {
                                selectDistance('2KM');
                              },
                              child: Text(
                                '2KM',
                                style: TextStyle(
                                  color: selectedDistance == '2KM'
                                      ? Colors.blue
                                      : Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedDistance == '5KM'
                                    ? Colors.blue
                                    : Colors.grey.shade300,
                                style: BorderStyle.solid,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextButton(
                              onPressed: () {
                                selectDistance('5KM');
                              },
                              child: Text(
                                '5KM',
                                style: TextStyle(
                                  color: selectedDistance == '5KM'
                                      ? Colors.blue
                                      : Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              // By Connection Type
              Container(
                width: double.maxFinite,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Connection type',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedConnectionType == 'CCS'
                                    ? Colors.blue
                                    : Colors.grey.shade300,
                                style: BorderStyle.solid,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextButton(
                              onPressed: () {
                                selectConnectionType('CCS');
                              },
                              child: Text(
                                'CCS',
                                style: TextStyle(
                                  color: selectedConnectionType == 'CCS'
                                      ? Colors.blue
                                      : Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedConnectionType == 'CCS2'
                                    ? Colors.blue
                                    : Colors.grey.shade300,
                                style: BorderStyle.solid,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextButton(
                              onPressed: () {
                                selectConnectionType('CCS2');
                              },
                              child: Text(
                                'CCS2',
                                style: TextStyle(
                                  color: selectedConnectionType == 'CCS2'
                                      ? Colors.blue
                                      : Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedConnectionType == 'Type2'
                                    ? Colors.blue
                                    : Colors.grey.shade300,
                                style: BorderStyle.solid,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextButton(
                              onPressed: () {
                                selectConnectionType('Type2');
                              },
                              child: Text(
                                'Type2',
                                style: TextStyle(
                                  color: selectedConnectionType == 'Type2'
                                      ? Colors.blue
                                      : Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedConnectionType == 'Chademo'
                                    ? Colors.blue
                                    : Colors.grey.shade300,
                                style: BorderStyle.solid,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextButton(
                              onPressed: () {
                                selectConnectionType('Chademo');
                              },
                              child: Text(
                                'Chademo',
                                style: TextStyle(
                                  color: selectedConnectionType == 'Chademo'
                                      ? Colors.blue
                                      : Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              //By vehicle type
              Container(
                width: double.maxFinite,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Vehicle type',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedVehicleType == '2 wheeler'
                                    ? Colors.blue
                                    : Colors.grey.shade300,
                                style: BorderStyle.solid,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextButton(
                              onPressed: () {
                                selectVehicleType('2 wheeler');
                              },
                              child: Text(
                                '2 wheeler',
                                style: TextStyle(
                                  color: selectedVehicleType == '2 wheeler'
                                      ? Colors.blue
                                      : Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedVehicleType == '3 wheeler'
                                    ? Colors.blue
                                    : Colors.grey.shade300,
                                style: BorderStyle.solid,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextButton(
                              onPressed: () {
                                selectVehicleType('3 wheeler');
                              },
                              child: Text(
                                '3 wheeler',
                                style: TextStyle(
                                  color: selectedVehicleType == '3 wheeler'
                                      ? Colors.blue
                                      : Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedVehicleType == '4 wheeler'
                                    ? Colors.blue
                                    : Colors.grey.shade300,
                                style: BorderStyle.solid,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextButton(
                              onPressed: () {
                                selectVehicleType('4 wheeler');
                              },
                              child: Text(
                                '4 wheeler',
                                style: TextStyle(
                                  color: selectedVehicleType == '4 wheeler'
                                      ? Colors.blue
                                      : Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(5)),
                child: TextButton(
                    onPressed: null,
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ],
          )
        ],
      ),
    );
  }
}

class MapboxMapController {}

// sk.eyJ1IjoibW1pZGh1biIsImEiOiJjbGZmcTQ4dGs0Nnl1M3ZyMHlxdmVlc2hrIn0.-84ODfrGmaP8gKmLWrz4QQ
