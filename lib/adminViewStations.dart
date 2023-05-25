import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'adminpanel.dart';

class adminViewStations extends StatefulWidget {
  const adminViewStations({super.key});

  @override
  State<adminViewStations> createState() => _adminViewStationsState();
}

class _adminViewStationsState extends State<adminViewStations> {
  String mapBoxStyleId = 'clfgi2vwf00a901rxqoiggpnas';
  String ACCESS_TOKEN =
      "pk.eyJ1IjoibW1pZGh1biIsImEiOiJjbGFxYTIxODcxNDB0M3ZucGlmcWp3cHpuIn0.4ekFwyhXAkUt-zYu9ePDpQ";
  final myCenter = LatLng(8.5460815, 76.9046274);
  FirebaseStorage storage = FirebaseStorage.instance;
  List<dynamic> markersData = []; // list of JSON data representing markers
  List<Marker> markers = [];
  List<dynamic> locations = [];
  String jsonFileName = 'ev_stations_list.json';
  final pageController = PageController();
  int selectedMarker = 1;

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

  void initState() {
    super.initState();
    getDataFromFirebaseStorage();
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
              print('Marker tapped');
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
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
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
                    'mapStyleId': mapBoxStyleId,
                    'accessToken': ACCESS_TOKEN,
                  },
                ),
                MarkerLayer(markers: markers),
              ]),
          Positioned(
              top: 10,
              left: 20,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber,
                ),
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => adminpanel()));
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
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
                              Container(
                                height: 20,
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: locations[index]['rating'],
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return const Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                      size: 16,
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
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Wrap(
                                  spacing: 0,
                                  runSpacing: 5,
                                  children: locations[index]['chargers']
                                      .map<Widget>((charger) {
                                    final chargerType = charger['charger_type'];

                                    return Container(
                                      padding: EdgeInsets.all(5),
                                      // decoration: BoxDecoration(
                                      //   borderRadius: BorderRadius.circular(12),
                                      //   color: Colors.grey[300],
                                      // ),
                                      child: Text(
                                        chargerType,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              )
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
                                    child: Image(
                                      image: NetworkImage(
                                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR7uynsZtn6oBeQRpyLKY94qwBR-L5BGIAsL1aCR_mL&s",
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
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
        ],
      )),
    );
  }
}
