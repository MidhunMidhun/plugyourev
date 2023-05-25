import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import 'adminpanel.dart';

class adminAddStations extends StatefulWidget {
  const adminAddStations({super.key});

  @override
  State<adminAddStations> createState() => _adminAddStationsState();
}

class _adminAddStationsState extends State<adminAddStations> {
  FirebaseStorage storage = FirebaseStorage.instance;
  String jsonFileName = 'ev_stations_list.json';
  List<dynamic> locations = [];
  int dataLength = 0;

  void getDataFromFirebaseStorage() async {
    try {
      // Get the download URL for the JSON file
      String downloadUrl =
          await storage.ref().child(jsonFileName).getDownloadURL();

      // Make an HTTP GET request to the download URL
      http.Response response = await http.get(Uri.parse(downloadUrl));

      if (response.statusCode == 200) {
        // Parse the JSON data
        locations = json.decode(response.body);

        // Do something with the data

        setState(() {
          print(locations.length);
          dataLength = locations.length;
        });
      } else {
        // Handle the error
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error:here $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getDataFromFirebaseStorage();
  }

  String mapBoxStyleId = 'clfgi2vwf00a901rxqoiggpnas';
  String ACCESS_TOKEN =
      "pk.eyJ1IjoibW1pZGh1biIsImEiOiJjbGFxYTIxODcxNDB0M3ZucGlmcWp3cHpuIn0.4ekFwyhXAkUt-zYu9ePDpQ";
  final myCenter = LatLng(8.5460815, 76.9046274);
  List<Marker> markers = [];
  late LatLng coordinates = LatLng(0, 0);
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
                onTap: (tapPosition, point) {
                  // Clear existing markers
                  print('Marker coordinates: $point');
                  coordinates = point;
                  setState(() {
                    markers.clear();
                  });

                  // Add a new marker
                  setState(() {
                    markers.add(
                      Marker(
                        width: 40.0,
                        height: 40.0,
                        point: point,
                        builder: (ctx) => GestureDetector(
                            onTap: () {
                              //
                            },
                            child: Icon(
                              Icons.add_location_alt,
                              color: Colors.red,
                              size: 30,
                            )),
                      ),
                    );
                  });
                },
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
                MarkerLayer(
                  markers: markers,
                ),

                //MarkerLayer(markers: markers),
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
          if (markers.isNotEmpty)
            Positioned(
              top: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      print(dataLength);
                      return AddMarkerModalSheet(
                          markerPoint: coordinates, S_no: dataLength);
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_location),
                      SizedBox(width: 8.0),
                      Text('ADD MARKER'),
                    ],
                  ),
                ),
              ),
            ),
        ],
      )),
    );
  }
}

class AddMarkerModalSheet extends StatefulWidget {
  final LatLng markerPoint;
  final int S_no;
  AddMarkerModalSheet({required this.markerPoint, required this.S_no});
  @override
  State<AddMarkerModalSheet> createState() => _AddMarkerModalSheetState();
}

class _AddMarkerModalSheetState extends State<AddMarkerModalSheet> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> chargers = [];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  late LatLng coordinates;
  int? rating;
  int s_no = 0;

  List<String> chargerTypes = ['CCS', 'CCS2', 'Type1', 'Type2', 'ChAdeMO'];
  Map<String, List<int>> portsPerChargerType = {
    'CCS': [1, 2, 3],
    'CCS2': [1, 2, 3],
    'Type1': [1, 2, 3],
    'Type2': [1, 2, 3],
    'ChAdeMO': [1, 2, 3],
  };

  @override
  void dispose() {
    titleController.dispose();
    cityController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    coordinates = widget.markerPoint;
    print('widget.S_no : $widget.'); // Assign the value here

    s_no = widget.S_no + 1;
    print('Coordinates: $coordinates');
    print('S.no : $s_no'); // Assign the value here
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Add your modal sheet content here
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'S.no'),
              initialValue: s_no.toString(),
              enabled: false,
            ),
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            TextFormField(
              controller: cityController,
              decoration: InputDecoration(labelText: 'City'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a city';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            if (widget.markerPoint != null) ...[
              TextFormField(
                decoration: InputDecoration(labelText: 'Latitude'),
                initialValue: widget.markerPoint.latitude.toString(),
                enabled: false,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Longitude'),
                initialValue: widget.markerPoint.longitude.toString(),
                enabled: false,
              ),
            ],
            SizedBox(height: 16.0),
            Row(
              children: [
                Text(
                  'Chargers',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      chargers.add({});
                      print(coordinates);
                    });
                  },
                  child: Text('Add Charger'),
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: chargers.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text('Charger ${index + 1}'),
                    trailing: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          chargers.removeAt(index);
                        });
                      },
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<String>(
                          decoration:
                              InputDecoration(labelText: 'Charger Type'),
                          items: chargerTypes.map((String chargerType) {
                            return DropdownMenuItem<String>(
                              value: chargerType,
                              child: Text(chargerType),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              chargers[index]['charger_type'] = value;
                            });
                          },
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please select a charger type';
                            }
                            return null;
                          },
                        ),
                        DropdownButtonFormField<int>(
                          decoration: InputDecoration(labelText: 'Ports'),
                          items: chargers[index]['charger_type'] != null
                              ? portsPerChargerType[chargers[index]
                                      ['charger_type']]!
                                  .map((int port) {
                                  return DropdownMenuItem<int>(
                                    value: port,
                                    child: Text(port.toString()),
                                  );
                                }).toList()
                              : null,
                          onChanged: (value) {
                            setState(() {
                              chargers[index]['ports'] = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a port';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Price'),
                          onChanged: (value) {
                            setState(() {
                              chargers[index]['price'] = int.tryParse(value);
                            });
                          },
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter a price';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 8.0),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 16.0),
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(labelText: 'Rating'),
                  value: rating,
                  items: [1, 2, 3, 4, 5].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      rating = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a rating';
                    }
                    return null;
                  },
                ),
                // Rest of the code...
              ],
            ),
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                if (chargers.isNotEmpty) {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Form is valid, save the data
                    _saveData();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => adminpanel()));
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Please add at least one charger.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Save'),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'))
          ],
        ),
      ),
    );
  }

  void _saveData() async {
    if (_formKey.currentState?.validate() ?? false) {
      Map<String, dynamic> formData = {
        'S.no': s_no,
        'title': titleController.text,
        'city': cityController.text,
        'lat': widget.markerPoint.latitude,
        'long': widget.markerPoint.longitude,
        'chargers': chargers
            .where(
              (charger) =>
                  charger['charger_type'] != null &&
                  charger['ports'] != null &&
                  charger['price'] != null,
            )
            .toList(),
        'rating': rating,
      };

      print(formData);
      // Fetch the existing JSON data from the file
      final existingData =
          await FirebaseStorage.instance.ref('ev_stations_list.json').getData();
      final existingBytes = existingData!;
      final existingJson = json.decode(utf8.decode(existingBytes));
      // Convert the existing JSON data into a List of Maps
      final existingList = List<Map<String, dynamic>>.from(existingJson);
// Add the new data to the existing List
      existingList.add(formData);
      // Convert the updated List back to JSON
      final updatedJson = json.encode(existingList);

// Write the updated JSON data back to the file
      final updatedData = utf8.encode(updatedJson);
      // Convert the updatedData to Uint8List
      final updatedDataUint8List = Uint8List.fromList(updatedData);
      await FirebaseStorage.instance
          .ref('ev_stations_list.json')
          .putData(updatedDataUint8List);

      print('New data added to the JSON file.');
    }
  }
}
