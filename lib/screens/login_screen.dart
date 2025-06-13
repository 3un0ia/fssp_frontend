import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'register_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40),
              Text(
                '로그인',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: '이메일',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: '비밀번호',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF162D3A),
                  side: BorderSide(color: Color(0xFF0296E5)),
                ),
                onPressed: () async {
                  final email = _emailController.text.trim();
                  final password = _passwordController.text.trim();
                  try {
                    await authProv.login(email: email, password: password, context: context);
                    Navigator.pushReplacementNamed(context, '/home');
                  } catch (e) {
                    setState(() {
                      _errorMessage = '로그인 실패: ${e.toString()}';
                    });
                  }
                },
                child: Text(
                  '로그인',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              if (_errorMessage != null) ...[
                SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '계정이 없으신가요? ',
                    style: TextStyle(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RegisterScreen()),
                      );
                    },
                    child: Text(
                      '회원가입하기',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}