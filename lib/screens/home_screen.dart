import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../services/api_client.dart';
import '../models/movie.dart';
import '../models/movie_detail.dart';
import '../services/movie_api.dart';
import 'movie_detail_screen.dart';
import 'search_screen.dart';
// import 'saved_screen.dart';
import 'watchlist_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  late MovieApi _movieApi;
  bool _isInit = false;

  late Future<List<Movie>> _popularFuture;
  late Future<List<Movie>> _genreMoviesFuture;

  // Map of genre names to IDs; adjust IDs to match backend values
  final Map<String, int> _genreMap = {
    'All': 0,
    'Action': 28,
    'Adventure': 12,
    'Animation': 16,
    'Comedy': 35,
    'Crime': 80,
    'Documentary': 99,
    'Drama': 18,
    'Family': 10751,
    'Fantasy': 14,
    'History': 36,
    'Horror': 27,
    'Music': 10402,
    'Mystery': 9648,
    'Romance': 10749,
    'Science Fiction': 878,
    'Thriller': 53,
    'War': 10752,
    'Western': 37,
  };


  String _selectedGenre = 'All';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final apiClient = Provider.of<ApiClient>(context, listen: false);
      _movieApi = MovieApi(client: apiClient);

      _popularFuture = _movieApi.fetchPopular();
      // 처음엔 'All' 선택이므로 recommendCombined() 호출
      _genreMoviesFuture = _movieApi.recommendCombined(limit: 5);

      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        // Prevent popping back to the login screen
        onWillPop: () async {
          // Optionally, you could show a confirmation dialog here
          return false; // Do not allow back navigation
        },
        child: SafeArea(
          child: IndexedStack(
            index: _currentIndex,
            children: [
              _buildHomeTab(),
              SearchScreen(),
              WatchlistScreen(),
              ProfileScreen(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: const Color(0xFF1C2732),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Watchlist'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1) '추천 영화' 타이틀
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '추천 영화',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // 2) 인기 영화 (FutureBuilder + 가로 스크롤)
          SizedBox(
            height: 200,
            child: FutureBuilder<List<Movie>>(
              future: _popularFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // 로딩 중
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // 에러 발생
                  return Center(
                    child: Text(
                      '영화 로드 실패: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      '추천 영화가 없습니다.',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                final movies = snapshot.data!;
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return _buildNumberedPoster(movie, index + 1);
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // 3) 장르 선택 바 (가로 스크롤)
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _genreMap.keys.map((genreName) {
                final isSelected = genreName == _selectedGenre;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedGenre = genreName;
                        if (genreName == 'All') {
                          _genreMoviesFuture =
                              _movieApi.recommendCombined(limit: 21);
                        } else {
                          final genreId = _genreMap[genreName]!;
                          print('> 선택된 장르: $genreName => genreMap[$genreName] = $genreId');
                          _genreMoviesFuture = _movieApi.recommendByGenres(genreId, limit: 21);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF0296E5)
                            : Colors.grey[800],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        genreName,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // 4) 선택된 장르 영화 (FutureBuilder + GridView)
          FutureBuilder<List<Movie>>(
            future: _genreMoviesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '영화 로드 실패: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    '선택된 장르의 영화가 없습니다.',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              final movies = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return GestureDetector(
                      onTap: () async {
                        // 상세 정보 API 호출
                        try {
                          MovieDetail movieDetail =
                              await _movieApi.fetchDetail(movie.id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MovieDetailScreen(movieDetail: movieDetail),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('영화 상세 정보를 불러오지 못했습니다.')),
                          );
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          movie.posterUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildNumberedPoster(Movie movie, int number) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: GestureDetector(
        onTap: () async {
          // 상세 정보 API 호출
          try {
            MovieDetail movieDetail =
                await _movieApi.fetchDetail(movie.id);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailScreen(movieDetail: movieDetail),
              ),
            );
          } catch (e) {
            // 에러 처리 (예: 토스트 메시지)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('영화 상세 정보를 불러오지 못했습니다.')),
            );
          }
        },
        child: SizedBox(
          width: 120,
          child: Stack(
            children: [
              // 영화 포스터
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  movie.posterUrl,
                  height: 180,
                  width: 120,
                  fit: BoxFit.cover,
                ),
              ),
              // 넘버링 (왼쪽 하단, 바깥으로 튀어나오게)
              Positioned(
                bottom: -8,
                left: -8,
                child: Stack(
                  children: [
                    // 외곽선 (stroke)
                    Text(
                      '$number',
                      style: TextStyle(
                        fontSize: 64,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 3.0              // 두께 조정
                          ..strokeJoin = StrokeJoin.round // 모서리 둥글게 처리
                          ..color = Color(0xFF0296E5),
                      ),
                    ),
                    // 내부 채우기 (fill, bold)
                    Text(
                      '$number',
                      style: TextStyle(
                        fontSize: 64,
                        color: Color(0xFF1C2732),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}