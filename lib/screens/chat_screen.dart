import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/movie_detail.dart';
import '../models/review.dart';
import '../widgets/chat_message.dart';
import 'package:provider/provider.dart';
import '../services/api_client.dart';
import '../services/review_api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChatScreen extends StatefulWidget {
  final MovieDetail movie;

  const ChatScreen({Key? key, required this.movie}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  late final ReviewApi _reviewApi;
  late String _currentUsername;
  List<Map<String, dynamic>> _messages = [];
  bool _loading = true;

  late final FocusNode _messageFocusNode;
  int? _selectedRating;

  @override
  void initState() {
    super.initState();
    _messageFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final apiClient = Provider.of<ApiClient>(context, listen: false);
      _reviewApi = ReviewApi(apiClient);
      _currentUsername = await _secureStorage.read(key: 'username') ?? 'User';
      await _loadReviews();
    });
  }

  @override
  void dispose() {
    _messageFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _askRating() async {
    double tempRating = _selectedRating?.toDouble() ?? 5.0;
    final result = await showDialog<double>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Color(0xFF1C2732),
              title: Text('별점 설정', style: TextStyle(color: Colors.white)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Slider(
                    value: tempRating,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    activeColor: Color(0xFF0296E5),
                    inactiveColor: Colors.grey,
                    label: tempRating.round().toString(),
                    onChanged: (v) => setState(() => tempRating = v),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Color(0xFFFF7E00)),
                      SizedBox(width: 8),
                      Text(
                        '${tempRating.round()}',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text('취소', style: TextStyle(color: Colors.grey)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text('확인', style: TextStyle(color: Color(0xFF0296E5))),
                  onPressed: () => Navigator.of(context).pop(tempRating),
                ),
              ],
            );
          },
        );
      },
    );
    if (result != null) {
      setState(() => _selectedRating = result.round());
    }
    _messageFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _loading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      return ChatMessage(
                        username: msg['username'],
                        text: msg['text'],
                        isUser: msg['isUser'],
                        time: msg['time'],
                      );
                    },
                  ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Color(0xFF2C3B4B),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, -1),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    focusNode: _messageFocusNode,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF1C2732),
                      hintText: _selectedRating == null
                          ? '별점을 설정해 주세요'
                          : '리뷰 남기기 ($_selectedRating점)',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    style: TextStyle(color: Colors.white),
                    onTap: _askRating,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    // Ensure rating is selected first
    if (_selectedRating == null) {
      // Prompt for rating again if none selected
      await _askRating();
      if (_selectedRating == null) return;
    }
    final content = _messageController.text.trim();
    if (content.isEmpty) return;
    // Clear the input
    _messageController.clear();
    // Convert rating to double
    final ratingValue = _selectedRating!.toDouble();
    // 1) Post review to backend with rating and content
    await _reviewApi.addReview(widget.movie.id, ratingValue, content);
    // 2) Reload all reviews so UI updates
    await _loadReviews();
  }
  Future<void> _loadReviews() async {
    final List<Review> reviews = await _reviewApi.listReviews(widget.movie.id);
    // Sort reviews: oldest first
    reviews.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    setState(() {
      _messages = reviews.map((r) {
        return {
          'username': r.userName,
          'text': r.content,
          'time': DateFormat('HH:mm').format(r.createdAt),
          'isUser': r.userName == _currentUsername,
        };
      }).toList();
      _loading = false;
    });
  }
}