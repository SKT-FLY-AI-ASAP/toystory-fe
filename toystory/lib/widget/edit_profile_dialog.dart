import 'package:flutter/cupertino.dart';
import 'package:toystory/widget/reusable_dialog.dart';

void showEditProfileDialog(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (context) {
      return ReusableDialog(
        title: '개인 정보 수정',
        content: Column(
          children: [
            const SizedBox(height: 20), // 간격 조절
            _buildLabeledTextField(
              label: '이메일',
              placeholder: '이메일',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20), // 간격 조절
            _buildLabeledTextField(
              label: '비밀번호',
              placeholder: '비밀번호',
              obscureText: true,
            ),
            const SizedBox(height: 20), // 간격 조절
            _buildLabeledTextField(
              label: '비밀번호 확인',
              placeholder: '비밀번호 확인',
              obscureText: true,
            ),
            const SizedBox(height: 20), // 간격 조절
            _buildLabeledTextField(
              label: '닉네임',
              placeholder: '닉네임',
            ),
            const SizedBox(height: 20), // 간격 조절
            _buildLabeledTextField(
              label: '전화번호',
              placeholder: '전화번호',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20), // 간격 조절
            _buildLabeledTextField(
              label: '주소',
              placeholder: '주소',
            ),
            const SizedBox(height: 30), // 계정 삭제와의 간격 더 넓게
            GestureDetector(
              onTap: () {
                _showDeleteAccountDialog(context);
              },
              child: Text(
                '계정 삭제',
                style: TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.destructiveRed,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 30), // 저장 버튼과의 간격 더 넓게
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoButton.filled(
                  onPressed: () {
                    // 저장 로직을 여기에서 처리합니다.
                    print('저장됨');
                    Navigator.pop(context); // 저장 후 다이얼로그 닫기
                  },
                  child: Text('저장'),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildLabeledTextField({
  required String label,
  required String placeholder,
  bool obscureText = false,
  TextInputType keyboardType = TextInputType.text,
}) {
  return Row(
    children: [
      SizedBox(
        width: 100, // 라벨의 고정된 너비
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: CupertinoColors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: CupertinoTextField(
          placeholder: placeholder,
          obscureText: obscureText,
          keyboardType: keyboardType,
        ),
      ),
    ],
  );
}

void _showDeleteAccountDialog(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text('계정 삭제'),
        content: Text('정말로 계정을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              // 여기서 계정 삭제 로직을 처리합니다.
              print('계정 삭제');
            },
            child: Text('삭제'),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('취소'),
          ),
        ],
      );
    },
  );
}
