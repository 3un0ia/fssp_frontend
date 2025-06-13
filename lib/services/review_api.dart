import 'dart:convert';
import '../models/review.dart';
import '../services/api_client.dart';

class ReviewApi {
  final ApiClient client;
  ReviewApi(this.client);

  // 리뷰 가져오기 (특정 영화)
  Future<List<Review>> listReviews(int tmdbId) async {
    final resp = await client.get('/movies/$tmdbId/reviews');
    // Decode response bytes as UTF-8 to preserve Korean characters
    final body = utf8.decode(resp.bodyBytes);
    print('listReviews status: ${resp.statusCode}');
    print('listReviews body: $body');
    final json = jsonDecode(body) as List;
    return json.map((e) => Review.fromJson(e)).toList();
  }

  // 리뷰 작성하기 (특정 영화)
  Future<Review> addReview(int tmdbId, double rating, String content) async {
    final body = jsonEncode({'rating': rating, 'content': content});
    final resp = await client.post('/movies/$tmdbId/reviews', body);
    print('addReview status: ${resp.statusCode}');
    print('addReview body: ${resp.body}');
    return Review.fromJson(jsonDecode(resp.body));
  }
}