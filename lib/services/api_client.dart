import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  String? _jwtToken;
  final http.Client httpClient;

  ApiClient({required this.baseUrl, http.Client? client})
      : httpClient = client ?? http.Client();

  void setToken(String token) {
    _jwtToken = token;
  }

  void clearToken() {
    _jwtToken = null;
  }

  Map<String, String> _buildHeaders() {
    return {
      'Content-Type': 'application/json',
      if (_jwtToken != null) 'Authorization': 'Bearer $_jwtToken',
    };
  }

  Future<http.Response> get(String path, [Map<String, String>? params]) {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: params);
    return http.get(
      uri,
      headers: _buildHeaders(),
    );
  }

  Future<http.Response> post(String path, [dynamic body]) {
    return http.post(
      Uri.parse('$baseUrl$path'),
      headers: _buildHeaders(),
      body: body,
    );
  }

  Future<http.Response> delete(String path) {
    final uri = Uri.parse('$baseUrl$path');
    return http.delete(
      uri,
      headers: _buildHeaders(),
    );
  }
}