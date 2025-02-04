part of 'movie_location_cubit.dart';

abstract class MovieLocationState extends Equatable {
  const MovieLocationState();

  @override
  List<Object> get props => [];
}

class MovieLocationInitial extends MovieLocationState {}

class MovieLocationLoading extends MovieLocationState {}

class MovieLocationError extends MovieLocationState {
  final String message;
  const MovieLocationError({required this.message});

  @override
  List<Object> get props => [message];
}

class MovieLocationLoaded extends MovieLocationState {
  final List<MovieLocation> locations;

  const MovieLocationLoaded(this.locations);

  MovieLocationLoaded copyWith({List<MovieLocation>? locations}) {
    return MovieLocationLoaded(locations ?? this.locations);
  }

  @override
  List<Object> get props => [locations];
}
