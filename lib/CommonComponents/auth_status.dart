import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/auth_gate.dart';

class AuthStatus {
  static void initAuthCheck(BuildContext context) {
    // Check for the firebase users status
    // https://firebase.google.com/docs/auth/flutter/start#userchanges
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.userChanges().listen((User? user) {
      if (user == null) {
        // Users token etc expired, force them back to the AuthGate page.
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AuthGate()),
        );
      }
    });
  }

  // Gets the users current role. For use with future builders.
  static Future<String> getRole() async{
    User? user = FirebaseAuth.instance.currentUser;
    return await FirebaseFirestore.instance
        .collection("user_roles")
        .doc(user!.uid)
        .get()
        .then((value) {
          return value.data()!["role"];
    }).onError((error, stackTrace) => _signOut());
  }

  // A method that signs the user out.
  static Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
