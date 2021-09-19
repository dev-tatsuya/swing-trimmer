class Movie {
  Movie({
    this.id,
    this.title,
    this.thumbnailPath,
    this.moviePath,
    this.isFavorite = false,
    this.swungAt,
  });

  final int? id;
  final String? title;
  final String? thumbnailPath;
  final String? moviePath;
  final bool isFavorite;
  final DateTime? swungAt;
}
