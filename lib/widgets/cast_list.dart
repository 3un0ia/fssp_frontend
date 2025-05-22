import 'package:flutter/material.dart';

class CastList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final castMembers = [
      {'name': '톰 홀랜드', 'character': '피터 파커 / 스파이더맨', 'image': 'https://via.placeholder.com/100'},
      {'name': '젠데이아', 'character': 'MJ', 'image': 'https://via.placeholder.com/100'},
      {'name': '베네딕트 컴버배치', 'character': '닥터 스트레인지', 'image': 'https://via.placeholder.com/100'},
      {'name': '제이콥 배덜런', 'character': '네드 리즈', 'image': 'https://via.placeholder.com/100'},
    ];

    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: castMembers.length,
        itemBuilder: (context, index) {
          return Container(
            width: 80,
            margin: EdgeInsets.only(right: 12),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(castMembers[index]['image']!),
                ),
                SizedBox(height: 8),
                Text(
                  castMembers[index]['name']!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  castMembers[index]['character']!,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}