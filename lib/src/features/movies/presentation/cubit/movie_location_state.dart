part of 'movie_location_cubit.dart';

abstract class MovieLocationState extends Equatable {}

class MovieLocationInitial extends MovieLocationState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class MovieLocationLoading extends MovieLocationState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class MovieLocationLoaded extends MovieLocationState {
  final List<MovieLocation> locations;
  MovieLocationLoaded(this.locations);

  @override
  List<Object?> get props => throw UnimplementedError();
}

class MovieLocationError extends MovieLocationState {
  final String message;
  MovieLocationError({
    required this.message,
  });

  @override
  List<Object?> get props => throw UnimplementedError();
}
