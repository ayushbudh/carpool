import 'package:flutter/material.dart';

class DriveScreen extends StatefulWidget {
  const DriveScreen();

  @override
  _DriveScreenState createState() => _DriveScreenState();
}

class _DriveScreenState extends State<DriveScreen> {
  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.white,
    primary: const Color(0xff199EFF),
    minimumSize: const Size(160, 50),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
    ),
  );

  final TextEditingController _pickup = TextEditingController();
  final TextEditingController _destination = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEEEEEE),
      appBar: AppBar(
        backgroundColor: Color(0xffEEEEEE),
        shadowColor: Color(0xffEEEEEE),
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Drive",
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 100.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Icon(Icons.location_on_outlined, size: 50),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    width: 240,
                    height: 60,
                    child: TextField(
                      controller: _pickup,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Pick up',
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Icon(Icons.location_on, size: 50),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    width: 240,
                    height: 60,
                    child: TextField(
                      controller: _destination,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Destination',
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          const SizedBox(
            height: 80.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: ElevatedButton(
                  style: raisedButtonStyle,
                  onPressed: () {
                    Navigator.pushNamed(context, '/drive');
                  },
                  child: Row(
                    children: [
                      Text('Start', style: TextStyle(fontSize: 22)),
                      Padding(padding: const EdgeInsets.all(2)),
                      Icon(
                        Icons.drive_eta,
                        size: 30,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
