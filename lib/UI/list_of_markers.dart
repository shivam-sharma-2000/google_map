import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../BLoc/Marker/marker_bloc.dart';

class MarkerListScreen extends StatelessWidget {
  const MarkerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Markers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<MarkerBloc>().add(LoadMarkers()),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocBuilder<MarkerBloc, MarkerState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final markers = state.markers.values.toList();

          if (markers.isEmpty) {
            return const Center(
              child: Text(
                'No markers saved yet.\nTap on the map to add markers.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: markers.length,
            itemBuilder: (context, index) {
              final marker = markers[index];
              return Dismissible(
                key: Key(marker.markerId.value),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Marker'),
                      content: Text(
                          'Delete marker at ${marker.position.latitude.toStringAsFixed(4)}, ${marker.position.longitude.toStringAsFixed(4)}?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('DELETE', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                  return confirm ?? false;
                },
                onDismissed: (direction) {
                  context.read<MarkerBloc>().add(RemoveMarker(marker.markerId));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Marker deleted')),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    title: Text(
                      marker.infoWindow.title ?? 'Unnamed Location',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      marker.infoWindow.snippet ?? 'No address available',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // You could implement navigation back to the map with the marker focused
                      Navigator.pop(context, marker.position);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
