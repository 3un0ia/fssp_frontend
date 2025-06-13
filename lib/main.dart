import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'services/api_client.dart';
import 'services/auth_api.dart';
import 'services/movie_api.dart';
import 'services/watchlist_api.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/genre_selection_screen.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

void main() {
  final apiClient = ApiClient(baseUrl: "http://127.0.0.1:8080");
  final authApi = AuthApi(client: apiClient);
  final movieApi = MovieApi(client: apiClient);
  final watchlistApi = WatchlistApi(client: apiClient);
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        Provider<ApiClient>.value(value: apiClient),
        Provider<MovieApi>.value(value: movieApi),
        Provider<AuthApi>.value(value: authApi),
        Provider<WatchlistApi>.value(value: watchlistApi),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(authApi: authApi, apiClient: apiClient),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      navigatorObservers: [routeObserver],
      initialRoute: '/login',
      routes: {
        '/login' : (_) => const LoginScreen(),
        '/home' : (_) => const HomeScreen(),
        '/signup' : (_) => const RegisterScreen(),
        '/genre-selection' : (_) => GenreSelectionScreen(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF1C2732),
        scaffoldBackgroundColor: Color(0xFF1C2732),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1C2732),
          elevation: 0,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF0A84FF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
      home: LoginScreen(),
    );
  }
}