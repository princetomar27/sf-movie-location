import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/movie_location.dart';
import '../repositories/movie_repository.dart';

class GetMovieLocationsUsecase {
  final MovieRepository repository;

  GetMovieLocationsUsecase({required this.repository});

  Future<Either<Failure, List<MovieLocation>>> fetchMovieLocations() async {
    return await repository.fetchMovieLocations();
  }
}
