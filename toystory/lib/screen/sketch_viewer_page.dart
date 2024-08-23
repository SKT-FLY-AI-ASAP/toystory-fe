import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toystory/widget/confirm_3d_dialog.dart';

class SketchViewer extends StatelessWidget {
  final String title;
  final String imageUrl;
  final int imageId;

  SketchViewer({
    required this.title,
    required this.imageUrl,
    required this.imageId,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor:
            CupertinoColors.systemIndigo.withOpacity(0.3), // 네비게이션 바 색상 변경
        middle: Text(
          title,
          style: TextStyle(color: CupertinoColors.white), // 텍스트 색상 변경
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(
            CupertinoIcons.back,
            color: CupertinoColors.white, // 뒤로가기 버튼 색상 변경
          ),
          onPressed: () {
            Navigator.pop(context); // 뒤로 가기
          },
        ),
      ),
      child: Stack(
        children: [
          // 메인 컨텐츠 - 이미지 뷰어
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain, // 이미지 비율 유지
              ),
            ),
          ),
          // Floating Button (장난감 변환 버튼)
          Positioned(
            bottom: 30, // 화면 하단에서 30px 떨어지도록 설정
            right: 30, // 화면 우측에서 30px 떨어지도록 설정
            child: CupertinoButton(
              color: CupertinoColors.systemIndigo,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              borderRadius: BorderRadius.circular(30),
              onPressed: () async {
                final result = await showCupertinoDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return const Confirm3DTransformDialog();
                  },
                );

                if (result == true) {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: const Text('3D 변환중'),
                        content: Column(
                          children: [
                            const Text('3D 변환 중입니다...'),
                            const SizedBox(height: 16),
                            Image.asset(
                              'assets/img/loading/3D_loading.png',
                              height: 150,
                              width: 150,
                            ),
                          ],
                        ),
                        actions: [
                          CupertinoDialogAction(
                            child: const Text('확인'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(CupertinoIcons.cube_box, color: CupertinoColors.white),
                  SizedBox(width: 8),
                  Text(
                    '장난감 변환',
                    style: TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
