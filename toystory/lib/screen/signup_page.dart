import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
//import 'package:toystory/services/api_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpPage> {
  bool agreeToTerms = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool passwordsMatch = true;
  bool allFieldsFilled = false;
  final Dio _dio = Dio(); // Dio 인스턴스 생성

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

  Future<void> checkEmailVerificationStatus() async {
    final String email = emailController.text;

    if (!isEmailValid(email)) {
      showErrorDialog('유효한 이메일 형식이 아닙니다.');
      return;
    }

    final String url = 'http://52.79.56.132:8080/api/v1/user/email';

    try {
      final response = await _dio.get(url, queryParameters: {'email': email});

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['message'] == "Verified.") {
          // 이메일 인증이 완료된 경우 회원가입 처리
          print('Email verified. Proceeding with sign up...');
          handleSignUp();
        } else {
          showErrorDialog('이메일 인증이 완료되지 않았습니다. 이메일을 확인해 주세요.');
        }
      } else {
        showErrorDialog('이메일 인증 상태 확인에 실패했습니다. 다시 시도해 주세요.');
        print(response.statusCode);
        print(email);
      }
    } catch (e) {
      print(e);
      showErrorDialog('네트워크 오류가 발생했습니다. 다시 시도해 주세요.');
    }
  }

  Future<void> sendVerificationLink() async {
    final String url = 'http://52.79.56.132:8080/api/v1/user/link';

    try {
      final response = await _dio.post(
        url,
        data: {'email': emailController.text},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 201) {
        final responseData = response.data;
        print(responseData);
        showEmailVerificationDialog(context);
      } else {
        showErrorDialog('Failed to send email. Please try again.');
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
      showErrorDialog('네트워크 오류가 발생했습니다. 다시 시도해 주세요.');
    }
  }

  void handleSignUp() {
    // 실제 회원가입 처리 로직을 여기에 추가
    print('회원가입을 처리합니다.');
  }

  void showEmailVerificationDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text("이메일 인증"),
          content: const Text("이메일 수신함을 확인하세요."),
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
                    children: [
                      Expanded(
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
                      // 닉네임 중복 확인 로직 추가
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
                          checkEmailVerificationStatus();
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
