import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toystory/services/api_service.dart';
import 'package:toystory/screen/login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpPage> {
  bool agreeToTerms = false; // 약관 동의 확인 변수
  bool isEmailVerified = false; // 이메일 인증 확인 변수
  bool isNicknameChecked = false; // 닉네임 중복확인 완료 확인 변수

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool passwordsMatch = true;
  bool allFieldsFilled = false;
  final ApiService _apiService = ApiService();

  void checkFields() {
    setState(() {
      passwordsMatch =
          passwordController.text == confirmPasswordController.text;
      allFieldsFilled = emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty &&
          nicknameController.text.isNotEmpty &&
          phoneNumberController.text.isNotEmpty &&
          addressController.text.isNotEmpty;
    });
  }

  bool isEmailValid(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

//이메일 인증링크 전송
  Future<void> sendVerificationLink() async {
    final String email = emailController.text;

    if (email.isEmpty) {
      showErrorDialog('이메일을 입력해주세요.');
      return;
    }

    if (!isEmailValid(email)) {
      showErrorDialog('유효한 이메일 형식이 아닙니다.');
      return;
    }

    try {
      await _apiService.sendVerificationLink(email);
      showSuccessDialog('이메일 인증 링크가 전송되었습니다.');
    } catch (e) {
      showErrorDialog(e.toString());
    }
  }

  //닉네임 중복 확인 for USER
  Future<void> checkNicknameAvailability() async {
    final String nickname = nicknameController.text;

    if (nickname.isEmpty) {
      showErrorDialog('닉네임을 입력해주세요.');
      return;
    }

    if (nickname.length >= 9) {
      showErrorDialog('닉네임이 너무 깁니다.');
      return;
    }

    try {
      await _apiService.checkNicknameAvailability(nickname);
      setState(() {
        isNicknameChecked = true;
      });
      showSuccessDialog('닉네임 사용이 가능합니다.');
    } catch (e) {
      showErrorDialog(e.toString());
    }
  }

  //닉네임 중복 확인 for SIGNUP
  Future<void> checkNicknameAvailability2() async {
    final String nickname = nicknameController.text;

    try {
      await _apiService.checkNicknameAvailability(nickname);
      setState(() {
        isNicknameChecked = true;
      });
    } catch (e) {
      print(e);
    }
  }

//이메일 인증 확인
  Future<void> checkEmailVerificationStatus() async {
    final String email = emailController.text;

    try {
      await _apiService.checkEmailVerificationStatus(email);
      setState(() {
        isEmailVerified = true;
      });
      print('이메일 인증이 완료되었습니다');
    } catch (e) {
      print(e);
    }
  }

//회원가입
  Future<void> handleSignUp() async {
    final String email = emailController.text;

    checkEmailVerificationStatus();

    if (!isEmailVerified) {
      showErrorDialog('이메일 인증이 완료되지 않았습니다. 이메일을 확인해 주세요.');
      return;
    }

    checkNicknameAvailability2();

    if (!isNicknameChecked) {
      showErrorDialog('닉네임 중복확인이 완료되지 않았습니다.');
      return;
    }

    final String password = passwordController.text;
    final String nickname = nicknameController.text;
    final String phone = phoneNumberController.text;
    final String address = addressController.text;

    try {
      // 회원가입 요청
      await _apiService.signup(
        email: email,
        password: password,
        nickname: nickname,
        phone: phone,
        address: address,
      );
      showSuccessDialog('회원가입이 완료되었습니다.');
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    } catch (e) {
      showErrorDialog(e.toString());
    }
  }

  void showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기
              },
              child: const Text("확인"),
            ),
          ],
        );
      },
    );
  }

  void showSuccessDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text("Success"),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기
              },
              child: const Text("확인"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Container(
          width: 540,
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
                SizedBox(
                  height: 30,
                  child: Row(
                    //네비게이션 바
                    children: [
                      Expanded(
                        //뒤로가기 버튼
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              CupertinoIcons.back,
                              color: CupertinoColors.activeBlue,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: const Text(
                            '회원가입',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: CupertinoColors.black,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                      const Expanded(
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(
                  thickness: 1.0,
                  color: Color.fromRGBO(200, 200, 200, 0.6),
                ),
                const SizedBox(height: 20),
                buildInputRow(
                  labelText: '이메일',
                  placeholder: '이메일',
                  controller: emailController,
                  suffix: CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    onPressed: () {
                      sendVerificationLink();
                    },
                    child: const Text(
                      '인증',
                      style: TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.activeBlue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                buildInputRow(
                  labelText: '비밀번호',
                  placeholder: '비밀번호',
                  isPassword: true,
                  controller: passwordController,
                ),
                const SizedBox(height: 20),
                buildInputRow(
                  labelText: '비밀번호 확인',
                  placeholder: '비밀번호 확인',
                  isPassword: true,
                  controller: confirmPasswordController,
                ),
                const SizedBox(height: 10),
                if (!passwordsMatch)
                  const Text(
                    '비밀번호가 같지 않습니다',
                    style: TextStyle(
                      color: CupertinoColors.systemRed,
                      fontSize: 12,
                    ),
                  ),
                const SizedBox(height: 10),
                buildInputRow(
                  labelText: '닉네임',
                  placeholder: '닉네임',
                  controller: nicknameController,
                  suffix: CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    onPressed: () {
                      checkNicknameAvailability(); // 중복확인 기능 실행
                    },
                    child: const Text(
                      '중복확인',
                      style: TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.activeBlue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                buildInputRow(
                  labelText: '주소',
                  placeholder: '주소',
                  controller: addressController,
                ),
                const SizedBox(height: 20),
                buildInputRow(
                  labelText: '전화번호',
                  placeholder: '전화번호',
                  keyboardType: TextInputType.phone,
                  controller: phoneNumberController,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const SizedBox(width: 20),
                    CupertinoSwitch(
                      value: agreeToTerms,
                      onChanged: (bool value) {
                        setState(() {
                          agreeToTerms = value;
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      '약관 동의 및 확인',
                      style: TextStyle(
                        fontSize: 16,
                        color: CupertinoColors.systemGrey,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
                const SizedBox(height: 20),
                CupertinoButton.filled(
                  child: const Text('회원가입'),
                  onPressed: agreeToTerms && passwordsMatch && allFieldsFilled
                      ? () {
                          handleSignUp();
                        }
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//이건 그냥 디자인용 함수
  Widget buildInputRow({
    required String labelText,
    required String placeholder,
    bool isPassword = false,
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffix,
  }) {
    return Row(
      children: [
        const SizedBox(width: 20),
        SizedBox(
          width: 120,
          child: Text(
            labelText,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CupertinoTextField(
            controller: controller,
            placeholder: placeholder,
            obscureText: isPassword,
            keyboardType: keyboardType,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
            onChanged: (value) {
              checkFields();
            },
            suffix: suffix,
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}
