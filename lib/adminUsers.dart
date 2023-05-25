import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'adminpanel.dart';

class adminUsers extends StatefulWidget {
  const adminUsers({super.key});

  @override
  State<adminUsers> createState() => _adminUsersState();
}

class _adminUsersState extends State<adminUsers> {
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
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (_) => adminpanel()));
        },
      ),
      title: Text(
        'Users',
        style: TextStyle(color: Colors.black),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
    ));
  }
}
