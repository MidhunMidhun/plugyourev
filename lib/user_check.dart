import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plugyourev/bottom_navbar.dart';

import 'package:plugyourev/login_page.dart';
import 'package:plugyourev/maparea.dart';

class UserCheck extends StatelessWidget {
  const UserCheck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print('login');
            return MyStatefulWidget();
          } else {
            print('no huh');
            return const MyLogin();
          }
        },
      ),
    );
  }
}
