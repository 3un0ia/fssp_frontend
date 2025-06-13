import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../models/movie_detail.dart';
import '../widgets/movie_list_item.dart';
import '../services/movie_api.dart';
import 'movie_detail_screen.dart';
import 'home_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late MovieApi _movieApi;

  List<String> recentSearches = [];
  List<String> popularSearches = [];

  List<Movie> searchResults = [];

  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _movieApi = Provider.of<MovieApi>(context, listen: false);
  }

  Future<void> _performSearch(String query) async {
    final results = await _movieApi.search(query, limit: 30);
    setState(() {
      searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Back button navigates back to HomeScreen
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomeScreen()),
            );
          },
        ),
        // Ensure icons are white
        iconTheme: IconThemeData(color: Colors.white),
        // Title: show TextField when searching, otherwise 'Search'
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFF1C2732),
            hintText: '영화 검색...',
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          ),
          onSubmitted: (value) async {
            if (value.isNotEmpty) {
              setState(() {
                if (!recentSearches.contains(value)) {
                  recentSearches.insert(0, value);
                  if (recentSearches.length > 5) {
                    recentSearches.removeLast();
                  }
                }
              });
              // perform real search
              await _performSearch(value);
            }
          },
        )
            : Text('Search',
              style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
        ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.white),
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
                onTap: () async {
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
                  // perform real search
                  await _performSearch(search);
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
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.67,
      ),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final movie = searchResults[index];
        return GestureDetector(
          onTap: () async {
            final MovieDetail detail = await _movieApi.fetchDetail(movie.id);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MovieDetailScreen(movieDetail: detail),
              ),
            );
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
    );
  }
}