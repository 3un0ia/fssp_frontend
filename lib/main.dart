import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/saved_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 상태바 색상 설정
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return MaterialApp(
      title: '영화 추천 앱',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0F172A), // slate-900
        primaryColor: const Color(0xFF3B82F6), // blue-500
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF3B82F6), // blue-500
          secondary: const Color(0xFF1E293B), // slate-800
          surface: const Color(0xFF1E293B), // slate-800
          background: const Color(0xFF0F172A), // slate-900
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFF1F5F9)), // slate-100
          bodyMedium: TextStyle(color: Color(0xFFF1F5F9)), // slate-100
          titleLarge: TextStyle(color: Color(0xFFF1F5F9), fontWeight: FontWeight.bold),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F172A), // slate-900
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1E293B), // slate-800
          selectedItemColor: Color(0xFF60A5FA), // blue-400
          unselectedItemColor: Color(0xFF94A3B8), // slate-400
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF1E293B), // slate-800
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1E293B), // slate-800
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          hintStyle: const TextStyle(color: Color(0xFF94A3B8)), // slate-400
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const SavedScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: '검색',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border_outlined),
            activeIcon: Icon(Icons.bookmark),
            label: '저장됨',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
      ),
    );
  }
}

