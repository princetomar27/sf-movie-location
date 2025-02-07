import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sfmovie/src/core/errors/failures.dart';
import 'package:sfmovie/src/features/movies/data/models/movie_location_model.dart';
import 'package:sfmovie/src/features/movies/domain/entities/movie_location.dart';
import 'package:sfmovie/src/features/movies/data/repositories/movie_repository_impl.dart';
import 'package:sfmovie/src/features/movies/data/datasource/movie_remote_data_source.dart';

class MockMovieRemoteDataSource extends Mock implements MovieRemoteDataSource {}

void main() {
  late MovieRepositoryImpl repository;
  late MockMovieRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockMovieRemoteDataSource();
    repository = MovieRepositoryImpl(mockDataSource);
  });

  test(
      'should return a list of MovieLocation when the data source returns success',
      () async {
    // Arrange: Mock the data source to return a successful response
    when(mockDataSource.fetchMovieLocations()).thenAnswer(
      (_) async => Right([
        MovieLocationModel(
          title: 'Inception',
          releaseYear: '2010',
          location: 'Los Angeles, CA',
          latitude: 34.0522,
          longitude: -118.2437,
        ),
      ]),
    );

    // Act: Call the repository method
    final result = await repository.fetchMovieLocations();

    // Assert: Check that the result is a Right with a list of MovieLocation
    expect(result, isA<Right<Failure, List<MovieLocation>>>());
    expect(result.getOrElse(() => []), isA<List<MovieLocation>>());
    expect(result.getOrElse(() => [])[0].title, 'Inception');
  });

  test('should return a failure when the data source returns a failure',
      () async {
    // Arrange: Mock the data source to return a failure
    when(mockDataSource.fetchMovieLocations()).thenAnswer(
      (_) async => Left(ServerFailure(message: 'Server error')),
    );

    // Act: Call the repository method
    final result = await repository.fetchMovieLocations();

    // Assert: Check that the result is a Left with a failure
    expect(result, isA<Left<Failure, List<MovieLocation>>>());
    expect(
        result.fold((failure) => failure.message, (r) => ''), 'Server error');
  });
}
