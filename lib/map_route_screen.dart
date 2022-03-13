import 'package:carpool_app/map_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MapRouteScreen extends StatefulWidget {
  dynamic directions;
  double widthSize;
  double heightSize;
  MapRouteScreen(this.directions, this.widthSize, this.heightSize);

  _MapRouteScreenState createState() => _MapRouteScreenState();
}

class _MapRouteScreenState extends State<MapRouteScreen> {
  Future<String>? _getDistanceInMiles() async {
    if (widget.directions['distanceInMiles'] == "") {
      return "0 mi";
    }
    return widget.directions['distanceInMiles'];
  }

  Future<String>? _getDurationToReachDestination() async {
    if (widget.directions['durationToReachDestination'] == "") {
      return "0 mi";
    }
    return widget.directions['durationToReachDestination'];
  }

  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
          color: const Color(0xff199EFF),
          borderRadius: BorderRadius.all(Radius.circular(25))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  FutureBuilder<String>(
                      future: _getDistanceInMiles(),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            '${snapshot.data.toString()}',
                            style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.bold),
                          );
                        } else {
                          return CircularProgressIndicator(
                            color: Colors.black,
                          );
                        }
                      }),
                  SizedBox(height: 20),
                  ClipOval(
                    child: SizedBox.fromSize(
                      size: Size.fromRadius(48), // Image radius
                      child: Image.network(
                          "https://images.unsplash.com/photo-1504215680853-026ed2a45def?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80",
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  FutureBuilder<String>(
                    future: _getDurationToReachDestination(),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          '${snapshot.data.toString()}',
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.bold),
                        );
                      } else {
                        return CircularProgressIndicator(
                          color: Colors.black,
                        );
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    "0 pts",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      print("Action");
                    },
                    child: Text("Ride"),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.resolveWith(
                          (Set<MaterialState> states) {
                        return states.contains(MaterialState.disabled)
                            ? null
                            : Colors.white;
                      }),
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (Set<MaterialState> states) {
                        return states.contains(MaterialState.disabled)
                            ? null
                            : Colors.red;
                      }),
                    ),
                  )
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  color: Colors.white,
                  child: Image.network(
                      'https://developers.google.com/maps/documentation/images/powered_by_google_on_white.png'),
                ),
              )
            ],
          )
        ],
      ),
    ));
  }
}
