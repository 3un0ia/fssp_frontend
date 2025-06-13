class Movie {
  final int id;
  final String title;
  final String posterUrl;
  final double rating;
  final String year;

  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.rating,
    required this.year,
  });


  // JSON → Movie 객체
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int,
      title: json['title'] as String,
      posterUrl: json['posterUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      year: json['year'] as String,
    );
  }

  // Movie 객체 → JSON (필요 시)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'posterUrl': posterUrl,
      'rating': rating,
      'year': year,
    };
  }
}



