import 'dart:async';
import 'package:carpool_app/screens/driver_screens/map_new_rider_widget.dart';
import 'package:carpool_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:carpool_app/services/location_services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carpool_app/services/map_screen_provider.dart';
import 'package:provider/provider.dart';
import 'package:carpool_app/screens/driver_screens/map_drive_widget.dart';
import 'package:carpool_app/services/map_metrics_service.dart';
import 'driver_screens/map_drive_widget.dart';
import 'rider_screens/map_new_rider_pending_request_widget.dart';

class MapScreen extends StatefulWidget {
  final String origin;
  final String destination;
  MapScreen(this.origin, this.destination);
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
    // _getUserLocation();
    _getRoute(widget.origin, widget.destination);
  }

  final AuthService _auth = AuthService();

  var directions;
  late BitmapDescriptor customIcon;
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> _polylines = Set<Polyline>();
  static LatLng latlng = LatLng(99999, 99999);

  Future<LatLng> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    latlng = LatLng(position.latitude, position.longitude);
    setState(() {
      latlng = LatLng(position.latitude, position.longitude);
      _markers.add(
        Marker(
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
          markerId: MarkerId('marker1'),
          position: latlng,
        ),
      );
    });
    return latlng;
  }

  void _setOriginMarker(LatLng point) {
    setState(() {
      _markers.add(
        Marker(
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
          markerId: MarkerId('marker1'),
          position: point,
        ),
      );
    });
  }

  void _setDestMarker(LatLng point) {
    setState(() {
      _markers.add(
        Marker(
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          markerId: MarkerId('marker2'),
          position: point,
        ),
      );
    });
  }

  void _setPolyline(List<PointLatLng> points) {
    const String polylineIdVal = 'polyline_1';

    setState(() {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId(polylineIdVal),
          width: 4,
          color: Colors.blue,
          points: points
              .map(
                (point) => LatLng(point.latitude, point.longitude),
              )
              .toList(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final widthSize = MediaQuery.of(context).size.width;
    final heightSize = MediaQuery.of(context).size.height;
    return latlng.latitude == 99999 && latlng.longitude == 99999
        ? Container(
            alignment: Alignment.center,
            child: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              actions: [],

              iconTheme: IconThemeData(
                color: Colors.red, //change your color here
              ),
              leading: new IconButton(
                icon: new Icon(
                  Icons.arrow_circle_left_sharp,
                  color: Colors.red,
                  size: 35,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: Colors.transparent, elevation: 0, // 1
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        height: heightSize *
                            context.watch<MapScreenProvider>().getMapHeight,
                        width: widthSize,
                        child: GoogleMap(
                          myLocationButtonEnabled: true,
                          mapType: MapType.normal,
                          markers: _markers,
                          polylines: _polylines,
                          initialCameraPosition: CameraPosition(
                            target: latlng,
                            zoom: 14.4746,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                decideWidget(
                    context.watch<MapScreenProvider>().getCurrentWidgetState,
                    directions,
                    widthSize,
                    heightSize)
              ],
            ));
  }

  Widget decideWidget(String currentWidgetState, var directions,
      double widthSize, double heightSize) {
    if (currentWidgetState == "ROUTESCREEN") {
      return MapRouteScreen();
    } else if (currentWidgetState == "DRIVESCREEN") {
      // for drivers
      return decideDriveNewRiderScreenWidget(heightSize);
    } else {
      // for riders: currentWidgetState == RIDESCEEN
      return decideNewRideDriverScreenWidget(heightSize);
    }
  }

  Widget decideNewRideDriverScreenWidget(double heightSize) {
    Widget child;
    child = MapNewRiderPendingRequestWidget(context, heightSize);
    return Expanded(
        child: Container(
            height: heightSize * 0.20,
            decoration: BoxDecoration(
                color: const Color(0xff199EFF),
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [child])));
  }

  Widget decideDriveNewRiderScreenWidget(double heightSize) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _auth.newRiderRequest(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          Widget child;
          if (snapshot.hasError) {
            child = const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            );
          } else {
            if (snapshot.data?.docs.isEmpty ?? true) {
              child = MapDriveWidget(context, directions, heightSize);
            } else {
              // child = Text('${snapshot.data!.docs.single.data()}');
              child = MapNewRiderWidget(
                  heightSize, snapshot.data?.docs.first.data(), directions);
            }
          }

          return Container(
              height: heightSize * 0.20,
              decoration: BoxDecoration(
                  color: const Color(0xff199EFF),
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [child]));
        },
      ),
    );
  }

  Widget MapRouteScreen() {
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
                      future: getDistanceInMiles(directions),
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
                      context.read<MapScreenProvider>().setMapHeight(0.75);
                      if (_auth.getCurrentUserRole() == 'driver') {
                        context
                            .read<MapScreenProvider>()
                            .setCurrentWidgetState("DRIVESCREEN");
                      } else {
                        context
                            .read<MapScreenProvider>()
                            .setCurrentWidgetState("RIDESCEEN");
                      }
                    },
                    child: _auth.getCurrentUserRole() == 'driver'
                        ? Text("Start Ride")
                        : Text("Find Ride"),
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

  void _getRoute(String origin, String destination) async {
    directions = await LocationService().getDirections(
      origin,
      destination,
    );

    _goToPlace(
      directions['start_location']['lat'],
      directions['start_location']['lng'],
      directions['end_location']['lat'],
      directions['end_location']['lng'],
      directions['bounds_ne'],
      directions['bounds_sw'],
    );

    _setPolyline(directions['polyline_decoded']);
  }

  Future<void> _goToPlace(
    double lat,
    double lng,
    double endlat,
    double endlng,
    Map<String, dynamic> boundsNe,
    Map<String, dynamic> boundsSw,
  ) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 12),
      ),
    );

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
            northeast: LatLng(boundsNe['lat'], boundsNe['lng']),
          ),
          20),
    );
    _setOriginMarker(LatLng(lat, lng));
    _setDestMarker(LatLng(endlat, endlng));
  }
}
