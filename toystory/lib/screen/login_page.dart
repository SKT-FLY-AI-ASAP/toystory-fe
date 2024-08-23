import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'signup_page.dart';
import 'home_page.dart';
import 'package:toystory/services/api_service.dart';

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
          builder: (context) => HomePage(),
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
      // 배경 이미지를 추가하는 부분
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 배경 이미지
          // Image.asset(
          //   'assets/img/design/toystroy_bg2.jpg', // 배경 이미지 경로
          //   fit: BoxFit.cover, // 이미지를 전체 화면에 맞춤
          // ),
          // Foreground content
          Center(
            child: Container(
              width: 540,
              height: 580,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: CupertinoColors.white.withOpacity(0.8), // 반투명 배경색
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
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 180,
                      child: Center(
                        child: Image.asset(
                          'assets/logo/toystory_logo.png', // 로고 이미지 경로
                          height: 180, // 이미지 크기 조정
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // 이메일 입력 필드
                    Row(
                      children: [
                        SizedBox(width: 20),
                        const SizedBox(
                          width: 80, // 고정된 너비
                          child: Text(
                            '이메일',
                            style: TextStyle(
                              fontSize: 16,
                              color: CupertinoColors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
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
                    // 비밀번호 입력 필드
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
                        const SizedBox(width: 10),
                        Expanded(
                          child: CupertinoTextField(
                            controller: _passwordController,
                            placeholder: 'PW',
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 10),
                            obscureText: true,
                            onSubmitted: (_) => handleLogin(),
                          ),
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                    const SizedBox(height: 40),
                    // 로그인 버튼
                    Container(
                      width: 300,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 54, 23, 206),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: CupertinoButton(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: const Text(
                          '로그인',
                          style: TextStyle(
                            color: CupertinoColors.white,
                          ),
                        ),
                        onPressed: handleLogin,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // 회원가입 버튼
                    CupertinoButton(
                      child: const Text(
                        '회원가입',
                        style: TextStyle(color: CupertinoColors.black),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const SignUpPage(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
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
        ],
      ),
    );
  }
}
