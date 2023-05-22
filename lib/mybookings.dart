import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class mybookings extends StatefulWidget {
  const mybookings({super.key});

  @override
  State<mybookings> createState() => _mybookingsState();
}

class _mybookingsState extends State<mybookings> {
  int _selectedIndex = 0;

  CollectionReference bookingsRef =
      FirebaseFirestore.instance.collection('booking');
  late String currentUserUid;
  @override
  void initState() {
    super.initState();
    // Get the current user's UID
    currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  }

  Widget _buildOngoingBookings() {
    // Replace this with your logic to fetch and display ongoing bookings
    return FutureBuilder<QuerySnapshot>(
      future: bookingsRef
          .where('uid', isEqualTo: currentUserUid)
          .where('booked', isEqualTo: true)
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
        return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              QueryDocumentSnapshot document = documents[index];
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              String title = data['title'];
              String city = data['city'];
              String date = data['date'];
              String time = data['time'];
              String vehiclemodel = data['vehicle_model'];
              String connectiontype = data['connection_type'];
              double amount = data['amount'] ?? 0;

              return Container(
                margin: EdgeInsets.all(15),
                height: 150,
                width: MediaQuery.of(context).size.width * 0.85,
                //color: Colors.white54,
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.blue.shade200),
                    color: Colors.white54,
                    // shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image(
                        height: 140,
                        width: 150,
                        image: NetworkImage(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR7uynsZtn6oBeQRpyLKY94qwBR-L5BGIAsL1aCR_mL&s",
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$title',
                            maxLines: 2,
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '$city',
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            'for $date at $time',
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            '$vehiclemodel',
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            '$connectiontype',
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                          Row(
                            //mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Rs.$amount',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              Container(
                                height: 35,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.blue)),
                                  onPressed: () {
                                    document.reference.update({
                                      'booked': false,
                                      'cancelled': true,
                                    });
                                  },
                                  child: Text(
                                    'Cancel Order',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            });
      },
    );
  }

  Widget _buildBookingHistory() {
    // Replace this with your logic to fetch and display booking history
    return Center(
      child: Text('Booking History'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Row(
          children: [
            SizedBox(width: 8),
            Text('My Bookings'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        'Ongoing Bookings',
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              _selectedIndex == 0 ? Colors.blue : Colors.black,
                          fontWeight: _selectedIndex == 0
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 3,
                        width: 150,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 3,
                                    color: _selectedIndex == 0
                                        ? Colors.blue
                                        : Colors.transparent))),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        'Booking History',
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              _selectedIndex == 1 ? Colors.blue : Colors.black,
                          fontWeight: _selectedIndex == 1
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 3,
                        width: 150,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 3,
                                    color: _selectedIndex == 1
                                        ? Colors.blue
                                        : Colors.transparent))),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _selectedIndex == 0
                ? _buildOngoingBookings()
                : _buildBookingHistory(),
          ),
        ],
      ),
    );
  }
}
