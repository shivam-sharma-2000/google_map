import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

import '../BLoc/Marker/marker_bloc.dart';
import '../Utils/location_service.dart';
import 'list_of_markers.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  LatLng? _currentLocation;
  final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  static const String _currentLocationMarkerId = 'current-location-marker';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MarkerBloc>().add(LoadMarkers());
    });
  }

  // Get current location
  Future<void> _getCurrentLocation() async {
    final position = await LocationService.getCurrentLocation();
    if (position != null) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _markers.add(
          Marker(
            markerId: const MarkerId(_currentLocationMarkerId),
            position: _currentLocation!,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            infoWindow: const InfoWindow(title: 'Your Location'),
          ),
        );
      });
      
      // Move camera to current location
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation!, 15),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    _mapController = controller;
  }

  // Update markers when the state changes
  void _updateMarkers(Set<Marker> markers) {
    if (mounted) {
      setState(() {
        _markers.clear();
        _markers.addAll(markers);
      });
    }
  }

  // Method to add marker at a given location
  Future<void> _addMarker(LatLng position, String id, String title) async {
    try {
      final locationName = await getAddressFromLL(position);
      final marker = Marker(
        markerId: MarkerId(id),
        position: position,
        infoWindow: InfoWindow(
          title: title,
          snippet: locationName,
        ),
      );
      
      if (!mounted) return;
      context.read<MarkerBloc>().add(AddMarker(marker));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding marker: $e')),
      );
    }
  }

  // Example: Add marker on tap
  void _handleTap(LatLng tappedPoint) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Marker"),
          content: const Text("Do you want to add a marker at this location?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Add"),
              onPressed: () {
                _addMarker(tappedPoint, DateTime.now().toString(), "New Marker");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Get Location name from lat long
  static Future<String> getAddressFromLL(LatLng data) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        data.latitude,
        data.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final addressParts = [
          placemark.street,
          placemark.subLocality,
          placemark.locality,
          placemark.postalCode,
          placemark.administrativeArea,
          placemark.country,
        ].where((part) => part?.isNotEmpty ?? false).join(', ');
        
        return addressParts.isNotEmpty ? addressParts : 'Unnamed Location';
      }
    } catch (e) {
      debugPrint('Error getting address: $e');
    }
    return 'Unnamed Location';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MarkerBloc, MarkerState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
        // Update markers when state changes
        _updateMarkers(state.markers.values.toSet());
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Google Map with Markers'),
          actions: [
            IconButton(
              icon: const Icon(Icons.list),
              onPressed: () async {
                final position = await Navigator.push<LatLng?>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MarkerListScreen(),
                  ),
                );
                
                if (position != null) {
                  // Animate to the selected marker
                  _mapController!.animateCamera(
                    CameraUpdate.newLatLngZoom(position, 15),
                  );
                }
              },
              tooltip: 'Show Markers List',
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear All Markers'),
                    content: const Text(
                        'Are you sure you want to remove all markers?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('CANCEL'),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<MarkerBloc>().add(ClearMarkers());
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('All markers cleared')),
                          );
                        },
                        child: const Text(
                          'CLEAR',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
              tooltip: 'Clear All Markers',
            ),
          ],
        ),
        body: BlocBuilder<MarkerBloc, MarkerState>(
          builder: (context, state) {
            return Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _currentLocation ?? const LatLng(28.6139, 77.2090), // Default to Delhi if location not available
                    zoom: _currentLocation != null ? 15 : 10,
                  ),
                  markers: {
                    if(_currentLocation != null)Marker(
                    markerId: const MarkerId(_currentLocationMarkerId),
                    position: _currentLocation!,
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                    infoWindow: const InfoWindow(title: 'Your Location'),
                  ), ..._markers},
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  compassEnabled: true,
                  onTap: _handleTap,
                  zoomControlsEnabled: true,
                ),
                if (state.isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

}
