part of 'movie_location_cubit.dart';

abstract class MovieLocationState extends Equatable {
  const MovieLocationState();

  @override
  List<Object?> get props => [];
}

class MovieLocationInitial extends MovieLocationState {}

class MovieLocationLoading extends MovieLocationState {}

class MovieLocationError extends MovieLocationState {
  final String message;
  const MovieLocationError({required this.message});

  @override
  List<Object?> get props => [message];
}

class MovieLocationLoaded extends MovieLocationState {
  final List<MovieLocation> locations; // Current filtered locations
  final List<MovieLocation>
      allLocations; // All locations, for restoring the list
  final Set<Marker> markers;

  const MovieLocationLoaded({
    required this.locations,
    required this.markers,
    required this.allLocations,
  });

  MovieLocationLoaded copyWith({
    List<MovieLocation>? locations,
    Set<Marker>? markers,
    List<MovieLocation>? allLocations,
  }) {
    return MovieLocationLoaded(
      locations: locations ?? this.locations,
      markers: markers ?? this.markers,
      allLocations: allLocations ?? this.allLocations,
    );
  }

  @override
  List<Object> get props => [locations, markers, allLocations];
}

// ... (ShowMovieInfoWindow state removed as it's not needed)