import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../widgets/movie_list_item.dart';
import 'movie_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> recentSearches = ['스파이더맨', '마블', '액션'];
  List<String> popularSearches = ['스파이더맨', '이터널스', '베놈 2', '듄'];

  List<Movie> searchResults = [
    Movie(
      id: 1,
      title: '스파이더맨: 노 웨이 홈',
      posterUrl: 'https://image.tmdb.org/t/p/w500/voddFVdjUoAtfoZZp2RUmuZILDI.jpg',
      rating: 4.5,
      year: 2021,
      genre: '액션, 모험, SF',
    ),
    Movie(
      id: 7,
      title: '스파이더맨: 파 프롬 홈',
      posterUrl: 'https://image.tmdb.org/t/p/w500/lcq8dVxeeOqHvvgcte707K0KVx5.jpg',
      rating: 4.3,
      year: 2019,
      genre: '액션, 모험, SF',
    ),
  ];

  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: '영화 검색...',
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
          ),
          onSubmitted: (value) {
            // Perform search
            setState(() {
              if (value.isNotEmpty && !recentSearches.contains(value)) {
                recentSearches.insert(0, value);
                if (recentSearches.length > 5) {
                  recentSearches.removeLast();
                }
              }
            });
          },
        )
            : Text('검색'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                }
              });
            },
          ),
        ],
      ),
      body: _isSearching && _searchController.text.isNotEmpty
          ? _buildSearchResults()
          : _buildSearchHome(),
    );
  }

  Widget _buildSearchHome() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '최근 검색어',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      recentSearches.clear();
                    });
                  },
                  child: Text(
                    '전체 삭제',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: recentSearches.map((search) {
                return Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF2C3B4B),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        search,
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            recentSearches.remove(search);
                          });
                        },
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 24),
          ],
          Text(
            '인기 검색어',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: popularSearches.map((search) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _searchController.text = search;
                    _isSearching = true;
                    if (!recentSearches.contains(search)) {
                      recentSearches.insert(0, search);
                      if (recentSearches.length > 5) {
                        recentSearches.removeLast();
                      }
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF2C3B4B),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    search,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return MovieListItem(
          movie: searchResults[index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailScreen(
                  movie: searchResults[index],
                ),
              ),
            );
          },
        );
      },
    );
  }
}