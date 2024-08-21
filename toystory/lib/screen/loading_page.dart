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

    // 6.7초 후에 다음 페이지로 이동
    Future.delayed(const Duration(seconds: 6, milliseconds: 700), () {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => const LoginPage(), // 다음 페이지로 이동
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Image.asset(
          'assets/img/design/toystory_loading.gif', // GIF 파일 경로
          fit: BoxFit.cover, // 이미지가 화면 전체를 채우도록 설정
          width: double.infinity, // 너비를 화면 전체로 설정
          height: double.infinity, // 높이를 화면 전체로 설정
        ),
      ),
    );
  }
}
