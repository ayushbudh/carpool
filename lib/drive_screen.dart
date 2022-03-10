import 'package:carpool_app/map_screen.dart';
import 'package:carpool_app/search_autocomplete_screen.dart';
import 'package:flutter/material.dart';
import 'location_services.dart';
import 'map_screen.dart' as _MapScreenState;

class DriveScreen extends StatefulWidget {
  DriveScreen();

  @override
  DriveScreenState createState() => DriveScreenState();
}

class DriveScreenState extends State<DriveScreen> {
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
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
        )),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 180.0,
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
          const SizedBox(
            height: 30.0,
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
                padding: const EdgeInsets.only(left: 15),
                child: ElevatedButton(
                  style: raisedButtonStyle,
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MapScreen(
                            _pickup.value.text, _destination.value.text)));
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
