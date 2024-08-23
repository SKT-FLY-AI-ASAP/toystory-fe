import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'magic_dialog.dart';
import 'package:toystory/screen/draw_page.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.systemIndigo.withOpacity(0.3),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 로고 이미지 추가
          SizedBox(
            height: 150, // 로고 이미지 크기 조정
            child: Image.asset(
              'assets/logo/toystory_logo2.png', // 로고 이미지 경로
              fit: BoxFit.contain, // 이미지가 부모 위젯 안에 맞게 조정
            ),
          ),
          SizedBox(height: 20),
          Text(
            '안녕하세요!',
            style:
                CupertinoTheme.of(context).textTheme.navTitleTextStyle.copyWith(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.white,
                    ),
          ),
          SizedBox(height: 10),
          Text(
            'Toy Story에 오신 것을',
            style: TextStyle(
              fontSize: 24,
              color: CupertinoColors.white,
            ),
          ),
          SizedBox(height: 5),
          Text(
            '환영합니다',
            style: TextStyle(
              fontSize: 24,
              color: CupertinoColors.white,
            ),
          ),
          SizedBox(height: 20),

          // 남은 공간을 모두 차지해서 버튼을 아래로 밀어내는 역할을 함
          Expanded(child: Container()),

          // 주문외우기 버튼
          CupertinoButton(
            color: CupertinoColors.systemIndigo,
            onPressed: () {
              print("주문외우기 버튼이 클릭되었습니다!");
              showMagicDialog(context);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_fix_high, color: CupertinoColors.white),
                SizedBox(width: 8),
                Text(
                  '주문외우기',
                  style: TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),

          // 그림그리기 버튼
          CupertinoButton(
            color: CupertinoColors.systemIndigo,
            onPressed: () {
              Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute(
                  fullscreenDialog: false,
                  builder: (context) => const DrawPage(),
                ),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.palette, color: CupertinoColors.white),
                SizedBox(width: 8),
                Text(
                  '그림그리기',
                  style: TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
