import 'package:flutter/cupertino.dart';
import 'document_page.dart';
import 'three_d_page.dart';
import 'trash_page.dart';

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
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            _showSettingsDialog(context);
          },
          child: Icon(CupertinoIcons.settings),
        ),
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

  void _showSettingsDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("설정"),
          content: Text("설정 메뉴에서 무엇을 하시겠습니까?"),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                print('개인 정보 수정 선택');
              },
              child: Text('개인 정보 수정'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                print('제작 현황 확인 선택');
              },
              child: Text('제작 현황 확인'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                print('배송 상태 확인 선택');
              },
              child: Text('배송 상태 확인'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                print('약관 조회 선택');
              },
              child: Text('약관 조회'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                print('로그아웃 선택');
              },
              isDestructiveAction: true,
              child: Text('로그아웃'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('취소'),
            ),
          ],
        );
      },
    );
  }
}
