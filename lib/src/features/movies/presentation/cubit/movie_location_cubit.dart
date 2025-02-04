import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/movie_location_model.dart';
import '../../domain/entities/movie_location.dart';
import '../../domain/repositories/movie_repository.dart';

part 'movie_location_state.dart';

class MovieLocationCubit extends Cubit<MovieLocationState> {
  final MovieRepository repository;

  MovieLocationCubit(this.repository) : super(MovieLocationInitial());

  void fetchMovieLocations() async {
    emit(MovieLocationLoading());
    final locations = await repository.fetchMovieLocations();
    locations.fold(
      (failure) {
        emit(
          MovieLocationError(
            message: failure.message,
          ),
        );
      },
      (filmLocations) {
        emit(
          MovieLocationLoaded(filmLocations),
        );
      },
    );
  }

  void filterMovies(String query) {
    if (state is MovieLocationLoaded) {
      final loadedState = state as MovieLocationLoaded;
      final filtered = loadedState.locations
          .where((movie) =>
              movie.title.toLowerCase().contains(query.toLowerCase()))
          .toList();

      emit(loadedState.copyWith(locations: filtered));
    }
  }
}
