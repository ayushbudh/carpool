import 'dart:async';
import 'package:flutter/material.dart';
import 'package:carpool_app/location_services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  dynamic directions;
  final String origin;
  final String destination;

  MapScreen(this.origin, this.destination);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  var directions;
  late BitmapDescriptor customIcon;
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> _polylines = Set<Polyline>();
  static LatLng latlng = LatLng(99999, 99999);

  Future<LatLng> _getUserLocation() async {
    print("GET USER METHOD RUNNING =========");

    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
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
    print("======LAT LNG =======");
    print(latlng);
    return latlng;
  }

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _getRoute(widget.origin, widget.destination);
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
                        height: 500,
                        width: 391,
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
                Expanded(
                    // children: [
                    child: Container(
                  color: Colors.blue,
                  height: 60,
                  width: 391,
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
                                        '${snapshot.data.toString()} miles',
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
                                onPressed: () {},
                                child: Text("Ride"),
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.resolveWith(
                                          (Set<MaterialState> states) {
                                    return states
                                            .contains(MaterialState.disabled)
                                        ? null
                                        : Colors.white;
                                  }),
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith(
                                          (Set<MaterialState> states) {
                                    return states
                                            .contains(MaterialState.disabled)
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
                ))
              ],
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

  Future<String>? _getDistanceInMiles() async {
    if (directions['distanceInMiles'] == "") {
      return "0 mi";
    }
    return directions['distanceInMiles'];
  }

  Future<String>? _getDurationToReachDestination() async {
    if (directions['durationToReachDestination'] == "") {
      return "0 mi";
    }
    return directions['durationToReachDestination'];
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
