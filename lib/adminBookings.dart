import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:plugyourev/adminpanel.dart';

class adminBookings extends StatefulWidget {
  const adminBookings({super.key});

  @override
  State<adminBookings> createState() => _adminBookingsState();
}

class _adminBookingsState extends State<adminBookings> {
  CollectionReference bookingsRef =
      FirebaseFirestore.instance.collection('booking');

  Widget _buildOngoingBookings() {
    // Replace this with your logic to fetch and display ongoing bookings
    return FutureBuilder<QuerySnapshot>(
      future: bookingsRef.where('booked', isEqualTo: true).get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
        return Expanded(
          child: ListView.builder(
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
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => adminpanel()));
          },
        ),
        title: Text(
          'Ongoing Bookings',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            _buildOngoingBookings()
          ],
        ),
      ),
    );
  }
}
