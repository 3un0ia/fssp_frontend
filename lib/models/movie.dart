class Movie {
  final int id;
  final String title;
  final String posterUrl;
  final double rating;
  final int year;
  final String? genre;
  final String? overview;
  final String? backdropUrl;

  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.rating,
    required this.year,
    this.genre,
    this.overview,
    this.backdropUrl,
  });
}

class Review {
  final int id;
  final String user;
  final double rating;
  final String comment;

  Review({
    required this.id,
    required this.user,
    required this.rating,
    required this.comment,
  });
}

