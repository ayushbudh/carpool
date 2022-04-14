import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:carpool_app/services/map_screen_provider.dart';
import 'package:provider/provider.dart';

Widget MapNewRiderCreateRequestWidget(
    BuildContext context, double heightSize, String riderRequestStatus) {
  return Expanded(
      child: Container(
    height: heightSize * 0.25,
    decoration: const BoxDecoration(
        color: Color(0xff199EFF),
        borderRadius: BorderRadius.all(Radius.circular(25))),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            JumpingDotsProgressIndicator(fontSize: 50.0, color: Colors.white),
          ],
        ),
        riderRequestStatus == "CREATE"
            ? const Text("Looking for drivers...",
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.bold))
            : const Text("Driver found..awaiting response",
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.bold)),
        ElevatedButton(
          style: ButtonStyle(
            foregroundColor:
                MaterialStateProperty.resolveWith((Set<MaterialState> states) {
              return states.contains(MaterialState.disabled)
                  ? null
                  : Colors.white;
            }),
            backgroundColor:
                MaterialStateProperty.resolveWith((Set<MaterialState> states) {
              return states.contains(MaterialState.disabled)
                  ? null
                  : Colors.red;
            }),
          ),
          onPressed: () {
            context.read<MapScreenProvider>().setMapHeight(0.70);
            context
                .read<MapScreenProvider>()
                .setCurrentWidgetState("ROUTESCREEN");
          },
          child: Text("Cancel Ride"),
        ),
      ],
    ),
  ));
}
