import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../widgets/chat_message.dart';

class ChatScreen extends StatefulWidget {
  final Movie movie;

  const ChatScreen({Key? key, required this.movie}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': '스파이더맨: 노 웨이 홈에 대해 어떻게 생각하세요?',
      'isUser': false,
      'time': '오후 3:45',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.movie.posterUrl),
              radius: 16,
            ),
            SizedBox(width: 8),
            Text(widget.movie.title),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChatMessage(
                  text: _messages[index]['text'],
                  isUser: _messages[index]['isUser'],
                  time: _messages[index]['time'],
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
                    decoration: InputDecoration(
                      hintText: '메시지를 입력하세요...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.white),
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

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({
          'text': _messageController.text,
          'isUser': true,
          'time': '지금',
        });

        // Simulate a response
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            _messages.add({
              'text': '흥미로운 의견이네요! 더 자세히 말씀해주실래요?',
              'isUser': false,
              'time': '지금',
            });
          });
        });
      });
      _messageController.clear();
    }
  }
}