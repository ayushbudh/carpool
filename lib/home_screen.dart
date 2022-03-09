import 'package:carpool_app/auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final AuthService _auth = new AuthService();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
        actions: [
          IconButton(
              onPressed: () async {
                if (await _auth.googleSignIn.isSignedIn()) {
                  _auth.signOutWithGoogle();
                }
                var res = await _auth.signOut();
                if (res == 'SUCCESS') {
                  Navigator.pushReplacementNamed(context, '/');
                } else {
                  print("Something went wrong. Please try again!");
                }
              },
              icon: Icon(Icons.logout))
        ],
      ),
    );
  }
}
