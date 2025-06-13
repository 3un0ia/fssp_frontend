import 'dart:convert';
import '../models/movie_detail.dart';
import '../services/api_client.dart';

class WatchlistApi {
  final ApiClient _client;

  WatchlistApi({required ApiClient client})
      : _client = client;

  // 워치리스트 전체보기
  Future<List<MovieDetail>> listFavorites() async {
    final resp = await _client.get('/watchlist');
    final bodyString = utf8.decode(resp.bodyBytes);
    final jsonList = jsonDecode(bodyString) as List<dynamic>;
    return jsonList
      .map((e) => MovieDetail.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // 워치리스트에 영화 추가하기
  Future<void> addFavorite(int tmdbId) async {
    print('addFavorite called with tmdbId: $tmdbId');
    final resp = await _client.post('/watchlist/$tmdbId', '');
    print('addFavorite response: statCode=${resp.statusCode}, body=${resp.body}');

  }
  // 워치리스트에서 영화 제거하기
  Future<void> removeFavorite(int tmdbId) async {
    print('removeFavorite called with tmdbId: $tmdbId');
    final resp = await _client.delete('/watchlist/$tmdbId');
    print('removeFavorite response: statCode=${resp.statusCode}');
  }
}