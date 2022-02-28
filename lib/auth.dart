import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'dart:async';

class AuthService {
  void initialization() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final googleSignIn = GoogleSignIn();
  bool _success = false;
  String _failureReason = "None";

  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  void storeGoogleUserInCollection(UserCredential user) {
    String timestamp = DateTime.now().toString();

    if (user.additionalUserInfo?.isNewUser == true) {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection("users").doc(timestamp);

      var uuid = Uuid();
      var v1 = uuid.v1();
      Map<String, String> todoList = {
        "firstName": user.additionalUserInfo?.profile?["given_name"],
        "lastName": user.additionalUserInfo?.profile?["family_name"],
        "role": "customer",
        "timestamp": timestamp,
        "userId": v1,
      };

      documentReference
          .set(todoList)
          .whenComplete(() => print("Data stored successfully"));
    }
    return;
  }

  Future signUp(BuildContext context, String firstName, String lastName,
      String email, String password) async {
    print("Sign Up!");

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      String timestamp = DateTime.now().toString();

      DocumentReference documentReference =
          FirebaseFirestore.instance.collection("users").doc(timestamp);

      var uuid = Uuid();
      var v1 = uuid.v1();

      Map<String, String> todoList = {
        "firstName": firstName,
        "lastName": lastName,
        "role": "driver",
        "timestamp": timestamp,
        "userId": userCredential.user?.uid ?? v1,
      };

      documentReference
          .set(todoList)
          .whenComplete(() => print("Data stored successfully"));

      Navigator.of(context).pushReplacementNamed("/home");
      _success = true;
      _failureReason = "None";
      return {_success, _failureReason};
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _success = false;
        _failureReason = 'The password provided is too weak.';
        return {_success, _failureReason};
      } else if (e.code == 'email-already-in-use') {
        _success = false;
        _failureReason = 'The account already exists for that email.';
        return {_success, _failureReason};
      } else {
        _success = false;
        _failureReason = e.message.toString();
        return {_success, _failureReason};
      }
    } catch (e) {
      _success = false;
      _failureReason = e.toString();
      return {_success, _failureReason};
    }
  }

  Future sigInWithEmail(
      BuildContext context, String email, String password) async {
    print("login");

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.of(context).pushReplacementNamed("/home");
      return {_success, _failureReason};
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _success = false;
        _failureReason = 'No user found for that email.';
        return {_success, _failureReason};
      } else if (e.code == 'wrong-password') {
        _success = false;
        _failureReason = 'Wrong password provided for that user.';
        return {_success, _failureReason};
      } else {
        _success = false;
        _failureReason = e.message.toString();
        return {_success, _failureReason};
      }
    } catch (e) {
      _success = false;
      _failureReason = e.toString();
      return {_success, _failureReason};
    }
  }

  Future<String> signOut() async {
    try {
      await _auth.signOut();
      return "SUCCESS";
    } catch (e) {
      return "FAILED";
    }
  }
}
