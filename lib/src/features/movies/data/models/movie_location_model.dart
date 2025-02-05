import 'package:equatable/equatable.dart';

import '../../domain/entities/movie_location.dart';

class MovieLocationModel extends Equatable {
  final String title;
  final String releaseYear;
  final String? location;
  final double? latitude;
  final double? longitude;
  final String? productionCompany;
  final String? director;
  final String? writer;
  final List<String>? actors;

  MovieLocationModel({
    required this.title,
    required this.releaseYear,
    this.location,
    this.latitude,
    this.longitude,
    this.productionCompany,
    this.director,
    this.writer,
    this.actors,
  });

  factory MovieLocationModel.fromEntity(MovieLocation movie) {
    return MovieLocationModel(
      title: movie.title,
      releaseYear: movie.releaseYear,
      location: movie.location,
      latitude: movie.latitude,
      longitude: movie.longitude,
      productionCompany: movie.productionCompany,
      director: movie.director,
      writer: movie.writer,
      actors: movie.actors,
    );
  }

  factory MovieLocationModel.fromJson(Map<String, dynamic> json) {
    return MovieLocationModel(
      title: json['title'],
      releaseYear: json['release_year'],
      location: json['locations'],
      latitude: _parseLocation(json['latitude']),
      longitude: _parseLocation(json['longitude']),
      productionCompany: json['production_company'],
      director: json['director'],
      writer: json['writer'],
      actors: _parseActors(json),
    );
  }

  static double? _parseLocation(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static List<String>? _parseActors(Map<String, dynamic> json) {
    return [
      json['actor_1'],
      json['actor_2'],
      json['actor_3'],
    ].where((actor) => actor != null).cast<String>().toList();
  }

  @override
  List<Object?> get props => [
        title,
        releaseYear,
        location,
        latitude,
        longitude,
        productionCompany,
        director,
        writer,
        actors,
      ];
}
