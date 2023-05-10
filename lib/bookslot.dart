import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:plugyourev/stationpage.dart';
import 'package:intl/intl.dart';

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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime =
        await showTimePicker(context: context, initialTime: selectedTime);

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Select your vehicle model',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey,
                                  size: 20,
                                )
                              ],
                            ))),
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
                            showModalBottomSheet(
                                context: context,
                                builder: ((context) {
                                  return Container(
                                    child: Text('connection type'),
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
                                  selectedTime == null
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
                    onPressed: () => null, //Navigator.of(context).push(
                    //MaterialPageRoute(builder: (builder) => bookslot())),
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
