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
    final widthSize = MediaQuery.of(context).size.width;
    final heightSize = MediaQuery.of(context).size.height;
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      onPrimary: Colors.white,
      primary: const Color(0xffFF1522),
      minimumSize: Size(widthSize * 0.20, heightSize * 0.01),
      padding: EdgeInsets.symmetric(
          horizontal: widthSize * 0.07, vertical: heightSize * 0.01),
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
                  style: TextStyle(
                      fontSize: heightSize * 0.05, color: Colors.white),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: heightSize * 0.10),
                child: Icon(Icons.account_circle, size: heightSize * 0.10),
              )
            ],
          ),
          Padding(
              padding: EdgeInsets.only(
                  bottom: heightSize * 0.10,
                  right: widthSize * 0.10,
                  left: widthSize * 0.10),
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
                      Text('Change Password',
                          style: TextStyle(fontSize: heightSize * 0.02)),
                      Padding(
                          padding: EdgeInsets.only(right: heightSize * 0.01)),
                      Icon(Icons.double_arrow, size: heightSize * 0.04),
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
                    Text('Log out',
                        style: TextStyle(fontSize: heightSize * 0.02)),
                    Padding(padding: EdgeInsets.only(right: heightSize * 0.01)),
                    Icon(Icons.logout, size: heightSize * 0.04),
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
