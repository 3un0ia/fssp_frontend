import 'dart:convert';
import '../models/movie.dart';
import '../models/movie_detail.dart';
import '../services/api_client.dart';

class MovieApi {
  final ApiClient _client;

  MovieApi({required ApiClient client})
      : _client = client;

  /// 인기영화 리스트 가져오기
  Future<List<Movie>> fetchPopular({int limit = 40}) async {
    final response = await _client.get('/movies/popular?limit=$limit');
    print('>>> Calling fetchPopular');
    if (response.statusCode != 200) {
      throw Exception('트렌딩 영화 로드 실패: ${response.statusCode}');
    }

    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList
        .map((jsonItem) => Movie.fromJson(jsonItem as Map<String, dynamic>))
        .toList();
  }

  /// 영화 상세정보 보기
  Future<MovieDetail> fetchDetail(int tmdbId) async {
    print('>>> fetchDetail URL: /movies/$tmdbId');
    final resp = await _client.get('/movies/$tmdbId');
    // Decode bytes as UTF-8 to handle Korean characters correctly
    final bodyString = utf8.decode(resp.bodyBytes);
    print('>>> fetchDetail response (decoded): $bodyString');
    if (resp.statusCode != 200) {
      throw Exception('영화 상세정보 로드 실패: ${resp.statusCode}');
    }
    return MovieDetail.fromJson(jsonDecode(bodyString) as Map<String, dynamic>);
  }

  /// 키워드 검색
  Future<List<Movie>> search(String query, {int limit = 40}) async {
    final resp = await _client.get('/movies/search', {
      'q': query,
      'limit': '$limit',
    });
    final data = jsonDecode(resp.body) as List;
    return data.map((e) => Movie.fromJson(e)).toList();
  }

  /// 선호 장르 기반 혼합 추천 (Combined)
  Future<List<Movie>> recommendCombined({int limit = 40}) async {
    final resp = await _client.get('/movies/recommend/combined', {'limit': '$limit'});
    if (resp.statusCode != 200) {
      throw Exception('추천 영화 로드 실패: ${resp.statusCode}');
    }
    final List<dynamic> data = jsonDecode(resp.body) as List<dynamic>;
    return data.map((e) => Movie.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// 장르별 인기 묶음 추천
  Future<List<Movie>> recommendByGenres(int genreId, {int limit = 40}) async {
    final resp = await _client.get('/movies/recommend/genres', { 'genreId': '$genreId', 'limit': '$limit'});
    print('>>> Calling recommendByGenres: genreId=$genreId');
    final List<dynamic> jsonList = jsonDecode(resp.body) as List<dynamic>;
    return jsonList
        .map((item) => Movie.fromJson(item as Map<String, dynamic>))
        .toList();
  }


}