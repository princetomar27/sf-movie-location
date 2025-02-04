import 'package:dartz/dartz.dart';
import 'package:sfmovie/src/core/errors/failures.dart';

import '../repositories/movie_repository.dart';
import '../entities/movie_location.dart';

class GetMovieLocationsUsecase {
  final MovieRepository repository;

  GetMovieLocationsUsecase({required this.repository});

  Future<Either<Failure, List<MovieLocation>>> fetchMovieLocations() async {
    return await repository.fetchMovieLocations();
  }
}
