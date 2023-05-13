import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:plugyourev/stationpage.dart';
import 'package:intl/intl.dart';

import 'paymentverify.dart';

class bookslot extends StatefulWidget {
  const bookslot({super.key});

  @override
  State<bookslot> createState() => _bookslotState();
}

class _bookslotState extends State<bookslot> {
  String selectedVehicleType = '';
  //TextEditingController _vehicleTypeController = TextEditingController();

  void selectVehicleType(String vehicleType) {
    setState(() {
      selectedVehicleType = vehicleType;
    });
  }

// select date
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        //final DateFormat formatter = DateFormat('ddMMyyyy');
        // Format the date as per your requirement
      });
    }
  }

  //select time
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController _controller = TextEditingController();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime =
        await showTimePicker(context: context, initialTime: selectedTime);

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
        //_controller.text = pickedTime.format(context);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //_controller.text = 'Select Time';
  }

  String selectedVehicle = 'Select Vehicle model';
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
      });
    }
  }

  void _openConnectionTypeModal(BuildContext context) async {
    final selectedChargerType = await showModalBottomSheet<ChargerType>(
      context: context,
      builder: (BuildContext context) {
        return ConnectionTypeModalSheet();
      },
    );

    if (selectedChargerType != null) {
      setState(() {
        // Update the selected charger type with a blue background color
        selectedChargerType.isSelected = true;
      });
    }
  }

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
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (builder) => stationpage())),
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
                                  selectedVehicle != ''
                                      ? Text(selectedVehicle)
                                      : Text(
                                          'Select your vehicle model',
                                          style: TextStyle(color: Colors.grey),
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
                                  Text(
                                    'Select your connection type',
                                    style: TextStyle(color: Colors.grey),
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
                                      : Text(DateFormat.yMMMMd()
                                          .format(selectedDate)),
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
                          onTap: () {
                            _selectTime(context);
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
                                  selectedTime == TimeOfDay.now()
                                      ? Text(
                                          'Select time',
                                          style: TextStyle(color: Colors.grey),
                                        )
                                      : Text(selectedTime.format(context)),
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
            height: 70,
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
                                  chargingStationName: "SELECTED STATION",
                                  vehicleModel: 'Hyundai',
                                  date: '22/10/2023',
                                  time: '3:00 PM',
                                  connectionType: 'CCS',
                                  amountToPay: 20.5,
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
  @override
  State<ConnectionTypeModalSheet> createState() =>
      _ConnectionTypeModalSheetState();
}

class _ConnectionTypeModalSheetState extends State<ConnectionTypeModalSheet> {
  String selectedConnectionType = '';
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
      name: 'Type 1',
      icon: Icons.ev_station,
      chargingSpeed: '15 kW',
      isSelected: false,
    ),
    ChargerType(
      name: 'Type 2',
      icon: Icons.ev_station,
      chargingSpeed: '22 kW',
      isSelected: false,
    ),
    ChargerType(
      name: 'CHAdeMO',
      icon: Icons.ev_station,
      chargingSpeed: '50 kW',
      isSelected: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
            children: chargerTypes.map((chargerType) {
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
