import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../widgets/movie_detail_modal.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  final List<String> recentSearches = [
    "크리스토퍼 놀란",
    "톰 크루즈",
    "인터스텔라",
    "어벤져스"
  ];

  final List<String> trendingSearches = [
    "듄: 파트 2",
    "오펜하이머",
    "데드풀 3",
    "미션 임파서블",
    "봉준호"
  ];

  final List<Movie> searchResults = [
    Movie(id: 1, title: "인터스텔라", director: "크리스토퍼 놀란", year: 2014, rating: 4.8),
    Movie(id: 2, title: "덩케르크", director: "크리스토퍼 놀란", year: 2017, rating: 4.6),
    Movie(id: 3, title: "테넷", director: "크리스토퍼 놀란", year: 2020, rating: 4.3),
    Movie(id: 4, title: "메멘토", director: "크리스토퍼 놀란", year: 2000, rating: 4.7),
    Movie(id: 5, title: "인셉션", director: "크리스토퍼 놀란", year: 2010, rating: 4.8),
    Movie(id: 6, title: "다크 나이트", director: "크리스토퍼 놀란", year: 2008, rating: 4.9),
  ];

  void _handleSearch() {
    if (_searchController.text.trim().isNotEmpty) {
      setState(() {
        _isSearching = true;
      });
    }
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _isSearching = false;
    });
  }

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
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: '영화, 배우, 감독 검색',
            prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8)),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.clear, color: Color(0xFF94A3B8)),
              onPressed: _clearSearch,
            )
                : null,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
          onSubmitted: (_) => _handleSearch(),
          onChanged: (value) {
            setState(() {});
          },
        ),
      ),
      body: _isSearching
          ? _buildSearchResults()
          : _buildSearchSuggestions(),
    );
  }

  Widget _buildSearchSuggestions() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 최근 검색어
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.history, size: 18, color: Color(0xFF94A3B8)),
                  SizedBox(width: 8),
                  Text(
                    '최근 검색어',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: const Text('전체 삭제'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: recentSearches.map((term) {
              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(term),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        // 검색어 삭제 로직
                      },
                      child: const Icon(Icons.close, size: 16, color: Color(0xFF94A3B8)),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // 인기 검색어
          Row(
            children: const [
              Icon(Icons.trending_up, size: 18, color: Color(0xFF94A3B8)),
              SizedBox(width: 8),
              Text(
                '인기 검색어',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: trendingSearches.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(trendingSearches[index]),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '검색 결과',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final movie = searchResults[index];
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
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

