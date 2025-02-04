import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/movie_location.dart';
import '../../domain/repositories/movie_repository.dart';

part 'movie_location_state.dart';

class MovieLocationCubit extends Cubit<MovieLocationState> {
  final MovieRepository repository;

  MovieLocationCubit(this.repository) : super(MovieLocationInitial());

  void fetchMovieLocations() async {
    try {
      emit(MovieLocationLoading());
      final locations = await repository.fetchMovieLocations();
      emit(MovieLocationLoaded(locations));
    } catch (e) {
      emit(
        MovieLocationError(
          message: 'Failed to fetch movie locations',
        ),
      );
    }
  }

  void filterMovies(String query) {
    if (state is MovieLocationLoaded) {
      final loadedState = state as MovieLocationLoaded;
      final filtered = loadedState.locations
          .where((movie) =>
              movie.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
      emit(MovieLocationLoaded(filtered));
    }
  }
}
