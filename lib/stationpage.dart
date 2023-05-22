import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:plugyourev/bottom_navbar.dart';
import 'package:plugyourev/maparea.dart';
import 'package:http/http.dart' as http;

import 'bookslot.dart';

class stationpage extends StatefulWidget {
  final int selectedMarker;
  stationpage({required this.selectedMarker});

  @override
  State<stationpage> createState() => _stationpageState();
}

class _stationpageState extends State<stationpage> {
  //retrieve marker data from firebase
  @override
  void initState() {
    super.initState();
    getDataFromFirebaseStorage();
  }

  FirebaseStorage storage = FirebaseStorage.instance;
  String jsonFileName = 'ev_stations_list.json';
  List<dynamic> locations = [];
  List<dynamic> markerData = [];
  int index = 0;
  String title = '';
  String city = '';
  List<String> charger_type = [];
  List<int> ports = [];

  int rating = 0;

  void getDataFromFirebaseStorage() async {
    try {
      // Get the download URL for the JSON file
      String downloadUrl =
          await storage.ref().child(jsonFileName).getDownloadURL();

      // Make an HTTP GET request to the download URL
      http.Response response = await http.get(Uri.parse(downloadUrl));
      // Check if the response is successful
      if (response.statusCode == 200) {
        // Parse the JSON data
        locations = json.decode(response.body);

        // Retrieve the marker data based on the selected marker index
        int selectedMarkerIndex =
            widget.selectedMarker - 1; // Replace with your desired index
        setState(() {
          markerData = [locations[selectedMarkerIndex]];
          List<dynamic> chargers = markerData[0]['chargers'];
          charger_type = chargers
              .map<String>((charger) => charger['charger_type'])
              .toList();
          ports = chargers.map<int>((charger) => charger['ports']).toList();

          index = markerData[0]['S.no'];
          title = markerData[0]['title'];
          city = markerData[0]['city'];
          //charger_type = markerData[0]['charger_type'];
          //ports = markerData[0]['ports'];
          //price = markerData[0]['price'];
          rating = markerData[0]['rating'];
        });
        print(markerData);
        print('S.no$index');
        print('title$title');
        print('city$city');
        //print('charger_type$charger_type');
        //print('ports$ports');
        //print('price$price');
        print(charger_type);
        print(ports);
        print('rating$rating');
      } else {
        // Handle the error
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error:here $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.28,
                width: MediaQuery.of(context).size.width * 1,
                child: Image(
                  image: NetworkImage(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR7uynsZtn6oBeQRpyLKY94qwBR-L5BGIAsL1aCR_mL&s",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 25, // Adjust the top position as needed
                left: 16, // Adjust the left position as needed
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (builder) => MyStatefulWidget()));
                    },
                  ),
                ),
              ),
            ],
          ),

          // Container(
          //     height: MediaQuery.of(context).size.height * 0.28,
          //     width: MediaQuery.of(context).size.width * 1,
          //     child: Image(
          //       image: NetworkImage(
          //         "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR7uynsZtn6oBeQRpyLKY94qwBR-L5BGIAsL1aCR_mL&s",
          //       ),
          //       fit: BoxFit.cover,
          //     )),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$title',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                // SizedBox(
                //   height: 10,
                // ),
                Text(
                  '$city',
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                // SizedBox(
                //   height: 10,
                // ),
                Container(
                  height: 20,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    itemCount: rating,
                    itemBuilder: (BuildContext context, int rating) {
                      return const Icon(
                        Icons.star,
                        color: Colors.orange,
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Amenities',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Icon(
                                  Icons.local_cafe,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Cafe',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Icon(
                                  Icons.store,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Store',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Icon(
                                  Icons.park,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Park',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Icon(
                                  Icons.local_offer,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Toilet',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Icon(
                                  Icons.restaurant,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Food',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Connection Type',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 16),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: [
                          Column(
                            children: [
                              Container(
                                width: 100,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.flash_on,
                                      color: Colors.blue,
                                      size: 30,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'CCS',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '50 kW',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '$ports ports',
                                style: TextStyle(color: Colors.green),
                              )
                            ],
                          ),
                          SizedBox(width: 16),
                          Column(
                            children: [
                              Container(
                                width: 100,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.flash_on,
                                      color: Colors.blue,
                                      size: 30,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'CCS2',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '100 kW',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '$ports ports',
                                style: TextStyle(color: Colors.green),
                              )
                            ],
                          ),
                          SizedBox(width: 16),
                          Column(
                            children: [
                              Container(
                                width: 100,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.flash_on,
                                      color: Colors.blue,
                                      size: 30,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Type1',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '22 kW',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '$ports ports',
                                style: TextStyle(color: Colors.green),
                              )
                            ],
                          ),
                          SizedBox(width: 16),
                          Column(
                            children: [
                              Container(
                                width: 100,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.flash_on,
                                      color: Colors.blue,
                                      size: 30,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Type2',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '50 kW',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '$ports ports',
                                style: TextStyle(color: Colors.green),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Column(
                            children: [
                              Container(
                                width: 100,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.flash_on,
                                      color: Colors.blue,
                                      size: 30,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Chademo',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '50 kW',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '$ports ports',
                                style: TextStyle(color: Colors.green),
                              )
                            ],
                          ),
                        ]))
                  ])),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: TextButton(
                    onPressed: () =>
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (builder) => bookslot(
                                  index: index,
                                  title: title,
                                  city: city,
                                  charger_type: charger_type,
                                  ports: ports,
                                ))),
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                    child: Text(
                      'Book Slot',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }
}
