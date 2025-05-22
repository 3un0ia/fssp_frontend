import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../widgets/movie_grid_item.dart';
import 'movie_detail_screen.dart';

class SavedScreen extends StatefulWidget {
  @override
  _SavedScreenState createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Movie> savedMovies = [
    Movie(
      id: 1,
      title: '스파이더맨: 노 웨이 홈',
      posterUrl: 'https://image.tmdb.org/t/p/w500/voddFVdjUoAtfoZZp2RUmuZILDI.jpg',
      rating: 4.5,
      year: 2021,
    ),
    Movie(
      id: 2,
      title: '이터널스',
      posterUrl: 'https://image.tmdb.org/t/p/w500/bcCBq9N1EMo3daNIjWJ8kYvrQm6.jpg',
      rating: 3.8,
      year: 2021,
    ),
    Movie(
      id: 3,
      title: '베놈 2',
      posterUrl: 'https://image.tmdb.org/t/p/w500/rjkmN1dniUHVYAtwuV3Tji7FsDO.jpg',
      rating: 4.0,
      year: 2021,
    ),
    Movie(
      id: 4,
      title: '듄',
      posterUrl: 'https://image.tmdb.org/t/p/w500/jYEW5xZkZk2WTrdbMGAPFuBqbDc.jpg',
      rating: 4.2,
      year: 2021,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('저장 목록'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blue,
          tabs: [
            Tab(text: '전체'),
            Tab(text: '영화'),
            Tab(text: '시리즈'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMovieGrid(savedMovies),
          _buildMovieGrid(savedMovies.where((m) => m.id % 2 == 0).toList()),
          _buildMovieGrid(savedMovies.where((m) => m.id % 2 != 0).toList()),
        ],
      ),
    );
  }

  Widget _buildMovieGrid(List<Movie> movies) {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return MovieGridItem(
          movie: movies[index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailScreen(
                  movie: movies[index],
                ),
              ),
            );
          },
        );
      },
    );
  }
}