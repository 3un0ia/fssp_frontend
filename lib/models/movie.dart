class Movie {
  final int id;
  final String title;
  final String? director;
  final int year;
  final double rating;
  final String? genre;
  final String? description;
  final List<String>? cast;
  final String? runtime;
  final List<String>? genres;
  final String? savedDate;
  final String? posterUrl;

  Movie({
    required this.id,
    required this.title,
    this.director,
    required this.year,
    required this.rating,
    this.genre,
    this.description,
    this.cast,
    this.runtime,
    this.genres,
    this.savedDate,
    this.posterUrl,
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

