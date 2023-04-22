import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_search/mapbox_search.dart';

import 'searchpage_enroute.dart';

final myCenter = LatLng(8.5460815, 76.9046274);

class EnRoute extends StatefulWidget {
  bool source;
  bool destination;
  double lat;
  double lon;

  EnRoute(
      {Key? key,
      this.source = false,
      this.destination = false,
      this.lat = 0,
      this.lon = 0})
      : super(key: key);
  static const String ACCESS_TOKEN = String.fromEnvironment(
      "pk.eyJ1IjoibW1pZGh1biIsImEiOiJjbGFxYTIxODcxNDB0M3ZucGlmcWp3cHpuIn0.4ekFwyhXAkUt-zYu9ePDpQ");
  static const String mapBoxStyleId = 'clfgi2vwf00a901rxqoiggpna';

  @override
  State<EnRoute> createState() => _EnRouteState();
}

//Test Comments
class _EnRouteState extends State<EnRoute> {
  double origLat = 0;
  double origLon = 0;
  double destLat = 0;
  double destLon = 0;
  final TextEditingController controller = TextEditingController();
  List<MapBoxPlace> places = [];
  List<LatLng> points = [];

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.source) {
      print("setting source");
      origLat = widget.lat;
      origLon = widget.lon;
    }

    if (widget.destination) {
      print("setting dest");
      destLat = widget.lat;
      destLon = widget.lon;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("source");
    print(widget.source);
    print("dest");
    print(widget.destination);

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
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => MapBoxSearchScreenEnroute(
                                        target: 'source',
                                      )));
                            },
                            child: Container(
                              width: 200,
                              height: 50,
                              color: Colors.white,
                              child: Text('source'),
                            )),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => MapBoxSearchScreenEnroute(
                                        target: 'destination',
                                      )));
                            },
                            child: Container(
                              width: 200,
                              height: 50,
                              color: Colors.white,
                              child: Text('source'),
                            ))
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
