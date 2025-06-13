import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/tag_chip.dart';
import '../providers/auth_provider.dart';

class GenreSelectionScreen extends StatefulWidget {
  @override
  _GenreSelectionScreenState createState() => _GenreSelectionScreenState();
}

class _GenreSelectionScreenState extends State<GenreSelectionScreen> {
  final Set<int> _selected = {};
  final List<Map<String, dynamic>> selectedTags = [
    {'id': 28, 'name': 'Action'},
    {'id': 12, 'name': 'Adventure'},
    {'id': 16, 'name': 'Animation'},
    {'id': 35, 'name': 'Comedy'},
    {'id': 80, 'name': 'Crime'},
    {'id': 99, 'name': 'Documentary'},
    {'id': 18, 'name': 'Drama'},
    {'id': 10751, 'name': 'Family'},
    {'id': 14, 'name': 'Fantasy'},
    {'id': 36, 'name': 'History'},
    {'id': 27, 'name': 'Horror'},
    {'id': 10402, 'name': 'Music'},
    {'id': 9648, 'name': 'Mystery'},
    {'id': 10749, 'name': 'Romance'},
    {'id': 878, 'name': 'Science Fiction'},
    {'id': 53, 'name': 'Thriller'},
    {'id': 10752, 'name': 'War'},
    {'id': 37, 'name': 'Western'},
  ];

  final List<Map<String, dynamic>> tags = [
    {'id': 28, 'name': 'Action'},
    {'id': 12, 'name': 'Adventure'},
    {'id': 16, 'name': 'Animation'},
    {'id': 35, 'name': 'Comedy'},
    {'id': 80, 'name': 'Crime'},
    {'id': 99, 'name': 'Documentary'},
    {'id': 18, 'name': 'Drama'},
    {'id': 10751, 'name': 'Family'},
    {'id': 14, 'name': 'Fantasy'},
    {'id': 36, 'name': 'History'},
    {'id': 27, 'name': 'Horror'},
    {'id': 10402, 'name': 'Music'},
    {'id': 9648, 'name': 'Mystery'},
    {'id': 10749, 'name': 'Romance'},
    {'id': 878, 'name': 'Science Fiction'},
    {'id': 53, 'name': 'Thriller'},
    {'id': 10752, 'name': 'War'},
    {'id': 37, 'name': 'Western'},
  ];

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
                    final isSelected = _selected.contains(tag['id']);
                    return TagChip(
                      label: tag['name'],
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selected.remove(tag['id']);
                          } else {
                            _selected.add(tag['id']);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF162D3A), // Fill color
                  side: BorderSide(color: Color(0xFF0296E5)), // Stroke color
                ),
                onPressed: _selected.isNotEmpty
                    ? () {
                        authProv.completeSignup(
                          context: context,
                          genreIds: _selected.toList(),
                        );
                      }
                    : null,
                child: Text(
                  '회원가입 완료',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}