import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:sfmovie/src/core/errors/failures.dart';
import 'package:sfmovie/src/features/movies/data/datasource/movie_remote_data_source.dart';
import 'package:sfmovie/src/features/movies/data/models/movie_location_model.dart';
import 'movie_remote_data_source_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late MockDio mockDio;
  late MovieRemoteDataSource dataSource;

  setUp(() {
    mockDio = MockDio();
    dataSource = MovieRemoteDataSource(mockDio);
  });

  test('should return list of MovieLocationModel when the response code is 200',
      () async {
    when(mockDio.get(any)).thenAnswer(
      (_) async => Response(
        data: [
          {
            "title": "Inception",
            "release_year": "2010",
            "locations": "Los Angeles, CA",
            "latitude": 34.0522,
            "longitude": -118.2437,
            "production_company": "Warner Bros",
            "director": "Christopher Nolan",
            "writer": "Christopher Nolan",
            "actor_1": "Leonardo DiCaprio",
            "actor_2": "Joseph Gordon-Levitt",
            "actor_3": "Ellen Page"
          }
        ],
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      ),
    );

    final result = await dataSource.fetchMovieLocations();

    expect(result, isA<Right<Failure, List<MovieLocationModel>>>());
    expect(result.getOrElse(() => <MovieLocationModel>[]),
        isA<List<MovieLocationModel>>());
  });

  test('should return failure when the response code is not 200', () async {
    when(mockDio.get(any)).thenAnswer(
      (_) async => Response(
        data: {'error': 'Internal Server Error'},
        statusCode: 500,
        requestOptions: RequestOptions(path: ''),
      ),
    );

    final result = await dataSource.fetchMovieLocations();

    expect(result, isA<Left<Failure, List<MovieLocationModel>>>());
    expect(result.fold((failure) => failure.message, (r) => ''),
        'Server error: 500');
  });

  test('should return failure when there is an uninitialized error', () async {
    when(mockDio.get(any)).thenThrow(DioException(
      requestOptions: RequestOptions(path: ''),
    ));

    final result = await dataSource.fetchMovieLocations();

    expect(result, isA<Left<Failure, List<MovieLocationModel>>>());
    expect(result.fold((failure) => failure.message, (r) => ''),
        'Unexpected error: Instance of \'DioException\'');
  });
}
