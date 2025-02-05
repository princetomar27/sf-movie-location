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
  final List<MovieLocation> locations; // Use Entity instead of Model
  final Set<Marker> markers;

  const MovieLocationLoaded({required this.locations, required this.markers});

  MovieLocationLoaded copyWith({
    List<MovieLocation>? locations,
    Set<Marker>? markers,
  }) {
    return MovieLocationLoaded(
      locations: locations ?? this.locations,
      markers: markers ?? this.markers,
    );
  }

  @override
  List<Object> get props => [locations, markers];
}

class ShowMovieInfoWindow extends MovieLocationState {
  final MovieLocation movie;
  final List<MovieLocation> locations;
  final Set<Marker> markers;

  const ShowMovieInfoWindow({
    required this.movie,
    required this.locations,
    required this.markers,
  });

  @override
  List<Object> get props => [movie, locations, markers];
}
