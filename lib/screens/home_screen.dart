import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../widgets/movie_detail_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 추천 영화 데이터
  final List<Movie> topRecommendations = [
    Movie(id: 1, title: "인터스텔라", rating: 4.8, year: 2014, genre: "SF"),
    Movie(id: 2, title: "다크 나이트", rating: 4.9, year: 2008, genre: "액션"),
    Movie(id: 3, title: "기생충", rating: 4.7, year: 2019, genre: "드라마"),
  ];

  // 장르별 영화 데이터
  final List<Map<String, dynamic>> moviesByGenre = [
    {
      'genre': "액션",
      'movies': [
        Movie(id: 4, title: "존 윅 4", rating: 4.5, year: 2023),
        Movie(id: 5, title: "미션 임파서블", rating: 4.3, year: 2023),
        Movie(id: 6, title: "매드 맥스: 분노의 도로", rating: 4.6, year: 2015),
        Movie(id: 7, title: "어벤져스: 엔드게임", rating: 4.7, year: 2019),
        Movie(id: 8, title: "킹스맨", rating: 4.2, year: 2015),
      ]
    },
    {
      'genre': "SF",
      'movies': [
        Movie(id: 9, title: "듄", rating: 4.4, year: 2021),
        Movie(id: 10, title: "블레이드 러너 2049", rating: 4.5, year: 2017),
        Movie(id: 11, title: "메트릭스", rating: 4.8, year: 1999),
        Movie(id: 12, title: "컨택트", rating: 4.3, year: 2016),
        Movie(id: 13, title: "마션", rating: 4.4, year: 2015),
      ]
    },
    {
      'genre': "드라마",
      'movies': [
        Movie(id: 14, title: "쇼생크 탈출", rating: 4.9, year: 1994),
        Movie(id: 15, title: "포레스트 검프", rating: 4.8, year: 1994),
        Movie(id: 16, title: "그린 북", rating: 4.6, year: 2018),
        Movie(id: 17, title: "위플래쉬", rating: 4.7, year: 2014),
        Movie(id: 18, title: "라라랜드", rating: 4.5, year: 2016),
      ]
    },
    {
      'genre': "코미디",
      'movies': [
        Movie(id: 19, title: "죽은 시인의 사회", rating: 4.7, year: 1989),
        Movie(id: 20, title: "트루먼 쇼", rating: 4.6, year: 1998),
        Movie(id: 21, title: "리틀 미스 선샤인", rating: 4.5, year: 2006),
        Movie(id: 22, title: "조조 래빗", rating: 4.4, year: 2019),
        Movie(id: 23, title: "그랜드 부다페스트 호텔", rating: 4.5, year: 2014),
      ]
    },
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
      body: CustomScrollView(
        slivers: [
          // 검색 바
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: TextField(
              decoration: InputDecoration(
                hintText: '영화, 배우, 감독 검색',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8)),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),

          // 상위 추천 영화
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '추천 영화',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  // 메인 추천 영화
                  GestureDetector(
                    onTap: () => _openMovieDetail(context, topRecommendations[0]),
                    child: Container(
                      height: 240,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: const DecorationImage(
                          image: NetworkImage('https://via.placeholder.com/600x400'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // 그라데이션 오버레이
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black],
                              ),
                            ),
                          ),
                          // 영화 정보
                          Positioned(
                            bottom: 16,
                            left: 16,
                            right: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2563EB),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        'TOP 1',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.star, color: Colors.amber, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      topRecommendations[0].rating.toString(),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  topRecommendations[0].title,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${topRecommendations[0].year} · ${topRecommendations[0].genre}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFFCBD5E1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 추가 추천 영화
                  Row(
                    children: [
                      for (int i = 1; i < topRecommendations.length; i++)
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _openMovieDetail(context, topRecommendations[i]),
                            child: Container(
                              margin: EdgeInsets.only(
                                right: i < topRecommendations.length - 1 ? 8 : 0,
                              ),
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: const DecorationImage(
                                  image: NetworkImage('https://via.placeholder.com/150x200'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  // 그라데이션 오버레이
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [Colors.transparent, Colors.black],
                                      ),
                                    ),
                                  ),
                                  // 영화 정보
                                  Positioned(
                                    bottom: 8,
                                    left: 8,
                                    right: 8,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF2563EB),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            'TOP ${i + 1}',
                                            style: const TextStyle(fontSize: 10),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          topRecommendations[i].title,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 장르별 영화 목록
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final category = moviesByGenre[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            category['genre'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text('더보기'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 16),
                        itemCount: category['movies'].length,
                        itemBuilder: (context, movieIndex) {
                          final movie = category['movies'][movieIndex];
                          return GestureDetector(
                            onTap: () => _openMovieDetail(context, movie),
                            child: Container(
                              width: 120,
                              margin: const EdgeInsets.only(right: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 영화 포스터
                                  Container(
                                    height: 160,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: const DecorationImage(
                                        image: NetworkImage('https://via.placeholder.com/150x200'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        // 그라데이션 오버레이
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            height: 60,
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.only(
                                                bottomLeft: Radius.circular(12),
                                                bottomRight: Radius.circular(12),
                                              ),
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.black.withOpacity(0.8),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        // 평점
                                        Positioned(
                                          bottom: 8,
                                          left: 8,
                                          child: Row(
                                            children: [
                                              const Icon(Icons.star, color: Colors.amber, size: 12),
                                              const SizedBox(width: 2),
                                              Text(
                                                movie.rating.toString(),
                                                style: const TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // 영화 제목
                                  Text(
                                    movie.title,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
              childCount: moviesByGenre.length,
            ),
          ),
        ],
      ),
    );
  }
}

