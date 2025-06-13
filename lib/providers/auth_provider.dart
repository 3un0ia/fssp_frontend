import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/auth_api.dart';
import '../services/api_client.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final AuthApi _authApi;
  final ApiClient _apiClient;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  User? _currentUser;
  String? _accessToken;

  String? _pendingEmail;
  String? _pendingPassword;
  String? _pendingName;

  AuthProvider({required AuthApi authApi, required ApiClient apiClient})
      : _authApi = authApi,
        _apiClient = apiClient;

  User? get currentUser => _currentUser;
  String? get accessToken => _accessToken;

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    final authRes = await _authApi.login(email: email, password: password);
    _accessToken = authRes.token;
    _currentUser = User(
      id: authRes.id,
      email: authRes.email,
      name: authRes.name,
      preferredGenreIds: authRes.preferredGenreIds,
    );
    await _storage.write(key: 'jwt_token', value: _accessToken!);
    _apiClient.setToken(_accessToken!);

    Navigator.pushReplacementNamed(context, '/home');
    notifyListeners();
  }

  Future<void> signup({
    required String email,
    required String password,
    required String name,
    required BuildContext context,
  }) async {
    _pendingEmail = email;
    _pendingPassword = password;
    _pendingName = name;

    Navigator.pushReplacementNamed(context, '/genre-selection');
  }

  Future<void> completeSignup({
    required BuildContext context,
    required List<int> genreIds,
  }) async {
    final email = _pendingEmail;
    final password = _pendingPassword;
    final name = _pendingName;

    if (email == null || password == null || name == null) {
      // Handle error: missing pending signup data
      return;
    }

    final user = await _authApi.signup(
      email: email,
      password: password,
      name: name,
      preferredGenreIds: genreIds,
    );

    _currentUser = user;

    // If the signup returns an access token, save it
    if (user.token != null) {
      _accessToken = user.token;
      await _storage.write(key: 'jwt_token', value: _accessToken!);
      _apiClient.setToken(_accessToken!);
    }

    _pendingEmail = null;
    _pendingPassword = null;
    _pendingName = null;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('회원가입 성공! 로그인 화면으로 이동합니다.'),),
    );
    Navigator.pushReplacementNamed(context, '/login');
    notifyListeners();
  }

  // /// 소셜 로그인 처리
  // Future<void> handleSocialLogin({
  //   required BuildContext context,
  //   required String provider,
  //   required String idToken,
  //   String? accessToken,   // 카카오 accessToken
  //   String? providerId,    // 소셜 사용자 고유 ID
  // }) async {
  //   final response = await _api.socialAuth(
  //     provider: provider,
  //     idToken: idToken,
  //     accessToken: accessToken,
  //     providerId: providerId,
  //   );
  //
  //   if (response.status == SocialAuthStatus.EXISTING_USER) {
  //     // 기존 회원: JWT 토큰 저장 후 홈으로
  //     if (response.accessToken != null) {
  //       await _storage.write(key: 'jwt_token', value: response.accessToken!);
  //       _client.setToken(response.accessToken!);
  //     }
  //     Navigator.pushReplacementNamed(context, '/home');
  //   } else {
  //     // 신규 회원: 장르 선택을 위해 데이터 임시 저장 후 화면 이동
  //     _pendingSocialData = response;
  //     Navigator.pushReplacementNamed(context, '/genre-selection');
  //   }
  //   notifyListeners();
  // }
  //
  // /// 소셜 회원가입 완료처리
  // Future<void> completeSocialSignup({
  //   required BuildContext context,
  //   required List<int> genreIds,
  // }) async {
  //   final data = _pendingSocialData!;
  //   final auth = await _api.socialSignup(
  //     email: data.email,
  //     name: data.name,
  //     provider: data.provider,
  //     providerId: data.providerId,
  //     preferredGenreIds: genreIds,
  //   );
  //   // 회원가입 완료 후 JWT 토큰 저장, 홈으로
  //   await _storage.write(key: 'jwt_token', value: auth.accessToken);
  //   _client.setToken(auth.accessToken);
  //   _pendingSocialData = null;
  //   notifyListeners();
  //   Navigator.pushReplacementNamed(context, '/home');
  // }
}