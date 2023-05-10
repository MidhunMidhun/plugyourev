import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //signup
  Future<String> signupUser({
    required String name,
    required String email,
    required String password,

    // required String name,
    // required String type
  }) async {
    String result = "some error occured";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        //register
        UserCredential credentials = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        //add college to database
        try {
          await _firestore.collection('users').doc(credentials.user!.uid).set({
            'name': name,
            'email': email,
            'uid': credentials.user!.uid,
          });
        } catch (e) {
          print(e.toString());
        }

        result = "success";
      }
    } catch (err) {
      result = err.toString();
    }
    return result;
  }

  //login user
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "some error occured";

    try {
      print("trying to login");
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
        print("login");
      } else {
        res = "Please enter all fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
