import '../entities/movie_location.dart';

abstract class MovieRepository {
  Future<List<MovieLocation>> fetchMovieLocations();
}
