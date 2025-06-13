import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie_detail.dart';
import '../widgets/cast_list.dart';
import 'chat_screen.dart';
import '../services/api_client.dart';
import '../services/watchlist_api.dart';

class MovieDetailScreen extends StatefulWidget {
  final MovieDetail movieDetail;
  const MovieDetailScreen({Key? key, required this.movieDetail}) : super(key: key);
  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late final ApiClient apiClient;
  late final WatchlistApi _watchlistApi;
  bool? _isSaved;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    apiClient = Provider.of<ApiClient>(context, listen: false);
    _watchlistApi = WatchlistApi(client: apiClient);
    _loadSavedState();
  }

  Future<void> _loadSavedState() async {
    setState(() => _isSaved = null);
    try {
      final favorites = await _watchlistApi.listFavorites();
      final contains = favorites.any((m) => m.id == widget.movieDetail.id);
      if (!mounted) return;
      setState(() => _isSaved = contains);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaved = false);
    }
  }

  Future<void> _toggleWatchlist() async {
    if (_isSaved == null) return;
    setState(() => _isSaved = !_isSaved!);
    try {
      if (_isSaved!) {
        await _watchlistApi.addFavorite(widget.movieDetail.id);
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added to watchlist')));
      } else {
        await _watchlistApi.removeFavorite(widget.movieDetail.id);
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Removed from watchlist')));
      }
    } catch (_) {
      if (mounted) setState(() => _isSaved = !_isSaved!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: CustomScrollView(
          slivers: [
          // TOP SLIVER APP BAR
          SliverAppBar(
            pinned: true,
            backgroundColor: Color(0xFF1C2732),
            toolbarHeight: 56,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 24),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(
                  _isSaved == true ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: (_isSaved == null) ? null : _toggleWatchlist,
              ),
            ],
          ),
          // COMBINED BACKDROP + INFO + POSTER OVERLAY
          SliverToBoxAdapter(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Backdrop image
                    SizedBox(
                      height: 200,
                      child: Image.network(
                        widget.movieDetail.backdropUrl ?? widget.movieDetail.posterUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Metadata container (title at top, metadata wrap at bottom)
                    Container(
                      color: Color(0xFF1C2732),
                      padding: const EdgeInsets.fromLTRB(152, 16, 16, 16),
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.movieDetail.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Color(0xFF1C2732),
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      height: 65,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                // Year
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
                                    SizedBox(width: 4),
                                    Text('${widget.movieDetail.year}', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                                  ],
                                ),
                                Text('|', style: TextStyle(color: Colors.grey[500], fontSize: 20)),
                                // Runtime
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                                    SizedBox(width: 4),
                                    Text('${widget.movieDetail.runtime}분', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                                  ],
                                ),
                                Text('|', style: TextStyle(color: Colors.grey[500], fontSize: 20)),
                                // Genres - wraps to next line if too long
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.category, size: 14, color: Colors.grey[500]),
                                    SizedBox(width: 4),
                                    Text(
                                      widget.movieDetail.genres.join(', '),
                                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                // Poster overlapping backdrop and metadata
                Positioned(
                  top: 200 - 90, // 110pt down from top of this sliver
                  left: 16,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.movieDetail.posterUrl,
                      width: 120,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Rating badge on top of backdrop (optional reposition)
                Positioned(
                  right: 16,
                  top: 200 - 24 - 16, // just above poster top
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: Color(0xFFFF7E00), size: 18),
                        SizedBox(width: 4),
                        Text(
                          widget.movieDetail.rating.toStringAsFixed(1),
                          style: TextStyle(
                            color: Color(0xFFFF7E00),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // TAB BAR
          SliverPersistentHeader(
            pinned: false,
            delegate: _SliverAppBarDelegate(
              TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Color(0xFF0296E5),
                tabs: [
                  Tab(text: '줄거리'),
                  Tab(text: '리뷰'),
                  Tab(text: '감독/출연'),
                ],
              ),
            ),
          ),
          // TAB CONTENT
          SliverFillRemaining(
            child: TabBarView(
              children: [
                // 줄거리
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    widget.movieDetail.overview,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                // 리뷰 (채팅형식)
                ChatScreen(movie: widget.movieDetail),
                // 감독/출연
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '감독',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.movieDetail.director is List
                            ? (widget.movieDetail.director as List).join(', ')
                            : widget.movieDetail.director.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '출연진',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CastList(widget.movieDetail.cast),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ],
        ),
      ),
    );
  }
}

// Delegate class for pinned TabBar
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  _SliverAppBarDelegate(this._tabBar);
  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color:Color(0xFF1C2732), child: _tabBar);
  }
  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}