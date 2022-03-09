import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LocationService {
  final String key = 'API-KEY';

  // currently not being used, this function is just for reference
  Future<Map<String, dynamic>> getPlaceID(String input) async {
    const String url =
        'https://maps.googleapis.com/maps/api/place/details/output?parameters'; // example url

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var results = json['result'] as Map<String, dynamic>;
    return results;
  }

  Future<Map> getDirections(String origin, String destination) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin}&destination=${destination}&key=${key}';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);

    var results = {
      'bounds_ne': json['routes'][0]['bounds']['northeast'],
      'bounds_sw': json['routes'][0]['bounds']['southwest'],
      'start_location': json['routes'][0]['legs'][0]['start_location'],
      'end_location': json['routes'][0]['legs'][0]['end_location'],
      'polyline': json['routes'][0]['overview_polyline']['points'],
      'distanceInMiles': json['routes'][0]['legs'][0]['distance']['text'],
      'durationToReachDestination': json['routes'][0]['legs'][0]['duration']
          ['text'],
      'polyline_decoded': PolylinePoints()
          .decodePolyline(json['routes'][0]['overview_polyline']['points']),
    };

    return results;
  }

  Future<Map> getSearchResults(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${input}&key=${key}';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);

    var results = {
      'length': json['predictions'].length,
      'results': json['predictions']
    };

    return results;
  }
}
