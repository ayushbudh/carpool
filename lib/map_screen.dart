import 'dart:async';
import 'package:carpool_app/map_drive_screen.dart';
import 'package:carpool_app/map_new_rider_screen.dart';
import 'package:carpool_app/map_route_screen.dart';
import 'package:flutter/material.dart';
import 'package:carpool_app/location_services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  final String origin;
  final String destination;
  MapScreen(this.origin, this.destination);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _getRoute(widget.origin, widget.destination);
  }

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

  double mapHeight = 0.70;

  void setMapHeight(double value) {
    setState(() {
      mapHeight = value;
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
                        height: heightSize * mapHeight,
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
                MapRouteScreen(directions, widthSize, heightSize),
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
