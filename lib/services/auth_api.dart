import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_response.dart';
import '../models/user.dart';
import 'api_client.dart';

class AuthApi {
  final ApiClient client;

  AuthApi({required this.client});

  /// 일반 회원가입
  Future<User> signup({
    required String email,
    required String password,
    required String name,
    required List<int> preferredGenreIds,
  }) async {
    final body = jsonEncode({
      'email': email,
      'password': password,
      'name': name,
      'preferredGenreIds': preferredGenreIds,
    });
    final response = await client.post('/users/signup', body);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('회원가입 실패 (status: ${response.statusCode})');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    print("회원가입 성공 : ${data}");
    return User.fromJson(data);
  }

  /// 일반 로그인
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final body = jsonEncode({'email': email, 'password': password});
    final response = await client.post('/users/login', body);

    if (response.statusCode != 200) {
      throw Exception('로그인 실패 (status: ${response.statusCode})');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    // print("로그인 성공 : ${data}");
    final bodyString = utf8.decode(response.bodyBytes);
    print('로그인 성공 : $bodyString');
    return AuthResponse.fromJson(data);
  }

  Future<void> logout() async {
    final resp = await client.post('/users/logout');

    if (resp.statusCode != 200) {
      throw Exception('로그아웃 실패: ${resp.statusCode}');
    }
    client.clearToken();
  }


  // /// 소셜 인증 (로그인／회원가입 판단)
  // Future<SocialAuthResponse> socialAuth({
  //   required String provider,     // "KAKAO" or "GOOGLE"
  //   required String idToken,      // 구글은 idToken, 카카오는 accessToken
  //   String? accessToken,          // 구글은 null, 카카오는 accessToken
  //   String? providerId,           // 백엔드에서 가입 시 함께 저장할 User 고유 ID
  // }) async {
  //   final body = jsonEncode({
  //     'provider': provider,
  //     'idToken': idToken,
  //     'accessToken': accessToken,
  //     'providerId': providerId,
  //   });
  //   final response = await client.post(
  //     Uri.parse('$baseUrl/api/auth/social'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: body,
  //   );
  //   if (response.statusCode != 200) {
  //     throw Exception('소셜 로그인 요청 실패: ${response.statusCode}');
  //   }
  //   return SocialAuthResponse.fromJson(jsonDecode(response.body));
  // }
  //
  // /// 소셜 가입 완료 (추가 장르 선택)
  // Future<AuthResponse> socialSignup({
  //   required String email,
  //   required String name,
  //   required String provider,     // "KAKAO" or "GOOGLE"
  //   required String providerId,   // 소셜 제공자에서 부여된 고유 ID
  //   required List<int> preferredGenreIds,
  // }) async {
  //   final body = jsonEncode({
  //     'email': email,
  //     'name': name,
  //     'provider': provider,
  //     'providerId': providerId,
  //     'preferredGenreIds': preferredGenreIds,
  //   });
  //   final response = await client.post(
  //     Uri.parse('$baseUrl/api/auth/social/signup'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: body,
  //   );
  //   if (response.statusCode != 200) {
  //     throw Exception('소셜 회원가입 요청 실패: ${response.statusCode}');
  //   }
  //   return AuthResponse.fromJson(jsonDecode(response.body));
  // }
}