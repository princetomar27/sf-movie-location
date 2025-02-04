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
  final List<MovieLocationModel> locations;
  final Set<Marker> markers;

  const MovieLocationLoaded({required this.locations, required this.markers});

  MovieLocationLoaded copyWith(
      {List<MovieLocationModel>? locations, Set<Marker>? markers}) {
    return MovieLocationLoaded(
      locations: locations ?? this.locations,
      markers: markers ?? this.markers,
    );
  }

  @override
  List<Object?> get props => [locations, markers];
}
