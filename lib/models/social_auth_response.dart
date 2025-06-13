enum SocialAuthStatus { EXISTING_USER, NEED_SIGNUP }

class SocialAuthResponse {
  final SocialAuthStatus status;
  final String? accessToken;  // 로그인 완료 시 발급된 JWT 토큰
  final String email;
  final String name;
  final String provider;     // "KAKAO" or "GOOGLE"
  final String providerId;   // 카카오 userId 또는 구글 sub

  SocialAuthResponse({
    required this.status,
    this.accessToken,
    required this.email,
    required this.name,
    required this.provider,
    required this.providerId,
  });

  factory SocialAuthResponse.fromJson(Map<String, dynamic> json) {
    return SocialAuthResponse(
      status: json['status'] == 'EXISTING_USER'
          ? SocialAuthStatus.EXISTING_USER
          : SocialAuthStatus.NEED_SIGNUP,
      accessToken: json['accessToken'],
      email: json['email'],
      name: json['name'],
      provider: json['provider'],
      providerId: json['providerId'],
    );
  }
}