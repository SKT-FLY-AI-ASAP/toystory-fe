import 'package:flutter/cupertino.dart';
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
          title: const Text('오류'), // 폰트 패밀리 제거
          content: const Text('이메일과 비밀번호를 입력해주세요.'), // 폰트 패밀리 제거
          actions: [
            CupertinoDialogAction(
              child: const Text('확인'), // 폰트 패밀리 제거
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
          title: const Text('로그인 실패'), // 폰트 패밀리 제거
          content: Text(e.toString()), // 폰트 패밀리 제거
          actions: [
            CupertinoDialogAction(
              child: const Text('확인'), // 폰트 패밀리 제거
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
      child: Center(
        child: Container(
          width: 540,
          height: 580,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: CupertinoColors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(25, 0, 0, 0),
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
                      'assets/logo/toystory_logo.png',
                      height: 180,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const SizedBox(width: 20),
                    const SizedBox(
                      width: 80,
                      child: Text(
                        '이메일',
                        style: TextStyle(
                          fontSize: 22,
                          color: CupertinoColors.black,
                          fontFamily: 'cookierun',
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
                        style: const TextStyle(fontFamily: 'cookierun'),
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const SizedBox(width: 20),
                    const SizedBox(
                      width: 80,
                      child: Text(
                        '비밀번호',
                        style: TextStyle(
                          fontSize: 22,
                          color: CupertinoColors.black,
                          fontFamily: 'cookierun',
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
                        style: const TextStyle(fontFamily: 'cookierun'),
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
                const SizedBox(height: 40),
                Container(
                  width: 300,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemIndigo,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: CupertinoButton(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: const Text(
                      '로그인',
                      style: TextStyle(
                        color: CupertinoColors.white,
                        fontFamily: 'cookierun',
                        fontSize: 20,
                      ),
                    ),
                    onPressed: handleLogin,
                  ),
                ),
                const SizedBox(height: 10),
                CupertinoButton(
                  child: const Text(
                    '회원가입',
                    style: TextStyle(
                      color: CupertinoColors.black,
                      fontFamily: 'cookierun',
                      fontSize: 20,
                    ),
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
