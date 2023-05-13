import 'package:flutter/material.dart';

class PaymentMethodsPage extends StatefulWidget {
  @override
  _PaymentMethodsPageState createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  int selectedPaymentMethod = 0;
  List<String> paymentMethods = [
    'Credit Card',
    'Debit Card',
    'PayPal',
    'Google Pay',
    'Apple Pay',
  ];
  bool paymentSuccessful = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: paymentSuccessful
            ? _buildPaymentSuccessfulCard()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    'Select a Payment Method:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: paymentMethods.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: Radio<int>(
                            value: index,
                            groupValue: selectedPaymentMethod,
                            onChanged: (int? value) {
                              setState(() {
                                selectedPaymentMethod = value!;
                              });
                            },
                          ),
                          title: Text(paymentMethods[index]),
                        );
                      },
                    ),
                  ),
                  // SizedBox(
                  //   height: 50,
                  // ),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle payment method selection logic here
                        String selectedMethod =
                            paymentMethods[selectedPaymentMethod];
                        print('Selected Payment Method: $selectedMethod');

                        // Perform payment processing logic here
                        // For demonstration purposes, we will simulate a successful payment
                        _showPaymentSuccessfulCard();
                      },
                      child: Text('Proceed'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _showPaymentSuccessfulCard() {
    setState(() {
      paymentSuccessful = true;
    });
  }

  Widget _buildPaymentSuccessfulCard() {
    return Container(
      width: MediaQuery.of(context).size.width * 85,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                size: 80,
                color: Colors.green,
              ),
              SizedBox(height: 16),
              Text(
                'Payment Successful!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle button action here, such as navigating back to the previous screen
                  Navigator.pop(context);
                },
                child: Text('Done'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
