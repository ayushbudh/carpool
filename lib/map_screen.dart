import 'dart:async';
import 'package:flutter/material.dart';
import 'package:carpool_app/location_services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapSampleState createState() => _MapSampleState();
}

class _MapSampleState extends State<MapScreen> {
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
        body: Stack(
      children: [
        Container(
            child: Stack(
          children: [
            GoogleMap(
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              markers: _markers,
              polylines: _polylines,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ],
        )),
        Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              children: [
                TextFormField(
                    controller: _originController,
                    decoration: const InputDecoration(
                        hintText: ' Origin',
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(Icons.pin_drop))),
                TextFormField(
                  controller: _destinationController,
                  decoration: const InputDecoration(
                      hintText: ' Destination',
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Icon(Icons.location_on)),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 27.0),
                    ),
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
                          : Colors.blue;
                    }),
                  ),
                  onPressed: () async {
                    var directions = await LocationService().getDirections(
                      _originController.value.text,
                      _destinationController.value.text,
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
                  },
                  // UPDATED
                  child: const Icon(Icons.search),
                ),
              ],
            )),
      ],
    ));
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
