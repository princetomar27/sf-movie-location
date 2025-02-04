import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/movie_location.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasource/movie_remote_data_source.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  MovieRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<MovieLocation>>> fetchMovieLocations() async {
    final result = await remoteDataSource.fetchMovieLocations();
    return result.fold(
      (failure) => Left(failure),
      (movieModels) => Right(
        movieModels
            .map(
              (model) => MovieLocation(
                title: model.title,
                location: model.location,
                releaseYear: model.releaseYear,
                latitude: model.latitude ?? 0.0,
                longitude: model.longitude ?? 0.0,
              ),
            )
            .toList(),
      ),
    );
  }
}
