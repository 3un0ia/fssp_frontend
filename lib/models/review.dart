class Review {
  final int id;
  final int tmdbId;
  final String userName;
  final double rating;
  final String content;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.tmdbId,
    required this.userName,
    required this.rating,
    required this.content,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as int,
      tmdbId: json['tmdbId'] as int,
      userName: json['userName'] as String,
      rating: (json['rating'] as num).toDouble(),
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tmdbId': tmdbId,
      'userName': userName,
      'rating': rating,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}