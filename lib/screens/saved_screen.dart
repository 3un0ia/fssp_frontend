import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../widgets/movie_detail_modal.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({Key? key}) : super(key: key);

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  final List<Movie> savedMovies = [
    Movie(
        id: 1,
        title: "인터스텔라",
        director: "크리스토퍼 놀란",
        year: 2014,
        rating: 4.8,
        savedDate: "2023-08-15"
    ),
    Movie(
        id: 2,
        title: "다크 나이트",
        director: "크리스토퍼 놀란",
        year: 2008,
        rating: 4.9,
        savedDate: "2023-08-10"
    ),
    Movie(
        id: 3,
        title: "기생충",
        director: "봉준호",
        year: 2019,
        rating: 4.7,
        savedDate: "2023-08-05"
    ),
    Movie(
        id: 4,
        title: "어벤져스: 엔드게임",
        director: "루소 형제",
        year: 2019,
        rating: 4.7,
        savedDate: "2023-07-28"
    ),
    Movie(
        id: 5,
        title: "조커",
        director: "토드 필립스",
        year: 2019,
        rating: 4.5,
        savedDate: "2023-07-20"
    ),
    Movie(
        id: 6,
        title: "매트릭스",
        director: "워쇼스키 자매",
        year: 1999,
        rating: 4.8,
        savedDate: "2023-07-15"
    ),
  ];

  void _openMovieDetail(BuildContext context, Movie movie) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MovieDetailModal(movie: movie),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '저장한 영화',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: savedMovies.length,
          itemBuilder: (context, index) {
            final movie = savedMovies[index];
            return GestureDetector(
              onTap: () => _openMovieDetail(context, movie),
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    // 영화 포스터
                    Container(
                      width: 80,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                        image: const DecorationImage(
                          image: NetworkImage('https://via.placeholder.com/150x200'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // 영화 정보
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${movie.director} · ${movie.year}',
                              style: const TextStyle(
                                color: Color(0xFFCBD5E1),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  movie.rating.toString(),
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 좋아요 아이콘
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Icon(
                        Icons.favorite,
                        color: Colors.red[500],
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

