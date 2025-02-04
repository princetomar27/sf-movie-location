import 'package:dio/dio.dart';
import '../models/movie_location_model.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class MovieRemoteDataSource {
  final Dio dio;

  MovieRemoteDataSource(this.dio);

  Future<List<MovieLocationModel>> fetchMovieLocations() async {
    final String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
    final String apiKey = dotenv.env['API_TOKEN'] ?? '';

    final response = await dio.get(
      baseUrl,
      options: Options(headers: {'X-App-Token': apiKey}),
    );

    if (response.statusCode == 200) {
      return (response.data)
          .map((json) => MovieLocationModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load movie locations');
    }
  }
}
