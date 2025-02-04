import 'package:equatable/equatable.dart';

class MovieLocationModel extends Equatable {
  final String title;
  final String releaseYear;
  final String location;
  final double? latitude;
  final double? longitude;

  MovieLocationModel({
    required this.title,
    required this.releaseYear,
    required this.location,
    required this.latitude,
    required this.longitude,
  });

  factory MovieLocationModel.fromJson(Map<String, dynamic> json) {
    return MovieLocationModel(
      title: json['title'] ?? 'Unknown Title',
      releaseYear: json['release_year'] ?? 'Unknown Year',
      location: json['locations'] ?? 'Unknown Location',
      latitude: _parseLocation(json['latitude']),
      longitude: _parseLocation(json['longitude']),
    );
  }

  static double? _parseLocation(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  @override
  List<Object?> get props => [
        title,
        releaseYear,
        location,
        latitude,
        longitude,
      ];
}
