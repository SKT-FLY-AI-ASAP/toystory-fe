import 'package:flutter/cupertino.dart';
import 'document_page.dart';
import 'three_d_page.dart';
import 'trash_page.dart';
import 'package:toystory/widget/reusable_dialog.dart';
import 'package:toystory/widget/edit_profile_dialog.dart'; // 새 파일 import

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
                showEditProfileDialog(context); // 분리된 함수 호출
              },
              child: Text('개인 정보 수정'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                _showReusableDialog(
                    context, "제작 현황 확인", "여기에 제작 현황 확인에 대한 내용이 들어갑니다.");
              },
              child: Text('제작 현황 확인'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                _showReusableDialog(
                    context, "배송 상태 확인", "여기에 배송 상태 확인에 대한 내용이 들어갑니다.");
              },
              child: Text('배송 상태 확인'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                _showReusableDialog(
                    context, "약관 조회", "여기에 약관 조회에 대한 내용이 들어갑니다.");
              },
              child: Text('약관 조회'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                _showLogoutActionSheet(context);
              },
              isDestructiveAction: true,
              child: Text('로그아웃'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  void _showReusableDialog(BuildContext context, String title, String content) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return ReusableDialog(
          title: title,
          content: Text(content),
        );
      },
    );
  }

  void _showLogoutActionSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('로그아웃'),
        message: const Text('로그아웃 시 초기화면으로 돌아갑니다.'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('로그아웃'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('취소'),
        ),
      ),
    );
  }
}
