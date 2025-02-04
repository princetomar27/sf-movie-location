import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sfmovie/src/core/errors/failures.dart';
import 'package:sfmovie/src/core/network/error_message_model.dart';
import '../../../../core/network/dio_errors_messages.dart';
import '../models/movie_location_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MovieRemoteDataSource {
  final Dio dio;

  MovieRemoteDataSource(this.dio);

  Future<Either<Failure, List<MovieLocationModel>>>
      fetchMovieLocations() async {
    try {
      final String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
      final String apiKey = dotenv.env['API_TOKEN'] ?? '';

      if (baseUrl.isEmpty || apiKey.isEmpty) {
        return const Left(ServerFailure(
          message: 'API URL or Token is missing in .env file',
        ));
      }

      final response = await performRequestWithRetry(baseUrl, apiKey);

      if (response.statusCode == 200) {
        try {
          final List<MovieLocationModel> movies =
              List<Map<String, dynamic>>.from(response.data)
                  .map((json) => MovieLocationModel.fromJson(json))
                  .toList();

          return right(movies);
        } catch (e) {
          return Left(ServerFailure(
            message: 'Data parsing error: ${e.toString()}',
          ));
        }
      } else {
        try {
          final errorResponse = ErrorMessageModel.fromJson(response.data);
          return Left(ServerFailure(
            message: errorResponse.statusMessage,
            errorMessageModel: errorResponse,
          ));
        } catch (e) {
          return Left(ServerFailure(
            message: 'Server error: ${response.statusCode}',
          ));
        }
      }
    } on DioException catch (e) {
      String errorMessage = mapDioError(e);
      return Left(ServerFailure(message: errorMessage));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }
}
