import 'package:hive/hive.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'marker_model.g.dart';

@HiveType(typeId: 0)
class MarkerModel extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final double latitude;
  
  @HiveField(2)
  final double longitude;
  
  @HiveField(3)
  final String title;
  
  @HiveField(4)
  final String? description;
  
  @HiveField(5)
  final DateTime createdAt;

  MarkerModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.title,
    this.description,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert from Marker to MarkerModel
  factory MarkerModel.fromMarker(Marker marker) {
    return MarkerModel(
      id: marker.markerId.value,
      latitude: marker.position.latitude,
      longitude: marker.position.longitude,
      title: marker.infoWindow.title ?? 'Untitled',
      description: marker.infoWindow.snippet,
    );
  }

  // Convert to LatLng
  LatLng get position => LatLng(latitude, longitude);

  // Convert to Marker
  Marker toMarker() {
    return Marker(
      markerId: MarkerId(id),
      position: position,
      infoWindow: InfoWindow(
        title: title,
        snippet: description,
      ),
    );
  }
}
