import 'package:flutter/cupertino.dart';
import 'login_page.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    // 5초 후에 다음 페이지로 이동
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
            builder: (context) => const LoginPage()), // 다음 페이지로 이동
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white, // 배경 색상을 하얀색으로 설정
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
          children: const [
            Text(
              'ToyStory',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.black,
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(height: 20), // 글씨와 로딩 아이콘 사이 간격
            CupertinoActivityIndicator(
              radius: 15, // 로딩 아이콘 크기 조절
            ),
          ],
        ),
      ),
    );
  }
}