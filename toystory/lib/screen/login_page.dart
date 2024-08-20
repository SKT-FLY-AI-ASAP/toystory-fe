import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'signup_page.dart';
import 'root_page.dart';
import 'package:toystory/services/api_service.dart'; // Make sure to import your ApiService

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  Future<void> handleLogin() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('오류'),
          content: const Text('이메일과 비밀번호를 입력해주세요.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
      return;
    }

    try {
      await _apiService.login(email: email, password: password);
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => RootPage(),
        ),
      );
    } catch (e) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('로그인 실패'),
          content: Text(e.toString()),
          actions: [
            CupertinoDialogAction(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      child: Center(
        child: Container(
          width: 540,
          height: 580,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: CupertinoColors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 30,
                  child: Center(
                    child: Text(
                      '로그인',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(
                  thickness: 1.0,
                  color: Color.fromRGBO(200, 200, 200, 0.6),
                ),
                const SizedBox(height: 30),
                const Text(
                  'ToyStory',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 50),

                // Row with Text and TextField for E-mail
                Row(
                  children: [
                    SizedBox(width: 20),
                    const SizedBox(
                      width: 80, // 고정된 너비
                      child: Text(
                        '아이디',
                        style: TextStyle(
                          fontSize: 16,
                          color: CupertinoColors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10), // 간격
                    Expanded(
                      child: CupertinoTextField(
                        controller: _emailController,
                        placeholder: 'E-mail',
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 10),
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
                const SizedBox(height: 20),

                // Row with Text and TextField for PW
                Row(
                  children: [
                    SizedBox(width: 20),
                    const SizedBox(
                      width: 80, // 고정된 너비
                      child: Text(
                        '비밀번호',
                        style: TextStyle(
                          fontSize: 16,
                          color: CupertinoColors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10), // 간격
                    Expanded(
                      child: CupertinoTextField(
                        controller: _passwordController,
                        placeholder: 'PW',
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 10),
                        obscureText: true,
                        onSubmitted: (_) =>
                            handleLogin(), // Trigger login on Enter key press
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
                const SizedBox(height: 40),

                Container(
                  width: 300, // 버튼의 너비 설정
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBlue, // 배경 색상
                    borderRadius: BorderRadius.circular(30), // 모서리를 둥글게
                  ),
                  child: CupertinoButton(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0), // 패딩을 통해 높이 조정
                    child: const Text(
                      '로그인',
                      style: TextStyle(
                        color: CupertinoColors.white, // 텍스트 색상
                      ),
                    ),
                    onPressed: handleLogin,
                  ),
                ),
                const SizedBox(height: 10),
                CupertinoButton(
                  child: const Text(
                    '회원가입',
                    style: TextStyle(color: CupertinoColors.black),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const SignUpPage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = 0.0;
                          const end = 1.0;
                          const curve = Curves.ease;

                          final tween = Tween(begin: begin, end: end);
                          final curvedAnimation = CurvedAnimation(
                            parent: animation,
                            curve: curve,
                          );

                          return FadeTransition(
                            opacity: tween.animate(curvedAnimation),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
