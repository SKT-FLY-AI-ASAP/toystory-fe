import 'package:flutter/cupertino.dart';
import 'document_page.dart';
import 'three_d_page.dart';
import 'trash_page.dart';
import 'package:toystory/widget/settings_button.dart'; // 새로 만든 위젯을 import

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    DocumentPage(),
    ThreeDPage(),
    TrashPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: SettingsButton(), // 새로 만든 SettingsButton 위젯을 사용
      ),
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.scribble),
              label: '문서',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.cube),
              label: '3D',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.trash),
              label: '휴지통',
            ),
          ],
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        tabBuilder: (context, index) {
          return CupertinoTabView(
            builder: (context) {
              return _pages[index]; // 페이지 전환
            },
          );
        },
      ),
    );
  }
}
