import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:learn_bloc/Models/marker_model.dart';
import 'package:learn_bloc/Services/hive_service.dart';

part 'marker_event.dart';
part 'marker_state.dart';

class MarkerBloc extends Bloc<MarkerEvent, MarkerState> {
  MarkerBloc() : super(const MarkerState(markers: {})) {
    on<LoadMarkers>(_onLoadMarkers);
    on<AddMarker>(_onAddMarker);
    on<RemoveMarker>(_onRemoveMarker);
    on<UpdateMarker>(_onUpdateMarker);
    on<ClearMarkers>(_onClearMarkers);
  }

  Future<void> _onLoadMarkers(LoadMarkers event, Emitter<MarkerState> emit) async {
    try {
      final markers = HiveService.getAllMarkers();
      final markerSet = {
        for (var marker in markers)
          marker.id: marker.toMarker()
      };
      emit(state.copyWith(markers: markerSet));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to load markers: $e'));
    }
  }

  Future<void> _onAddMarker(AddMarker event, Emitter<MarkerState> emit) async {
    try {
      final markerModel = MarkerModel.fromMarker(event.marker);
      await HiveService.saveMarker(markerModel);
      
      final updatedMarkers = Map<String, Marker>.from(state.markers);
      updatedMarkers[event.marker.markerId.value] = event.marker;
      
      emit(state.copyWith(markers: updatedMarkers));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to add marker: $e'));
    }
  }

  Future<void> _onRemoveMarker(RemoveMarker event, Emitter<MarkerState> emit) async {
    try {
      await HiveService.deleteMarker(event.markerId.value);
      
      final updatedMarkers = Map<String, Marker>.from(state.markers);
      updatedMarkers.remove(event.markerId.value);
      
      emit(state.copyWith(markers: updatedMarkers));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to remove marker: $e'));
    }
  }

  Future<void> _onUpdateMarker(UpdateMarker event, Emitter<MarkerState> emit) async {
    try {
      final marker = event.updatedMarker;
      final markerModel = MarkerModel.fromMarker(marker);
      await HiveService.saveMarker(markerModel);
      
      final updatedMarkers = Map<String, Marker>.from(state.markers);
      updatedMarkers[marker.markerId.value] = marker;
      
      emit(state.copyWith(markers: updatedMarkers));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to update marker: $e'));
    }
  }

  Future<void> _onClearMarkers(ClearMarkers event, Emitter<MarkerState> emit) async {
    try {
      await HiveService.clearAllMarkers();
      emit(const MarkerState(markers: {}));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to clear markers: $e'));
    }
  }
}

