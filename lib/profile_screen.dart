import 'package:carpool_app/auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final AuthService _auth = AuthService();
  late TextEditingController _emailController;

  @override
  void initState() {
    _emailController = TextEditingController(text: _auth.getEmail());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      onPrimary: Colors.white,
      primary: const Color(0xffFF1522),
      minimumSize: const Size(80, 30),
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 17),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
    );

    return Container(
      color: const Color(0xff199EFF),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 80, bottom: 20),
                child: Text(
                  'Profile',
                  style: TextStyle(fontSize: 32, color: Colors.white),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Icon(Icons.account_circle, size: 80),
              )
            ],
          ),
          Padding(
              padding: const EdgeInsets.only(bottom: 100, right: 20, left: 20),
              child: Container(
                child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            backgroundColor: Color(0xff199EFF)),
                        filled: true,
                        enabled: false)),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  style: raisedButtonStyle,
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text('Change Password', style: TextStyle(fontSize: 17)),
                      Padding(padding: const EdgeInsets.all(2)),
                      Icon(Icons.double_arrow),
                    ],
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: raisedButtonStyle,
                onPressed: () async {
                  var res = await _auth.signOut();
                  if (res == 'SUCCESS') {
                    Navigator.of(context)
                        .pushReplacementNamed('/launchscreenoptions');
                  } else {
                    print("Something went wrong. Please try again!");
                  }
                },
                child: Row(
                  children: [
                    Text('Log out', style: TextStyle(fontSize: 17)),
                    Padding(padding: const EdgeInsets.all(2)),
                    Icon(Icons.logout),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
