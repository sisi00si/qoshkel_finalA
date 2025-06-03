import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class DirectionsService {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final String apiKey;

  DirectionsService(this.apiKey);

  Future<Directions?> getDirections(LatLng origin, LatLng destination) async {
    final requestUrl = '${_baseUrl}origin=${origin.latitude},${origin.longitude}'
        '&destination=${destination.latitude},${destination.longitude}'
        '&key=$apiKey';

    final response = await http.get(Uri.parse(requestUrl));
    if (response.statusCode != 200) return null;

    final data = json.decode(response.body);
    if (data['status'] != 'OK') return null;

    return Directions.fromMap(data);
  }
}

class Directions {
  final LatLngBounds bounds;
  final List<LatLng> polylinePoints;

  Directions({required this.bounds, required this.polylinePoints});

  factory Directions.fromMap(Map<String, dynamic> map) {
    final bounds = LatLngBounds(
      southwest: LatLng(
        map['routes'][0]['bounds']['southwest']['lat'],
        map['routes'][0]['bounds']['southwest']['lng'],
      ),
      northeast: LatLng(
        map['routes'][0]['bounds']['northeast']['lat'],
        map['routes'][0]['bounds']['northeast']['lng'],
      ),
    );

    final points = map['routes'][0]['overview_polyline']['points'];
    final polylinePoints = _decodePoly(points);

    return Directions(
      bounds: bounds,
      polylinePoints: polylinePoints,
    );
  }

  static List<LatLng> _decodePoly(String encoded) {
    final List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }
}