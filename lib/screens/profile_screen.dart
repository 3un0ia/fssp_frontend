import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_screen.dart';
import '../services/auth_api.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AuthProvider>(context, listen: false);
    final user = authProv.currentUser!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(height: 20),
          Center(
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage('https://via.placeholder.com/100'),
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: Text(
              user.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: Text(
              user.email,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(height: 32),
          _buildProfileSection(
            title: '계정 설정',
            icon: Icons.settings,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.white),
            title: Text('로그아웃', style: TextStyle(color: Colors.white)),
            onTap: () async {
              final authApi = Provider.of<AuthApi>(context, listen: false);
              try {
                await authApi.logout();
                // 로그인 화면으로 완전 교체
                Navigator.pushReplacementNamed(context, '/login');
              } catch (e) {
                // 에러 핸들링: 토스트 등
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('로그아웃 중 오류가 발생했습니다.')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}