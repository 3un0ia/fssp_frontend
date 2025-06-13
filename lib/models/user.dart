import 'dart:convert';

class User {
  final String? token;
  final int id;            // 서버에서 할당된 PK (필요 없으면 제외)
  final String email;
  final String name;
  final List<int> preferredGenreIds; // 예: ["Action", "Comedy"]
  // 추가로 필요한 필드가 있으면 여기에 추가하기 (예: avatarUrl, 가입일 등)

  User({
    this.token,
    required this.id,
    required this.email,
    required this.name,
    required this.preferredGenreIds,
  });

  // 서버가 보내주는 JSON 구조에 맞춰서 fromJson 작성
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['jwt'] as String?,
      id: json['id'] as int,
      email: json['email'] as String,
      name: json['name'] as String,
      preferredGenreIds: List<int>.from(json['preferredGenreIds'] as List<dynamic>)
    );
  }

  // 서버로 보낼 때, JSON 포맷으로 변환
  Map<String, dynamic> toJson() {
    return {
      'token' : token,
      'id': id,
      'email': email,
      'name': name,
      'preferredGenreIds': preferredGenreIds,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}