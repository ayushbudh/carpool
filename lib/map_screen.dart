import 'dart:async';
import 'package:flutter/material.dart';
import 'package:carpool_app/location_services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  dynamic directions;
  final String origin;
  final String destination;

  MapScreen(this.origin, this.destination);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late BitmapDescriptor customIcon;
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> _polylines = Set<Polyline>();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    // print(widget.directions);
    _getRoute(widget.origin, widget.destination);
    _setOriginMarker(LatLng(37.42796133580664, -122.085749655962));
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
    return Scaffold(
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
                      initialCameraPosition: _kGooglePlex,
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
                          Text(
                            "26 miles",
                            style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.bold),
                          ),
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
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "12:35 pm",
                            style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.bold),
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
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
                // ],
                )
          ],
        ));
  }

  // SizedBox(
  //       width: 350,
  //       child: TextField(
  //           controller: _originController,
  //           decoration: const InputDecoration(
  //               hintText: ' Origin',
  //               fillColor: Colors.white,
  //               filled: true,
  //               prefixIcon: Icon(Icons.pin_drop)))),
  //   SizedBox(
  //       width: 350,
  //       child: TextField(
  //         controller: _destinationController,
  //         decoration: const InputDecoration(
  //             hintText: ' Destination',
  //             fillColor: Colors.white,
  //             filled: true,
  //             prefixIcon: Icon(Icons.location_on)),
  //       )),
  //   ElevatedButton(
  //     style: ButtonStyle(
  //       padding: MaterialStateProperty.all(
  //         EdgeInsets.symmetric(
  //             vertical: 5.0, horizontal: 27.0),
  //       ),
  //       foregroundColor: MaterialStateProperty.resolveWith(
  //           (Set<MaterialState> states) {
  //         return states.contains(MaterialState.disabled)
  //             ? null
  //             : Colors.white;
  //       }),
  //       backgroundColor: MaterialStateProperty.resolveWith(
  //           (Set<MaterialState> states) {
  //         return states.contains(MaterialState.disabled)
  //             ? null
  //             : Colors.blue;
  //       }),
  //     ),
  //     onPressed: () async {
  //       var directions =
  //           await LocationService().getDirections(
  //         _originController.value.text,
  //         _destinationController.value.text,
  //       );
  //       _goToPlace(
  //         directions['start_location']['lat'],
  //         directions['start_location']['lng'],
  //         directions['end_location']['lat'],
  //         directions['end_location']['lng'],
  //         directions['bounds_ne'],
  //         directions['bounds_sw'],
  //       );

  //       _setPolyline(directions['polyline_decoded']);
  //     },
  //     // UPDATED
  //     child: const Icon(Icons.search),
  //   ),

  // Column(
  //   children: [
  //     Row(children: [
  //       Padding(
  //           padding: const EdgeInsets.all(50),
  //           child: Column(
  //             children: [
  //               TextFormField(
  //                   controller: _originController,
  //                   decoration: const InputDecoration(
  //                       hintText: ' Origin',
  //                       fillColor: Colors.white,
  //                       filled: true,
  //                       prefixIcon: Icon(Icons.pin_drop))),
  //               TextFormField(
  //                 controller: _destinationController,
  //                 decoration: const InputDecoration(
  //                     hintText: ' Destination',
  //                     fillColor: Colors.white,
  //                     filled: true,
  //                     prefixIcon: Icon(Icons.location_on)),
  //               ),
  //               ElevatedButton(
  //                 style: ButtonStyle(
  //                   padding: MaterialStateProperty.all(
  //                     EdgeInsets.symmetric(
  //                         vertical: 5.0, horizontal: 27.0),
  //                   ),
  //                   foregroundColor: MaterialStateProperty.resolveWith(
  //                       (Set<MaterialState> states) {
  //                     return states.contains(MaterialState.disabled)
  //                         ? null
  //                         : Colors.white;
  //                   }),
  //                   backgroundColor: MaterialStateProperty.resolveWith(
  //                       (Set<MaterialState> states) {
  //                     return states.contains(MaterialState.disabled)
  //                         ? null
  //                         : Colors.blue;
  //                   }),
  //                 ),
  //                 onPressed: () async {
  //                   var directions =
  //                       await LocationService().getDirections(
  //                     _originController.value.text,
  //                     _destinationController.value.text,
  //                   );
  //                   _goToPlace(
  //                     directions['start_location']['lat'],
  //                     directions['start_location']['lng'],
  //                     directions['end_location']['lat'],
  //                     directions['end_location']['lng'],
  //                     directions['bounds_ne'],
  //                     directions['bounds_sw'],
  //                   );

  //                   _setPolyline(directions['polyline_decoded']);
  //                 },
  //                 // UPDATED
  //                 child: const Icon(Icons.search),
  //               ),
  //             ],
  //           ))
  //     ]),
  //   ],
  // ),
  // Row(
  //   children: [
  //     Container(
  //       color: Colors.blue,
  //       height: 100,
  //     )
  //   ],
  // )

  // Container(
  //   height: 400,
  //   child: GoogleMap(
  //     myLocationButtonEnabled: true,
  //     mapType: MapType.normal,
  //     markers: _markers,
  //     polylines: _polylines,
  //     initialCameraPosition: _kGooglePlex,
  //     onMapCreated: (GoogleMapController controller) {
  //       _controller.complete(controller);
  //     },
  //   ),
  // ),

  void _getRoute(String origin, String destination) async {
    var directions = await LocationService().getDirections(
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
