import 'package:carpool_app/map_screen.dart';
import 'package:carpool_app/search_autocomplete_screen.dart';
import 'package:flutter/material.dart';
import 'map_screen.dart';

class DriveScreen extends StatefulWidget {
  DriveScreen();

  @override
  DriveScreenState createState() => DriveScreenState();
}

class DriveScreenState extends State<DriveScreen> {
  final TextEditingController _pickup = TextEditingController();
  final TextEditingController _destination = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final widthSize = MediaQuery.of(context).size.width;
    final heightSize = MediaQuery.of(context).size.height;

    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      onPrimary: Colors.white,
      primary: const Color(0xff199EFF),
      minimumSize: Size(widthSize * 0.20, heightSize * 0.02),
      padding: EdgeInsets.symmetric(
          horizontal: widthSize * 0.07, vertical: heightSize * 0.02),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xffEEEEEE),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Center(
            child: Text(
          "Drive",
          style: TextStyle(
              fontSize: heightSize * 0.05,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        )),
      ),
      body: Column(
        children: [
          SizedBox(
            height: heightSize * 0.20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Icon(Icons.location_on_outlined, size: heightSize * 0.065),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: 240,
                    height: 60,
                    child: TextField(
                      controller: _pickup,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                SearchAutoCompleteScreen(_pickup)));
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Origin',
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: heightSize * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Icon(Icons.location_on, size: heightSize * 0.065),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: 240,
                    height: 60,
                    child: TextField(
                      controller: _destination,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                SearchAutoCompleteScreen(_destination)));
                      },
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
                padding: EdgeInsets.only(left: widthSize * 0.01),
                child: ElevatedButton(
                  style: raisedButtonStyle,
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MapScreen(
                            _pickup.value.text, _destination.value.text)));
                  },
                  child: Row(
                    children: [
                      Text('Start',
                          style: TextStyle(fontSize: heightSize * 0.03)),
                      Padding(
                          padding: EdgeInsets.only(right: widthSize * 0.01)),
                      Icon(
                        Icons.drive_eta,
                        size: heightSize * 0.04,
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
