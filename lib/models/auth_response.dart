import 'dart:convert';

class AuthResponse {
  final String token;
  final int id;
  final String email;
  final String name;
  final List<int> preferredGenreIds;

  AuthResponse({
    required this.token,
    required this.id,
    required this.email,
    required this.name,
    required this.preferredGenreIds,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    // Decode the name field to handle Korean characters correctly
    String rawName = json['name'] ?? '';
    String decodedName;
    try {
      decodedName = utf8.decode(rawName.codeUnits);
    } catch (_) {
      decodedName = rawName;
    }

    return AuthResponse(
      token: json['jwt'] as String,
      id: json['id'] as int,
      email: json['email'] as String,
      name: decodedName,
      preferredGenreIds: List<int>.from(json['preferredGenreIds'] as List<dynamic>),
    );
  }
}
