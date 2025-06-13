import 'package:flutter/material.dart';
import 'account_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
      ),
      body: ListView(
        children: [
          _buildSettingSection(
            title: '계정 설정',
            icon: Icons.person,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountSettingsScreen()),
              );
            },
          ),
          _buildSettingSection(
            title: '선호 영화 장르',
            icon: Icons.tag,
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => TagSettingsScreen()),
              // );
            },
          ),
          _buildSettingSection(
            title: '알림 설정',
            icon: Icons.notifications,
            onTap: () {},
          ),
          _buildSettingSection(
            title: '다크 모드',
            icon: Icons.dark_mode,
            trailing: Switch(
              value: true,
              onChanged: (value) {},
              activeColor: Colors.blue,
            ),
            onTap: () {},
          ),
          _buildSettingSection(
            title: '앱 정보',
            icon: Icons.info,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSettingSection({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    Color? textColor,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: textColor ?? Colors.white,
      ),
      title: Text(
        title,
        style: TextStyle(color: textColor ?? Colors.white),
      ),
      trailing: trailing ?? Icon(
        Icons.chevron_right,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}