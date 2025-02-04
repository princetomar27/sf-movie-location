import '../../domain/entities/movie_location.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasource/movie_remote_data_source.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  MovieRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<MovieLocation>> fetchMovieLocations() async {
    final movieModels = await remoteDataSource.fetchMovieLocations();
    return movieModels
        .map((model) => MovieLocation(
              title: model.title,
              location: model.location,
              latitude: model.latitude,
              longitude: model.longitude,
            ))
        .toList();
  }
}
