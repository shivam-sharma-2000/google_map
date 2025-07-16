import 'package:hive_flutter/hive_flutter.dart';
import '../Models/marker_model.dart';

class HiveService {
  static const String _boxName = 'markersBox';
  static late Box<MarkerModel> _markersBox;

  // Initialize Hive
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MarkerModelAdapter());
    }
    
    // Open the box
    _markersBox = await Hive.openBox<MarkerModel>(_boxName);
  }

  // Save a marker
  static Future<void> saveMarker(MarkerModel marker) async {
    await _markersBox.put(marker.id, marker);
  }

  // Get all markers
  static List<MarkerModel> getAllMarkers() {
    return _markersBox.values.toList();
  }

  // Delete a marker
  static Future<void> deleteMarker(String id) async {
    await _markersBox.delete(id);
  }

  // Clear all markers
  static Future<void> clearAllMarkers() async {
    await _markersBox.clear();
  }

  // Close the box when done
  static Future<void> close() async {
    await _markersBox.close();
  }
}
