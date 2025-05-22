import 'package:flutter/material.dart';
import '../widgets/tag_chip.dart';

class TagSettingsScreen extends StatefulWidget {
  @override
  _TagSettingsScreenState createState() => _TagSettingsScreenState();
}

class _TagSettingsScreenState extends State<TagSettingsScreen> {
  final List<String> tags = [
    '액션', '모험', '애니메이션', '코미디', '범죄', '다큐멘터리',
    '드라마', '가족', '판타지', '역사', '공포', '음악', '미스터리',
    '로맨스', 'SF', '스릴러', '전쟁', '서부'
  ];

  List<String> selectedTags = ['액션', '모험', 'SF', '판타지'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('취향 태그 설정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '취향 태그',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
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
                Navigator.pop(context);
              },
              child: Text('저장'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}