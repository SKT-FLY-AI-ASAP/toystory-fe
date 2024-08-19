import 'package:flutter/cupertino.dart';
import 'document_page.dart';
import 'three_d_page.dart';
import 'trash_page.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
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
    return Navigator(
      onGenerateRoute: (settings) {
        return CupertinoPageRoute(builder: (_) => childPage);
      },
    );
  }
}
