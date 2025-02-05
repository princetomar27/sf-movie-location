class MovieLocation {
  final String title;
  final String? location;
  final double latitude;
  final double longitude;
  final String releaseYear;
  final String? productionCompany;
  final String? director;
  final String? writer;
  final List<String>? actors;

  MovieLocation({
    required this.title,
    required this.releaseYear,
    this.location,
    required this.latitude,
    required this.longitude,
    this.productionCompany,
    this.director,
    this.writer,
    this.actors,
  });
}
