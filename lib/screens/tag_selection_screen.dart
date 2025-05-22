import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../widgets/tag_chip.dart';

class TagSelectionScreen extends StatefulWidget {
  @override
  _TagSelectionScreenState createState() => _TagSelectionScreenState();
}

class _TagSelectionScreenState extends State<TagSelectionScreen> {
  final List<String> tags = [
    '액션', '모험', '애니메이션', '코미디', '범죄', '다큐멘터리',
    '드라마', '가족', '판타지', '역사', '공포', '음악', '미스터리',
    '로맨스', 'SF', '스릴러', '전쟁', '서부'
  ];

  List<String> selectedTags = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40),
              Text(
                '취향 태그',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '취향에 맞는 영화를 추천해드릴게요.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 24),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: tags.map((tag) {
                    final isSelected = selectedTags.contains(tag);
                    return TagChip(
                      label: tag,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedTags.remove(tag);
                          } else {
                            selectedTags.add(tag);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                        (route) => false,
                  );
                },
                child: Text('완료'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}