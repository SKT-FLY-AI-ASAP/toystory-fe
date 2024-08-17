import 'package:flutter/material.dart';

class ReusableDialog extends StatelessWidget {
  final String title;
  final Widget content;

  const ReusableDialog({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13.0), // 다이얼로그 모서리 둥글게 설정
      ),
      backgroundColor: Colors.white, // 배경색을 white로 설정
      child: Stack(
        children: [
          Container(
            width: 540, // 다이얼로그 너비 지정
            height: 620, // 다이얼로그 높이 지정
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SF Pro Display', // 폰트 지정
                  ),
                ),
                const Divider(
                  thickness: 1.0,
                  color: Color.fromRGBO(200, 200, 200, 0.6),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        fontFamily: 'SF Pro Display', // 모든 텍스트에 적용할 폰트 지정
                      ),
                      child: content,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 오른쪽 상단에 닫기 버튼 추가
          Positioned(
            right: 10,
            top: 10,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Icon(
                Icons.close,
                color: Colors.black,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
