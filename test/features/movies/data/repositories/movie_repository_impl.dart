import 'package:dio/dio.dart';
import '../models/movie_location_model.dart';

class MovieRemoteDataSource {
  final Dio dio;

  MovieRemoteDataSource({required this.dio});

  Future<List<MovieLocationModel>> fetchMovieLocations() async {
    final response =
        await dio.get('https://data.sfgov.org/resource/yitu-d5am.json');

    if (response.statusCode == 200) {
      return (response.data as List)
          .map((json) => MovieLocationModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load movie locations');
    }
  }
}
