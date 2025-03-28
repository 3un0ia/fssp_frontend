import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '설정',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 프로필 섹션
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade800,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // 프로필 이미지
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF3B82F6),
                        width: 2,
                      ),
                      image: const DecorationImage(
                        image: NetworkImage('https://via.placeholder.com/100'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // 사용자 정보
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '사용자',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'user@example.com',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 프로필 편집 버튼
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('프로필 편집'),
                  ),
                ],
              ),
            ),

            // 계정 설정
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '계정',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSettingsItem(
                    icon: Icons.person_outline,
                    title: '개인정보 설정',
                    onTap: () {},
                  ),
                  const SizedBox(height: 16),
                  _buildSettingsItem(
                    icon: Icons.notifications_none,
                    title: '알림 설정',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            // 구분선
            Divider(color: Colors.grey.shade800, height: 1),

            // 앱 설정
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '앱 설정',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSwitchItem(
                    icon: Icons.dark_mode_outlined,
                    title: '다크 모드',
                    value: true,
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 16),
                  _buildSettingsItem(
                    icon: Icons.help_outline,
                    title: '도움말',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            // 구분선
            Divider(color: Colors.grey.shade800, height: 1),

            // 로그아웃
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.logout,
                  color: Colors.red[400],
                ),
                label: Text(
                  '로그아웃',
                  style: TextStyle(
                    color: Colors.red[400],
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
              ),
            ),

            // 앱 버전 정보
            const SizedBox(height: 32),
            Center(
              child: Column(
                children: const [
                  Text(
                    '앱 버전 1.0.0',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '© 2023 영화 추천 서비스',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF94A3B8),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title),
          ),
          const Icon(
            Icons.chevron_right,
            color: Color(0xFF94A3B8),
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF94A3B8),
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(title),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF3B82F6),
        ),
      ],
    );
  }
}

