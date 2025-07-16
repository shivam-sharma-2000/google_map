part of 'marker_bloc.dart';

class MarkerState {
  final Map<String, Marker> markers;
  final String? error;
  final bool isLoading;

  const MarkerState({
    Map<String, Marker>? markers,
    this.error,
    this.isLoading = false,
  }) : markers = markers ?? const {};

  MarkerState copyWith({
    Map<String, Marker>? markers,
    String? error,
    bool? isLoading,
  }) {
    return MarkerState(
      markers: markers ?? this.markers,
      error: error,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is MarkerState &&
      mapEquals(other.markers, markers) &&
      other.error == error &&
      other.isLoading == isLoading;
  }

  @override
  int get hashCode => markers.hashCode ^ error.hashCode ^ isLoading.hashCode;
}
