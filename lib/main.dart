import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:plugyourev/login_page.dart';
import 'package:plugyourev/register.dart';
import 'package:plugyourev/splash_screen.dart';
import 'package:plugyourev/profile_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
    routes: {
      'register': (context) => MyRegister(),
      'login_page': (context) => MyLogin(),
    },
  ));
}
