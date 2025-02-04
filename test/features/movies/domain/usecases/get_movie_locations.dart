import '../repositories/movie_repository.dart';
import '../entities/movie_location.dart';

class GetMovieLocations {
  final MovieRepository repository;

  GetMovieLocations({required this.repository});

  Future<List<MovieLocation>> execute() async {
    return await repository.getMovieLocations();
  }
}
