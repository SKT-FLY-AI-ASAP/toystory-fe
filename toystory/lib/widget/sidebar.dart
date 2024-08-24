import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'magic_dialog.dart';
import 'package:toystory/screen/draw_page.dart';
import 'package:toystory/services/api_service.dart';

class Sidebar extends StatefulWidget {
  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  // nickname 변수를 선언
  String nickname = "User"; // 기본 닉네임 설정

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    try {
      final response = await ApiService().fetchUserInfo();
      setState(() {
        nickname = response["data"]["nickname"];
        print(nickname);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.systemIndigo.withOpacity(0.3),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: Center(
              child: SizedBox(
                height: 150,
                child: Image.asset(
                  'assets/logo/toystory_logo2.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Flexible(
            flex: 3,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '안녕, $nickname!',
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .navTitleTextStyle
                        .copyWith(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.white,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '너만의 특별한 세상을 만들어볼래?',
                    style: TextStyle(
                      fontSize: 24,
                      color: CupertinoColors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    '지금 바로 시작해보자!',
                    style: TextStyle(
                      fontSize: 24,
                      color: CupertinoColors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 100),
          Flexible(
            flex: 2,
            child: Center(
              child: Column(
                children: [
                  CupertinoButton(
                    color: CupertinoColors.systemIndigo,
                    onPressed: () {
                      print("주문외우기 버튼이 클릭되었습니다!");
                      showMagicDialog(context);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
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
                  const SizedBox(height: 20),
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
                      children: const [
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
            ),
          ),
        ],
      ),
    );
  }
}
