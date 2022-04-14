import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

class FirebaseService {
  void initialization() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static String currentUserRole = "NONE";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestoredb = FirebaseFirestore.instance;

  final googleSignIn = GoogleSignIn();
  String _failureReason = "None";

  String getCurrentUserRole() {
    return currentUserRole;
  }

  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  Future<String> storeGoogleUserInCollection(
      UserCredential user, String role) async {
    String timestamp = DateTime.now().toString();
    var uuid = Uuid();
    var v1 = uuid.v1();

    if (user.additionalUserInfo?.isNewUser == true) {
      DocumentReference documentReference =
          _firestoredb.collection("users").doc(user.user?.uid);

      Map<String, String> userObject = {
        "firstName": user.additionalUserInfo?.profile?["given_name"],
        "lastName": user.additionalUserInfo?.profile?["family_name"],
        "role": role,
        "timestamp": timestamp,
        "userId": user.user?.uid ?? v1,
      };

      currentUserRole = role;

      documentReference
          .set(userObject)
          .whenComplete(() => print("Data stored successfully"));

      return "SUCCESS";
    } else {
      var data = await _firestoredb
          .collection("users")
          .doc(_auth.currentUser?.uid)
          .get();

      currentUserRole = data.data()!["role"];

      if (currentUserRole != role) {
        return "FAILURE";
      }

      return "SUCCESS";
    }
  }

  // have to work on this function to get role of the current logged in user
  Future<Map> getFullName() async {
    print(currentUserRole);
    var data = await _firestoredb
        .collection("users")
        .doc(_auth.currentUser?.uid)
        .get();

    return {
      "firstName": data.data()!["firstName"],
      "lastName": data.data()!["lastName"]
    };
  }

  Future<String> signInSignUpWithGoogle(String role) async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider
            .addScope('https://www.googleapis.com/auth/contacts.readonly');
        googleProvider.setCustomParameters({'login_hint': 'user@example.com'});
        UserCredential user = await _auth.signInWithPopup(googleProvider);
        String response = await storeGoogleUserInCollection(user, role);
        if (response == "FAILURE") {
          _failureReason = 'Please login as ${role}';
        } else {
          _failureReason = "None";
        }
        return _failureReason;
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        // Once signed in, return the UserCredential
        UserCredential user = await _auth.signInWithCredential(credential);
        print(user);
        String response = await storeGoogleUserInCollection(user, role);
        if (response == "FAILURE") {
          _failureReason = 'Please login as ${role}';
        } else {
          _failureReason = "None";
        }
        return _failureReason;
      }
    } catch (e) {
      _failureReason = e.toString();
      return _failureReason;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> newRiderRequest() {
    return _firestoredb
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .collection("requests")
        .snapshots();
  }

  void changeIsDrivingStatus(bool status) async {
    await _firestoredb
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .update({"isDriving": status});
  }

  Future<String> newDriveRequest() async {
    // created index for this using role and userId based on ascending order

    var docQuery = await _firestoredb
        .collection("users")
        .where("role", isEqualTo: 'driver')
        .where("userId", isNotEqualTo: _auth.currentUser!.uid)
        .where("isDriving", isEqualTo: true)
        .get();

    CollectionReference riderRequestcollectionReference = await _firestoredb
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .collection("requests");

    if (docQuery.docs.isEmpty) {
      riderRequestcollectionReference
          .doc("DUNAVAILABLE")
          .set({"status": "DUNAVAILABLE"});
      return "DUNAVAILABLE";
    } else {
      var doc = await riderRequestcollectionReference.doc("DUNAVAILABLE").get();
      if (doc.exists) {
        riderRequestcollectionReference
            .doc("DUNAVAILABLE")
            .delete()
            .then((value) => print("Delete DUNAVAILABLE document"))
            .catchError(
                (error) => print("Failed to delete DUNAVAILABLE document"));
      }
    }

    DocumentReference documentReference = docQuery.docs[0].reference;
    String driverDocumentID = documentReference.id;

    CollectionReference driverRequestsCollection =
        documentReference.collection("requests");
    String currentTime = DateTime.now().toString();

    try {
      await driverRequestsCollection.doc(_auth.currentUser!.uid).set({
        "timeStamp": currentTime,
        "status": "PENDING",
        "riderId": _auth.currentUser!.uid
      });

      riderRequestcollectionReference.doc(driverDocumentID).set({
        "timeStamp": currentTime,
        "status": "PENDING",
        "driverId": driverDocumentID
      });

      return "PENDING";
    } catch (err) {
      await driverRequestsCollection.doc(_auth.currentUser!.uid).set({
        "timeStamp": currentTime,
        "status": "ERROR",
        "riderId": _auth.currentUser!.uid
      });

      riderRequestcollectionReference.doc(driverDocumentID).set({
        "timeStamp": currentTime,
        "status": "ERROR",
        "driverId": driverDocumentID
      });

      return "ERROR";
    }
  }

  Future<bool> changeRideRequestStatus(String status) async {
    try {
      var doc = await _firestoredb
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("requests")
          .get();

      String riderDocumentId = doc.docs[0].reference.id;
      await doc.docs[0].reference.update({"status": status});

      await _firestoredb
          .collection("users")
          .doc(riderDocumentId)
          .collection("requests")
          .doc(_auth.currentUser!.uid)
          .update({"status": status});

      return true;
    } catch (err) {
      return false;
    }
  }

  void signOutWithGoogle() async {
    currentUserRole = "NONE";
    await googleSignIn.disconnect();
  }

  Future signUp(BuildContext context, String firstName, String lastName,
      String email, String password, String role) async {
    print("Sign Up!");

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      String timestamp = DateTime.now().toString();
      DocumentReference documentReference =
          _firestoredb.collection("users").doc(userCredential.user?.uid);
      var uuid = Uuid();
      var v1 = uuid.v1();
      currentUserRole = role;

      Map<String, String> todoList = {
        "firstName": firstName,
        "lastName": lastName,
        "role": role,
        "timestamp": timestamp,
        "userId": userCredential.user?.uid ?? v1,
      };

      documentReference
          .set(todoList)
          .whenComplete(() => print("Data stored successfully"));

      Navigator.of(context).pushReplacementNamed("/home");
      _failureReason = "None";
      return _failureReason;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _failureReason = 'The password provided is too weak.';
        return _failureReason;
      } else if (e.code == 'email-already-in-use') {
        _failureReason = 'The account already exists for that email.';
        return _failureReason;
      } else {
        _failureReason = e.message.toString();
        return _failureReason;
      }
    } catch (e) {
      _failureReason = e.toString();
      return _failureReason;
    }
  }

  Future sigInWithEmail(
      BuildContext context, String email, String password, String role) async {
    print("login");

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      var data = await _firestoredb
          .collection("users")
          .doc(_auth.currentUser?.uid)
          .get();

      currentUserRole = data.data()!["role"];
      print("currentUserRole" + currentUserRole);
      print("role" + role);
      if (currentUserRole != role) {
        _failureReason = 'Please sign in as a ${currentUserRole}';
      } else {
        Navigator.of(context).pushReplacementNamed("/home");
        _failureReason = "None";
      }
      return _failureReason;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _failureReason = "User not found";
        return _failureReason;
      } else if (e.code == 'wrong-password') {
        _failureReason = 'Wrong password provided for that user.';
        return _failureReason;
      } else {
        _failureReason = e.message.toString();
        return _failureReason;
      }
    } catch (e) {
      _failureReason = e.toString();
      return _failureReason;
    }
  }

  String getEmail() {
    if (_auth.currentUser != null) {
      return _auth.currentUser!.email ?? "Trouble getting email.";
    }
    return "Email found not found.";
  }

  Future<String> signOut() async {
    if (_auth.currentUser != null) {
      try {
        await _auth.signOut();
        currentUserRole = "NONE";
        return "SUCCESS";
      } catch (e) {
        return "FAILED";
      }
    }
    return "FAILED";
  }
}
