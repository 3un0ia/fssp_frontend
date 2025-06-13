import 'package:flutter/material.dart';

class CastList extends StatelessWidget {
  final List<String> cast;
  const CastList(this.cast, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cast.length,
        itemBuilder: (context, index) {
          final actorName = cast[index];
          return Container(
            width: 80,
            margin: EdgeInsets.only(right: 12),
            child: Column(
              children: [
                // 배우 이름 첫 글자를 원 안에 표시
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[800],
                  child: Text(
                    actorName.isNotEmpty ? actorName[0] : '',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  actorName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // 캐릭터 정보가 없으므로 배우 이름 아래에는 공백 혹은 생략
                SizedBox(height: 4),
                Text(
                  '',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}