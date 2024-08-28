import 'package:flutter/cupertino.dart';
import 'screen/loading_page.dart';

void main() {
  runApp(CupertinoApp(
    debugShowCheckedModeBanner: false,
    theme: CupertinoThemeData(
      primaryColor: CupertinoColors.systemIndigo, // 전체 primary 색상을 indigo로 설정
      barBackgroundColor: CupertinoColors.systemIndigo, // 네비게이션 바 등 바 색상
      scaffoldBackgroundColor: CupertinoColors.white, // 기본 배경색
      textTheme: CupertinoTextThemeData(
        primaryColor: CupertinoColors.systemIndigo, // 텍스트 기본 색상 설정
        navTitleTextStyle: TextStyle(
          color: CupertinoColors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    home: LoadingPage(),
  ));
}
