import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:plugyourev/stationpage.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'paymentverify.dart';

class bookslot extends StatefulWidget {
  final int index;
  final String title;
  final String city;
  final List<String> charger_type;
  final List<int> ports;

  bookslot({
    required this.index,
    required this.title,
    required this.city,
    required this.charger_type,
    required this.ports,
  });

  @override
  State<bookslot> createState() => _bookslotState();
}

class _bookslotState extends State<bookslot> {
  String selectedVehicleType = '';
  //TextEditingController _vehicleTypeController = TextEditingController();

  void selectVehicleType(String vehicleType) {
    setState(() {
      selectedVehicleType = vehicleType;
      print('selectedVehicleType $selectedVehicleType');
    });
  }

// select date
  DateTime? selectedDate;
  String selected_Date = '';
  Future<void> _selectDate(BuildContext context) async {
    await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(), // Customize the date picker theme
          child: child!,
        );
      },
    ).then((picked) {
      if (picked != null && picked != selectedDate) {
        setState(() {
          selectedDate = picked;
          final DateFormat formatter = DateFormat('d/M/y');
          selected_Date = formatter.format(selectedDate!);
          // Format the date as per your requirement
          print('selectedDate $selected_Date');
        });
        _showCustomDialog(context);
      }
    });
  }

  String selected_Time = '';
  String selected_Slot = '';

  void _showCustomDialog(BuildContext context) async {
    print('entered dialogue box');
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomTimeSlotDialog(
          selected_Date: selected_Date,
          selectedConnectionType: selectedConnectionType,
          charger_type: widget.charger_type,
          ports: widget.ports,
          s_id: widget.index,
        );
      },
    );
    if (result != null) {
      setState(() {
        final selectedTime = result['selectedTime'];
        final selectedSlot = result['selectedSlot'];

        selected_Time = selectedTime.format(context);
        selected_Slot = selectedSlot;
        print('Selected_Time: $selected_Time');
        print('Selected_Slot: $selected_Slot');
      });
    }
  }

  //select time

  //String selectedTime = '';
  TextEditingController _controller = TextEditingController();
  //String selectedSlot = '';

  double amount = 0;
  @override
  void initState() {
    super.initState();

    //_controller.text = 'Select Time';
  }

  String selectedVehicle = '';
  void _openModalSheet(BuildContext context) async {
    final selectedmodel = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return vehiclemodel();
      },
    );

    if (selectedmodel != null) {
      setState(() {
        selectedVehicle = selectedmodel;
        print('selectedVehicle $selectedVehicle');
      });
    }
  }

  String selectedConnectionType = '';
  void _openConnectionTypeModal(BuildContext context) async {
    final selectedChargerType = await showModalBottomSheet<ChargerType>(
      context: context,
      builder: (BuildContext context) {
        return ConnectionTypeModalSheet(
          charger_type: widget.charger_type,
        );
      },
    );

    if (selectedChargerType != null) {
      setState(() {
        // Update the selected charger type with a blue background color
        selectedChargerType.isSelected = true;
        selectedConnectionType = selectedChargerType.name;
        print('selectedConnectionType $selectedConnectionType');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (builder) => stationpage(
                            selectedMarker: 0,
                          ))),
                  child: Icon(Icons.arrow_back_ios)),
              SizedBox(
                width: 20,
              ),
              Text(
                'Book Slot',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vehicle Type',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        topLeft: Radius.circular(20))),
                                builder: ((context) {
                                  return Container(
                                    height: 150,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'Vehicle Type',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              1,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                height: 40,
                                                width: 110,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color:
                                                        selectedVehicleType ==
                                                                '2 wheeler'
                                                            ? Colors.blue
                                                            : Colors
                                                                .grey.shade300,
                                                    style: BorderStyle.solid,
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: TextButton(
                                                  onPressed: () {
                                                    selectVehicleType(
                                                        '2 wheeler');
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    '2 wheeler',
                                                    style: TextStyle(
                                                      color:
                                                          selectedVehicleType ==
                                                                  '2 wheeler'
                                                              ? Colors.blue
                                                              : Colors.grey
                                                                  .shade300,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                height: 40,
                                                width: 110,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color:
                                                        selectedVehicleType ==
                                                                '3 wheeler'
                                                            ? Colors.blue
                                                            : Colors
                                                                .grey.shade300,
                                                    style: BorderStyle.solid,
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: TextButton(
                                                  onPressed: () {
                                                    selectVehicleType(
                                                        '3 wheeler');
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    '3 wheeler',
                                                    style: TextStyle(
                                                      color:
                                                          selectedVehicleType ==
                                                                  '3 wheeler'
                                                              ? Colors.blue
                                                              : Colors.grey
                                                                  .shade300,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                height: 40,
                                                width: 110,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color:
                                                        selectedVehicleType ==
                                                                '4 wheeler'
                                                            ? Colors.blue
                                                            : Colors
                                                                .grey.shade300,
                                                    style: BorderStyle.solid,
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: TextButton(
                                                  onPressed: () {
                                                    selectVehicleType(
                                                        '4 wheeler');
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    '4 wheeler',
                                                    style: TextStyle(
                                                      color:
                                                          selectedVehicleType ==
                                                                  '4 wheeler'
                                                              ? Colors.blue
                                                              : Colors.grey
                                                                  .shade300,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }));
                          },
                          child: Container(
                              height: 30,
                              width: 80,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey,
                                      style: BorderStyle.solid,
                                      width: 1),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  selectedVehicleType == ''
                                      ? Text(
                                          'Select your vehicle type',
                                          style: TextStyle(color: Colors.grey),
                                        )
                                      : Text(
                                          selectedVehicleType,
                                        ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey,
                                    size: 20,
                                  )
                                ],
                              ))),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vehicle model',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: GestureDetector(
                          onTap: () {
                            // showModalBottomSheet(
                            //     context: context,
                            //     builder: ((context) {
                            //       return vehiclemodel();

                            //     }));
                            _openModalSheet(context);
                          },
                          child: Container(
                              height: 30,
                              width: 80,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey,
                                      style: BorderStyle.solid,
                                      width: 1),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  selectedVehicle == ''
                                      ? Text(
                                          'Select your vehicle model',
                                          style: TextStyle(color: Colors.grey),
                                        )
                                      : Text(
                                          '$selectedVehicle',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey,
                                    size: 20,
                                  )
                                ],
                              )),
                        )),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Connection Type',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: GestureDetector(
                          onTap: () {
                            _openConnectionTypeModal(context);
                          },
                          child: Container(
                              height: 30,
                              width: 80,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey,
                                      style: BorderStyle.solid,
                                      width: 1),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  selectedConnectionType == ''
                                      ? Text(
                                          'Select your connection type',
                                          style: TextStyle(color: Colors.grey),
                                        )
                                      : Text(
                                          '$selectedConnectionType',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey,
                                    size: 20,
                                  )
                                ],
                              )),
                        )),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: GestureDetector(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: Container(
                              height: 30,
                              width: 80,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey,
                                      style: BorderStyle.solid,
                                      width: 1),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  selectedDate == null
                                      ? Text(
                                          'Select date',
                                          style: TextStyle(color: Colors.grey),
                                        )
                                      : Text(
                                          DateFormat.yMMMMd()
                                              .format(selectedDate!),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey,
                                    size: 20,
                                  )
                                ],
                              )),
                        )),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Time',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: GestureDetector(
                          child: Container(
                              height: 30,
                              width: 80,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey,
                                      style: BorderStyle.solid,
                                      width: 1),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  selected_Time == ''
                                      ? Text(
                                          'Select time',
                                          style: TextStyle(color: Colors.grey),
                                        )
                                      : Text('$selected_Time'),
                                ],
                              )),
                        )),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Slot',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: GestureDetector(
                          child: Container(
                              height: 30,
                              width: 80,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey,
                                      style: BorderStyle.solid,
                                      width: 1),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  selected_Slot == ''
                                      ? Text(
                                          'Select slot',
                                          style: TextStyle(color: Colors.grey),
                                        )
                                      : Text(' $selected_Slot'),
                                ],
                              )),
                        )),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: TextButton(
                    onPressed: () =>
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (builder) => paymentverify(
                                  chargingStationName: widget.title,
                                  city: widget.city,
                                  index: widget.index,
                                  vehicleModel: selectedVehicle,
                                  date: selected_Date,
                                  time: selected_Time,
                                  slot: selected_Slot,
                                  connectionType: selectedConnectionType,
                                ))),
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                    child: Text(
                      'Continue',
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

class CustomTimeSlotDialog extends StatefulWidget {
  const CustomTimeSlotDialog({
    super.key,
    required this.selected_Date,
    required this.s_id,
    required this.selectedConnectionType,
    required this.charger_type,
    required this.ports,
  });

  final String selected_Date;
  final int s_id;
  final String selectedConnectionType;
  final List<String> charger_type;
  final List<int> ports;

  @override
  State<CustomTimeSlotDialog> createState() => _CustomTimeSlotDialogState();
}

class _CustomTimeSlotDialogState extends State<CustomTimeSlotDialog> {
  TimeOfDay? selectedTime;
  int totalSlots = 0;

  @override
  void initState() {
    super.initState();
    fetchTotalSlots();
    //fetchBookedSlots();
  }

  Future<void> fetchTotalSlots() async {
    // Find the index of the selectedConnectionType in the charger_type list
    final index = widget.charger_type.indexOf(widget.selectedConnectionType);

    // Check if the index is valid
    if (index != -1) {
      // Get the total ports using the index
      final totalPorts = widget.ports[index];

      setState(() {
        totalSlots = totalPorts;
        print('ports $totalSlots');
      });
    }
  }

  List<String> bookedSlots = [];
  Future<void> fetchBookedSlots(String formattedTime) async {
    final collection = FirebaseFirestore.instance.collection('booking');
    try {
      QuerySnapshot querySnapshot = await collection
          .where('booked', isEqualTo: true)
          .where('date', isEqualTo: widget.selected_Date)
          .where('station_id', isEqualTo: widget.s_id)
          .where('connection_type', isEqualTo: widget.selectedConnectionType)
          .where('time', isEqualTo: formattedTime)
          .get();

      // Process the querySnapshot data
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          // Access the booking data
          Map<String, dynamic>? bookingData =
              doc.data() as Map<String, dynamic>?;
          String? slots = bookingData?['slot'] as String?;
          if (slots != null) {
            bookedSlots.add(slots);
          }

          // Perform desired actions with the booking data
          // ...
        }
        print('booked slots $bookedSlots');
      } else {
        print('no data');
      }
    } catch (e) {
      // Handle any errors that occur during the fetch
      print('Error fetching booking data: $e');
    }
  }

  String selectedSlot = '';
  int? selectedSlotIndex;
  ScrollController scrollController = ScrollController();
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentHour = now.hour;

    return AlertDialog(
      contentPadding:
          EdgeInsets.all(20), // Adjust the content padding if needed
      content: Container(
        height: 200, // Set the desired height
        width: 440, // Set the desired width
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
                alignment: Alignment.center,
                child: Text(
                  'Select Time Slot',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            SizedBox(height: 10),
            Text('${widget.selected_Date}'),
            SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 24,
                itemBuilder: (BuildContext context, int index) {
                  final time = TimeOfDay(hour: index, minute: 0);
                  final formattedTime = time.format(context);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTime = time;
                        fetchBookedSlots(formattedTime);
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[300],
                      ),
                      child: Text(formattedTime),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            if (selectedTime != null)
              Row(
                children: List<Widget>.generate(
                  totalSlots,
                  (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedSlotIndex == index) {
                          selectedSlotIndex = null; // Deselect the slot
                        } else {
                          selectedSlotIndex = index; // Select the slot
                        }
                        if (selectedSlotIndex != null) {
                          selectedSlot = 'S${selectedSlotIndex! + 1}';
                          print('Selected Slot: $selectedSlot');
                        } else {
                          print('No slot selected');
                        }
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: selectedSlotIndex == index
                            ? Colors.blue
                            : Colors.green, // Modify the color as needed
                      ),
                      child: Text('S${index + 1}'),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop({
              'selectedTime': selectedTime,
              'selectedSlot': selectedSlot
            }); // Close the custom dialog box
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}

//modal sheet for selecting vehicle model
class vehiclemodel extends StatefulWidget {
  const vehiclemodel({
    super.key,
  });

  @override
  State<vehiclemodel> createState() => _vehiclemodelState();
}

class _vehiclemodelState extends State<vehiclemodel> {
  List<String> electricVehicles = [
    'Tata Nexon EV',
    'MG ZS EV',
    'Hyundai Kona Electric',
    'Mahindra eVerito',
    'Mahindra e2o Plus',
    'Tata Tigor EV',
    'Mercedes-Benz EQC',
    'Audi e-Tron',
    'BMW i3s',
    'Jaguar I-Pace',
    'Hyundai Ioniq Electric',
    'Renault K-ZE',
    'Nissan Leaf',
    'Ather 450X',
    'Bajaj Chetak',
    'TVS iQube Electric',
    'Hero Electric Optima HS500 ER',
  ];
  List<String> filteredElectricVehicles = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredElectricVehicles = electricVehicles;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterElectricVehicles(String searchText) {
    setState(() {
      filteredElectricVehicles = electricVehicles
          .where((vehicle) =>
              vehicle.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Text('Vehicle model'),
          TextField(
            controller: _searchController,
            onChanged: (value) => _filterElectricVehicles(value),
            decoration: InputDecoration(
              hintText: 'Search Electric Vehicles',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredElectricVehicles.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(filteredElectricVehicles[index]),
                  onTap: () {
                    // Perform action when an electric vehicle is selected

                    String selectedmodel = filteredElectricVehicles[index];

                    Navigator.pop(context, selectedmodel);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// connection type
class ConnectionTypeModalSheet extends StatefulWidget {
  const ConnectionTypeModalSheet({
    super.key,
    required this.charger_type,
  });

  final List<String> charger_type;

  @override
  State<ConnectionTypeModalSheet> createState() =>
      _ConnectionTypeModalSheetState();
}

class _ConnectionTypeModalSheetState extends State<ConnectionTypeModalSheet> {
  // String selectedConnectionType = '';

  final List<ChargerType> chargerTypes = [
    ChargerType(
      name: 'CCS',
      icon: Icons.flash_on,
      chargingSpeed: '50 kW',
      isSelected: false,
    ),
    ChargerType(
      name: 'CCS2',
      icon: Icons.flash_on,
      chargingSpeed: '100 kW',
      isSelected: false,
    ),
    ChargerType(
      name: 'Type1',
      icon: Icons.ev_station,
      chargingSpeed: '22 kW',
      isSelected: false,
    ),
    ChargerType(
      name: 'Type2',
      icon: Icons.ev_station,
      chargingSpeed: '50 kW',
      isSelected: false,
    ),
    ChargerType(
      name: 'ChAdeMO',
      icon: Icons.ev_station,
      chargingSpeed: '50 kW',
      isSelected: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<ChargerType> filteredChargerTypes = chargerTypes.where((chargerType) {
      return widget.charger_type.contains(chargerType.name);
    }).toList();
    return Container(
      padding: EdgeInsets.all(16),
      child: ListView(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              'Connection Type',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: filteredChargerTypes.map((chargerType) {
              return GestureDetector(
                onTap: () {
                  print(chargerType.name);

                  Navigator.pop(context, chargerType);
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: chargerType.isSelected ? Colors.blue : Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(chargerType.icon),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chargerType.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Charging Speed: ${chargerType.chargingSpeed}',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class ChargerType {
  final String name;
  final IconData icon;
  final String chargingSpeed;
  bool isSelected;

  ChargerType({
    required this.name,
    required this.icon,
    required this.chargingSpeed,
    this.isSelected = false,
  });
}
