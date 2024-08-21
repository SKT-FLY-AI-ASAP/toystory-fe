import 'package:flutter/cupertino.dart';
import 'document_page.dart';
import 'three_d_page.dart';
import 'trash_page.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: const Color.fromARGB(18, 54, 23, 206), // 탭 바 배경색
        activeColor: const Color.fromARGB(255, 54, 23, 206), // 활성화된 아이템 색상
        inactiveColor: CupertinoColors.inactiveGray, // 비활성화된 아이템 색상
        border: Border(
          top: BorderSide(
              color: CupertinoColors.systemGrey, width: 0.1), // 탭 바 상단 테두리
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.scribble,
              size: 25.0,
            ),
            label: '스케치북',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.cube,
              size: 25.0,
            ),
            label: '장난감사진',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.speaker_2,
              size: 25.0,
            ),
            label: '주문외우기',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (context) => _buildTabNavigator(const DocumentPage()),
            );
          case 1:
            return CupertinoTabView(
              builder: (context) => _buildTabNavigator(const ThreeDPage()),
            );
          case 2:
            return CupertinoTabView(
              builder: (context) => _buildTabNavigator(TrashPage()),
            );
          default:
            return CupertinoTabView(
              builder: (context) => _buildTabNavigator(const DocumentPage()),
            );
        }
      },
    );
  }

  Widget _buildTabNavigator(Widget childPage) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            CupertinoColors.systemGrey5,
            CupertinoColors.white
          ], // 페이지 배경 그라데이션
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Navigator(
        onGenerateRoute: (settings) {
          return CupertinoPageRoute(builder: (_) => childPage);
        },
      ),
    );
  }
}
