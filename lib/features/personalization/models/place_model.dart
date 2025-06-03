import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';

class Place {
  final String id;
  final String name;
  final String description;
  final String category;
  final GeoPoint geopoint;
  final String address;
  final int averageBill;

  Place({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.geopoint,
    required this.address,
    required this.averageBill,
  });

  factory Place.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Place(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      geopoint: data['geopoint'] ?? GeoPoint(0, 0),
      address: data['address'] ?? '',
      averageBill: data['averageBill']?.toInt() ?? 0,
    );
  }

    LatLng get latLng => LatLng(geopoint.latitude, geopoint.longitude);

  get imageUrl => null;

}