import '../repositories/movie_repository.dart';
import '../entities/movie_location.dart';

class GetMovieLocationsUsecase {
  final MovieRepository repository;

  GetMovieLocationsUsecase({required this.repository});

  Future<List<MovieLocation>> fetchMovieLocations() async {
    return await repository.fetchMovieLocations();
  }
}
