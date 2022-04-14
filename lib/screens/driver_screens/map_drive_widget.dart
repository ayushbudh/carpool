import 'package:carpool_app/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:carpool_app/services/map_screen_provider.dart';
import 'package:provider/provider.dart';
import 'package:carpool_app/services/map_metrics_service.dart';

Widget MapDriveWidget(FirebaseService _auth, BuildContext context,
    var directions, double heightSize) {
  return Expanded(
      child: Container(
    height: heightSize * 0.30,
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
                    future: getDistanceInMiles(directions),
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
                    }),
                SizedBox(height: heightSize * 0.02),
                ClipOval(
                  child: SizedBox.fromSize(
                    size: Size.fromRadius(40), // Image radius
                    child: Image.network(
                        "https://images.unsplash.com/photo-1504215680853-026ed2a45def?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80",
                        width: 2,
                        height: 2,
                        fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                FutureBuilder<String>(
                  future: getDurationToReachDestination(directions),
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
                SizedBox(height: heightSize * 0.02),
                Text(
                  "0 Riders",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(height: heightSize * 0.02),
                ElevatedButton(
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
                  onPressed: () {
                    _auth.changeIsDrivingStatus(false);
                    context.read<MapScreenProvider>().setMapHeight(0.70);
                    context
                        .read<MapScreenProvider>()
                        .setCurrentWidgetState("ROUTESCREEN");
                  },
                  child: Text("Cancel Ride"),
                ),
              ],
            ),
          ],
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Padding(
        //       padding: const EdgeInsets.only(top: 20),
        //       child: Container(
        //         color: Colors.white,
        //         child: Image.network(
        //             'https://developers.google.com/maps/documentation/images/powered_by_google_on_white.png'),
        //       ),
        //     )
        //   ],
        // )
      ],
    ),
  ));
}
