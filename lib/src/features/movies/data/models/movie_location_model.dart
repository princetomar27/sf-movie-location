class MovieLocationModel {
  final String title;
  final String releaseYear;
  final String location;
  final double latitude;
  final double longitude;

  MovieLocationModel({
    required this.title,
    required this.releaseYear,
    required this.location,
    required this.latitude,
    required this.longitude,
  });

  factory MovieLocationModel.fromJson(Map<String, dynamic> json) {
    return MovieLocationModel(
      title: json['title'],
      releaseYear: json['release_year'],
      location: json['locations'],
      latitude: double.tryParse(json['latitude']) ?? 0.0,
      longitude: double.tryParse(json['longitude']) ?? 0.0,
    );
  }
}
