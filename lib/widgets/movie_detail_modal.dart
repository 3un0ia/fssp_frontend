import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieDetailModal extends StatefulWidget {
  final Movie movie;

  const MovieDetailModal({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  State<MovieDetailModal> createState() => _MovieDetailModalState();
}

class _MovieDetailModalState extends State<MovieDetailModal> {
  bool _isLiked = false;
  int _userRating = 0;

  // 영화 상세 정보 (실제로는 API에서 가져올 정보)
  late final Map<String, dynamic> _movieDetails;

  @override
  void initState() {
    super.initState();

    // 영화 상세 정보 초기화
    _movieDetails = {
      'description': "우주 탐사를 통해 인류의 새로운 거주지를 찾아내려는 사람들의 모험을 그린 작품입니다. 시간, 중력, 사랑에 대한 깊은 탐구를 담고 있습니다.",
      'director': widget.movie.director ?? "크리스토퍼 놀란",
      'cast': ["매튜 맥커너히", "앤 해서웨이", "제시카 차스테인", "마이클 케인"],
      'runtime': "2시간 49분",
      'genres': ["SF", "드라마", "모험"],
      'reviews': [
        {
          'id': 1,
          'user': "영화광",
          'rating': 5.0,
          'comment': "최고의 SF 영화! 시간이 가는 줄 모르고 봤습니다."
        },
        {
          'id': 2,
          'user': "우주덕후",
          'rating': 4.0,
          'comment': "과학적 고증과 감동이 함께 있는 영화입니다."
        },
        {
          'id': 3,
          'user': "시네필",
          'rating': 5.0,
          'comment': "놀란 감독의 역작. 여러 번 봐도 새로운 느낌을 주는 영화입니다."
        },
      ]
    };
  }

  void _handleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  void _handleRating(int rating) {
    setState(() {
      _userRating = rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // 영화 포스터 및 기본 정보
          Stack(
            children: [
              // 포스터 이미지
              Container(
                height: 240,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  image: DecorationImage(
                    image: NetworkImage('https://via.placeholder.com/600x400'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // 그라데이션 오버레이
              Container(
                height: 240,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      const Color(0xFF0F172A),
                    ],
                  ),
                ),
              ),
              // 닫기 버튼
              Positioned(
                top: 16,
                right: 16,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 24),
                  ),
                ),
              ),
              // 영화 정보
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.movie.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.movie.year} · ${_movieDetails['runtime']}',
                      style: const TextStyle(
                        color: Color(0xFFCBD5E1),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              // 재생 버튼
              Positioned(
                bottom: 16,
                right: 16,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF3B82F6),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.play_arrow,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),

          // 영화 상세 정보 (스크롤 가능)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 평점 및 액션 버튼
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 평점
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            widget.movie.rating.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Text(
                            '/5',
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      // 액션 버튼
                      Row(
                        children: [
                          // 좋아요 버튼
                          Column(
                            children: [
                              IconButton(
                                onPressed: _handleLike,
                                icon: Icon(
                                  _isLiked ? Icons.favorite : Icons.favorite_border,
                                  color: _isLiked ? Colors.red : const Color(0xFF94A3B8),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '좋아요',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          // 리뷰 버튼
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.chat_bubble_outline,
                                  color: Color(0xFF94A3B8),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '리뷰',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          // 공유 버튼
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.share_outlined,
                                  color: Color(0xFF94A3B8),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '공유',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 장르
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (_movieDetails['genres'] as List<String>).map((genre) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          genre,
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // 줄거리
                  const Text(
                    '줄거리',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _movieDetails['description'] as String,
                    style: const TextStyle(
                      color: Color(0xFFCBD5E1),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 감독 및 출연진
                  const Text(
                    '감독 및 출연진',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 14),
                      children: [
                        const TextSpan(
                          text: '감독: ',
                          style: TextStyle(color: Color(0xFF94A3B8)),
                        ),
                        TextSpan(
                          text: _movieDetails['director'] as String,
                          style: const TextStyle(color: Color(0xFFCBD5E1)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 14),
                      children: [
                        const TextSpan(
                          text: '출연: ',
                          style: TextStyle(color: Color(0xFF94A3B8)),
                        ),
                        TextSpan(
                          text: (_movieDetails['cast'] as List<String>).join(', '),
                          style: const TextStyle(color: Color(0xFFCBD5E1)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 사용자 평점
                  const Text(
                    '평점 남기기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(5, (index) {
                      final rating = index + 1;
                      return GestureDetector(
                        onTap: () => _handleRating(rating),
                        child: Container(
                          width: 36,
                          height: 36,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: _userRating >= rating
                                ? Colors.amber
                                : const Color(0xFF1E293B),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            rating.toString(),
                            style: TextStyle(
                              color: _userRating >= rating
                                  ? Colors.black
                                  : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),

                  // 리뷰
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '리뷰',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('모두 보기'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: (_movieDetails['reviews'] as List).map((review) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  review['user'] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      (review['rating'] as double).toString(),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              review['comment'] as String,
                              style: const TextStyle(
                                color: Color(0xFFCBD5E1),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          // 하단 버튼
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade800,
                  width: 1,
                ),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '리뷰 작성하기',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

