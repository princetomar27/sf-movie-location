import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sfmovie/src/features/movies/data/models/movie_location_model.dart';

void main() {
  final tMovieLocation = MovieLocationModel(
    title: "Inception",
    releaseYear: "2010",
    location: "Los Angeles, CA",
    latitude: 34.0522,
    longitude: -118.2437,
    productionCompany: "Warner Bros",
    director: "Christopher Nolan",
    writer: "Christopher Nolan",
    actors: const ["Leonardo DiCaprio", "Joseph Gordon-Levitt", "Ellen Page"],
  );

  test('should be a subclass of MovieLocation entity', () {
    expect(tMovieLocation, isA<MovieLocationModel>());
  });

  test('should return a valid model when JSON is passed', () {
    // arrange
    final jsonMap = jsonDecode('''
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
    ''');

    // act
    final result = MovieLocationModel.fromJson(jsonMap);

    // assert
    expect(result, tMovieLocation);
  });
}
