import 'package:flutter/material.dart';

class MapScreenProvider with ChangeNotifier {
  double mapHeight = 0.70;
  String currentWidgetState = "ROUTESCREEN";

  double get getMapHeight {
    return mapHeight;
  }

  String get getCurrentWidgetState {
    return currentWidgetState;
  }

  void setCurrentWidgetState(String newWidgetState) {
    currentWidgetState = newWidgetState;
    notifyListeners();
  }

  void setMapHeight(double newMapHeight) {
    mapHeight = newMapHeight;
    notifyListeners();
  }
}
