import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie_detail.dart';
import 'movie_detail_screen.dart';
import '../services/api_client.dart';
import '../services/watchlist_api.dart';
import '../services/movie_api.dart';
import 'package:flutter/widgets.dart';
import '../main.dart'; // for routeObserver

class WatchlistScreen extends StatefulWidget {
  @override
  _WatchlistScreenState createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen>
    with SingleTickerProviderStateMixin, RouteAware {
  late TabController _tabController;

  late final ApiClient apiClient;
  late final WatchlistApi watchlistApi;
  late final MovieApi movieApi;

  bool _isInit = false;

  List<MovieDetail> allMovies = [];
  List<MovieDetail> movies = [];
  List<MovieDetail> tvShows = [];

  bool _isLoading = true;
  bool _isGridView = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      apiClient    = Provider.of<ApiClient>(context, listen: false);
      movieApi     = MovieApi(client: apiClient);
      watchlistApi = WatchlistApi(client: apiClient);

      routeObserver.subscribe(this, ModalRoute.of(context)!);
      _fetchWatchlist();

      _isInit = true;
    }
  }

  Future<void> _fetchWatchlist() async {
    setState(() => _isLoading = true);
    // Fetch full watchlist (both movies and TV)
    final List<MovieDetail> list = await watchlistApi.listFavorites();
    setState(() {
      allMovies = list;
      movies = list;
      tvShows = [];
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when coming back to this screen
    _fetchWatchlist();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Watchlist',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF1C2732),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _isGridView ? Icons.list : Icons.grid_view,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.white, size: 24),
            color: Color(0xFF2C3B4B),
            onSelected: (value) {
              switch (value) {
                case 'sort_title':
                  _sortByTitle();
                  break;
                case 'sort_rating':
                  _sortByRating();
                  break;
                case 'sort_year':
                  _sortByYear();
                  break;
                case 'clear_all':
                  _showClearAllDialog();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'sort_title',
                child: Text('제목순 정렬', style: TextStyle(color: Colors.white, fontSize: 14)),
              ),
              PopupMenuItem(
                value: 'sort_rating',
                child: Text('평점순 정렬', style: TextStyle(color: Colors.white, fontSize: 14)),
              ),
              PopupMenuItem(
                value: 'sort_year',
                child: Text('연도순 정렬', style: TextStyle(color: Colors.white, fontSize: 14)),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                value: 'clear_all',
                child: Text('전체 삭제', style: TextStyle(color: Colors.red, fontSize: 14)),
              ),
            ],
          ),
        ],
        // bottom: TabBar(
        //   controller: _tabController,
        //   indicatorColor: Color(0xFF0A84FF),
        //   labelColor: Colors.white,
        //   unselectedLabelColor: Colors.grey,
        //   labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        //   tabs: [
        //     Tab(text: '전체 (${allMovies.length})'),
        //     Tab(text: '영화 (${movies.length})'),
        //     Tab(text: 'TV 시리즈 (${tvShows.length})'),
        //   ],
        // ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMovieList(allMovies),
          _buildMovieList(movies),
          _buildMovieList(tvShows),
        ],
      ),
    );
  }

  Widget _buildMovieList(List<MovieDetail> movies) {
    if (movies.isEmpty) {
      return Container(
        color: Color(0xFF20232A),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bookmark_border,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                '저장된 영화가 없습니다',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '관심있는 영화를 저장해보세요',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      color: Color(0xFF20232A),
      child: _isGridView ? _buildGridView(movies) : _buildListView(movies),
    );
  }

  Widget _buildGridView(List<MovieDetail> movies) {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailScreen(
                  movieDetail: movies[index],
                ),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              movies[index].posterUrl,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  Widget _buildListView(List<MovieDetail> movies) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return
        Dismissible(
          key: Key(movies[index].id.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20),
            color: Colors.red,
            child: Icon(Icons.delete, color: Colors.white, size: 28),
          ),
          onDismissed: (direction) => _removeFromWatchlist(movies[index]),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailScreen(
                    movieDetail: movies[index],
                  ),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      movies[index].posterUrl,
                      width: 80,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movies[index].title,
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            SizedBox(width: 4),
                            Text(
                              movies[index].rating.toStringAsFixed(1),
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.category, color: Colors.grey[300], size: 16),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                movies[index].genres.isNotEmpty ? movies[index].genres.join(', ') : 'Unknown',
                                style: TextStyle(color: Colors.grey[300], fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.grey[300], size: 16),
                            SizedBox(width: 4),
                            Text('${movies[index].year}', style: TextStyle(color: Colors.grey[300], fontSize: 12)),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.grey[300], size: 16),
                            SizedBox(width: 4),
                            Text('${movies[index].runtime} minutes', style: TextStyle(color: Colors.grey[300], fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _removeFromWatchlist(MovieDetail movie) {
    setState(() {
      allMovies.removeWhere((m) => m.id == movie.id);
      movies.removeWhere((m) => m.id == movie.id);
      tvShows.removeWhere((m) => m.id == movie.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${movie.title}이(가) 리스트에서 제거되었습니다'),
        backgroundColor: Color(0xFF2C3B4B),
        action: SnackBarAction(
          label: '실행 취소',
          textColor: Color(0xFF0A84FF),
          onPressed: () {
            // Implement undo functionality
            setState(() {
              allMovies.add(movie);
              movies.add(movie);
            });
          },
        ),
      ),
    );
  }

  void _sortByTitle() {
    setState(() {
      allMovies.sort((a, b) => a.title.compareTo(b.title));
      movies.sort((a, b) => a.title.compareTo(b.title));
      tvShows.sort((a, b) => a.title.compareTo(b.title));
    });
  }

  void _sortByRating() {
    setState(() {
      allMovies.sort((a, b) => b.rating.compareTo(a.rating));
      movies.sort((a, b) => b.rating.compareTo(a.rating));
      tvShows.sort((a, b) => b.rating.compareTo(a.rating));
    });
  }

  void _sortByYear() {
    setState(() {
      allMovies.sort((a, b) => b.year.compareTo(a.year));
      movies.sort((a, b) => b.year.compareTo(a.year));
      tvShows.sort((a, b) => b.year.compareTo(a.year));
    });
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF2C3B4B),
          title: Text(
            '전체 삭제',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            '저장된 모든 영화를 삭제하시겠습니까?',
            style: TextStyle(color: Colors.grey[300]),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                '취소',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  allMovies.clear();
                  movies.clear();
                  tvShows.clear();
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('모든 영화가 삭제되었습니다'),
                    backgroundColor: Color(0xFF2C3B4B),
                  ),
                );
              },
              child: Text(
                '삭제',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}