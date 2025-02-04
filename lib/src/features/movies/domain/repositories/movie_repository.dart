import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/movie_location.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<MovieLocation>>> fetchMovieLocations();
}
