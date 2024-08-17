import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpPage> {
  bool agreeToTerms = false; // 약관 동의 상태 변수
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController =
      TextEditingController(); // 주소 컨트롤러 추가

  bool passwordsMatch = true; // 비밀번호 일치 여부 상태 변수
  bool allFieldsFilled = false; // 모든 필드가 입력되었는지 확인하는 변수

  // 입력 필드의 상태를 확인하는 함수
  void checkFields() {
    setState(() {
      passwordsMatch =
          passwordController.text == confirmPasswordController.text;
      allFieldsFilled = emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty &&
          nicknameController.text.isNotEmpty &&
          phoneNumberController.text.isNotEmpty &&
          addressController.text.isNotEmpty; // 주소도 비어있지 않도록 추가
    });
  }

  // 재사용 가능한 Row 생성 함수
  Widget buildInputRow({
    required String labelText,
    required String placeholder,
    bool isPassword = false,
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.text,
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
          ),
        ),
        const SizedBox(width: 20),
      ],
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
                  height: 30, // Row의 높이를 30으로 고정
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

                // 재사용 가능한 input row 함수 사용
                buildInputRow(
                  labelText: '이메일',
                  placeholder: '이메일',
                  controller: emailController,
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

                // 비밀번호가 일치하지 않으면 경고 메시지 표시
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
                ),
                const SizedBox(height: 20),
                buildInputRow(
                  labelText: '주소',
                  placeholder: '주소',
                  controller: addressController, // 주소 필드 추가
                ),
                const SizedBox(height: 20),
                buildInputRow(
                  labelText: '전화번호',
                  placeholder: '전화번호',
                  keyboardType: TextInputType.phone,
                  controller: phoneNumberController,
                ),
                const SizedBox(height: 20),

                // 약관 동의 스위치
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

                // 회원가입 버튼
                CupertinoButton.filled(
                  child: const Text('회원가입'),
                  onPressed: agreeToTerms && passwordsMatch && allFieldsFilled
                      ? () {
                          // 회원가입 처리
                        }
                      : null, // 약관 동의 및 필드가 비어있거나 비밀번호 일치하지 않으면 버튼 비활성화
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
