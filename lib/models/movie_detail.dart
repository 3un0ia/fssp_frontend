class MovieDetail {
  final int id;
  final String title;
  final String overview;
  final String posterUrl;
  final double rating;
  final int year;
  final List<String> genres;
  final List<String> cast;
  final List<String> director;
  final String? backdropUrl;
  final int runtime;

  MovieDetail({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterUrl,
    required this.rating,
    required this.year,
    required this.genres,
    required this.cast,
    required this.director,
    required this.backdropUrl,
    required this.runtime,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      posterUrl: json['posterUrl'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      year: (json['year'] is String)
          ? int.tryParse(json['year'] as String) ?? 0
          : (json['year'] as int?) ?? 0,
      genres: (json['genres'] as List?)
          ?.cast<String>()
          .toList() ?? [],
      cast: (json['cast'] as List?)
          ?.cast<String>()
          .toList() ?? [],
      director: (json['director'] as List?)
          ?.cast<String>()
          .toList() ?? [],
      backdropUrl: json['backdropUrl'] as String?,  // 이미 nullable
      runtime: (json['runtime'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'posterUrl': posterUrl,
      'rating': rating,
      'year': year,
      'genres': genres,
      'cast': cast,
      'director': director,
      'backdropUrl': backdropUrl,
      'runtime': runtime,
    };
  }
}