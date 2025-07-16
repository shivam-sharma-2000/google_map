part of 'marker_bloc.dart';

abstract class MarkerEvent {}

class LoadMarkers extends MarkerEvent {}

class AddMarker extends MarkerEvent {
  final Marker marker;

  AddMarker(this.marker);
}

class RemoveMarker extends MarkerEvent {
  final MarkerId markerId;

  RemoveMarker(this.markerId);
}

class UpdateMarker extends MarkerEvent {
  final Marker updatedMarker;

  UpdateMarker(this.updatedMarker);
}

class ClearMarkers extends MarkerEvent {}