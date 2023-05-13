import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'paymentmethods.dart';

class paymentverify extends StatefulWidget {
  final String chargingStationName;
  final String vehicleModel;
  final String date;
  final String time;
  final String connectionType;
  final double amountToPay;

  paymentverify({
    required this.chargingStationName,
    required this.vehicleModel,
    required this.date,
    required this.time,
    required this.connectionType,
    required this.amountToPay,
  });
  @override
  State<paymentverify> createState() => _paymentverifyState();
}

class _paymentverifyState extends State<paymentverify> {
  double convenienceFee = 4;
  double tax = 0.2;

  @override
  Widget build(BuildContext context) {
    double nTax = widget.amountToPay * tax;
    double payAmount = widget.amountToPay + convenienceFee + nTax;
    return Scaffold(
        body: Container(
      color: Colors.blue.shade200,
      padding: EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  SizedBox(height: 8),
                  Text(
                    widget.chargingStationName,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Booking Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 1,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Date:',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        widget.date,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Time:',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        widget.time,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Vehicle:',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        widget.vehicleModel,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Connection Type',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        widget.connectionType,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Charging Fee',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        widget.amountToPay.toString(),
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Convenience fee',
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        '$convenienceFee',
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tax',
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        '${nTax.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Amount to pay: Rs ${payAmount}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentMethodsPage(),
                    ),
                  );
                },
                child: Text('Make Payment'),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
