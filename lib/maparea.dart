import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:plugyourev/profile_page.dart';
import 'package:mapbox_search/mapbox_search.dart';

import 'bottom_navbar.dart';
import 'chat_page.dart';
import 'en_route.dart';

const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoibW1pZGh1biIsImEiOiJjbGFxYTIxODcxNDB0M3ZucGlmcWp3cHpuIn0.4ekFwyhXAkUt-zYu9ePDpQ';

final myCenter = LatLng(8.5460815, 76.9046274);

class MapArea extends StatefulWidget {
  static const String ACCESS_TOKEN = String.fromEnvironment(
      "pk.eyJ1IjoibW1pZGh1biIsImEiOiJjbGFxYTIxODcxNDB0M3ZucGlmcWp3cHpuIn0.4ekFwyhXAkUt-zYu9ePDpQ");
  static const String mapBoxStyleId = 'clfgi2vwf00a901rxqoiggpnas';
  const MapArea({Key? key}) : super(key: key);

  @override
  State createState() => MapAreaState();
}

class MapAreaState extends State<MapArea> {
  var _mapController;
  // var _selectedIndex = 0;

//search places
  String baseUrl = 'https://api.mapbox.com/geocoding/v5/mapbox.places';
  String searchType = 'place%2Cpostcode%2Caddress';
  String searchResultsLimit = '5';
  String proximity = 'ip';
  String country = 'in';

  Dio _dio = Dio();

  Future getSearchResultsFromQueryUsingMapbox(String searchtext) async {
    String url =
        '$baseUrl/$searchtext.json?&proximity=$proximity&access_token=$MAPBOX_ACCESS_TOKEN';
    url = Uri.parse(url).toString();
    // String url =
    //     '$baseUrl/$searchtext.json?country=$country&limit=$searchResultsLimit&proximity=$proximity&types=$searchType&access_token=$MAPBOX_ACCESS_TOKEN';
    // url = Uri.parse(url).toString();
    print(url);
    try {
      _dio.options.contentType = Headers.jsonContentType;
      final responseData = await _dio.get(url);
      print(responseData.data);
      return responseData.data;
    } catch (e) {
      var DioExceptions;
      final errorMessage = DioExceptions.fromDioError(e as DioError).toString();
      debugPrint(errorMessage);
    }
  }

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
  // late TextEditingController _textEditingController;
  late final PlacesSearch _searchApi;
  final TextEditingController _searchController = TextEditingController();
  List<MapBoxPlace> _places = [];
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _textEditingController = TextEditingController();
    _searchApi = PlacesSearch(
      apiKey: MAPBOX_ACCESS_TOKEN,
      country: 'in',
    );
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
    });
  }

// search widget
  // MapBoxAutoCompleteWidget autoCompleteWidget = MapBoxAutoCompleteWidget(
  //   apiKey: MAPBOX_ACCESS_TOKEN,
  //   hint: 'Enter a location',
  //   language: 'en',
  //   onSelect: (place) {
  //     // Do something with the selected place
  //   },
  // );

  void _search() async {
    String query = _searchController.text;
    if (query.isNotEmpty) {
      String url =
          'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?access_token=$ACCESS_TOKEN';
      http.Response response = await http.get(Uri.parse(url));
      // TODO: Handle the response and display the search results on the map.
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_new

    return Scaffold(
        body: Stack(children: [
      FlutterMap(
          options: MapOptions(
            center: myCenter,
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
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(8.5118297, 76.9648622),
                  builder: (context) {
                    return Container(
                      child: const Icon(
                        Icons.ev_station,
                        color: Colors.green,
                        size: 30,
                      ),
                    );
                  },
                ),
                Marker(
                  point: LatLng(8.5526740, 76.9430233),
                  builder: (context) {
                    return Container(
                      child: const Icon(
                        Icons.ev_station,
                        color: Colors.green,
                        size: 30,
                      ),
                    );
                  },
                )
              ],
            ),
          ]),
      Positioned(
          top: 60,
          child: Container(
            child: Row(
              children: [
                Container(
                  width: 330,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: CupertinoSearchTextField(
                    controller: _textEditingController,
                    onChanged: _onSearch,
                    onTap: _search,
                    backgroundColor: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    placeholder: 'Search',
                  ),

                  // autoCompleteWidget,
                ),
                // Expanded(
                //   child: ListView.builder(
                //     itemCount: _places.length,
                //     itemBuilder: (BuildContext context, int index) {
                //       final place = _places[index];
                //       return ListTile(
                //         title: Text(place.placeName ?? ''),
                //         subtitle: Text(place.text ?? ''),
                //         onTap: () {
                //           Navigator.of(context).pop(place);
                //         },
                //       );
                //     },
                //   ),
                // ),
                Container(
                  width: 50,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue[400]),
                  child: IconButton(
                      onPressed: null,
                      iconSize: 30,
                      icon: Icon(
                        Icons.filter_list,
                        color: Colors.white,
                      )),
                ),
              ],
            ),
          )),
      Positioned(
          bottom: 170,
          right: 10,
          child: Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            child: IconButton(
                onPressed: _getCurrentLocation,
                icon: Icon(
                  Icons.gps_fixed,
                  color: Colors.blue,
                  size: 30,
                )),
          )),
      Positioned(
        bottom: 30,
        left: 20,
        child: Container(
          height: 130,
          width: 360,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 8, left: 8),
                    child: Image(
                      height: 110,
                      width: 100,
                      image: AssetImage('assets/start1.jpg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                          padding: EdgeInsets.all(5),
                          child: Column(children: [
                            Row(
                              children: [
                                Container(
                                  child: Icon(Icons.star,
                                      color: Colors.amber, size: 20),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Electric Vehicle Charging Station',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    height: 1,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [Text('Nalanchira')],
                            ),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'Connection:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Type2  CCS',
                                      style: TextStyle(fontSize: 10),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    TextButton(
                                        onPressed: null,
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.blue[600])),
                                        child: Text(
                                          'Get Direction',
                                          style: TextStyle(color: Colors.white),
                                        ))
                                  ],
                                )
                              ],
                            )
                          ]))
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      )
    ]));
  }
}

class MapboxMapController {}

// sk.eyJ1IjoibW1pZGh1biIsImEiOiJjbGZmcTQ4dGs0Nnl1M3ZyMHlxdmVlc2hrIn0.-84ODfrGmaP8gKmLWrz4QQ
