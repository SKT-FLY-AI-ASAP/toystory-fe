import 'package:flutter/cupertino.dart';
import 'package:toystory/widget/confirm_3d_dialog.dart';
import 'package:toystory/services/api_service.dart';

class SketchViewer extends StatelessWidget {
  final String title;
  final String imageUrl;
  final int imageId;

  SketchViewer({
    required this.title,
    required this.imageUrl,
    required this.imageId,
  });

  Future<void> _convertToToy(BuildContext context) async {
    try {
      // 3D 변환 요청 API 호출
      final response =
          await ApiService().createToy(sketch_id: imageId, title: title);

      // API 응답이 성공적일 때
      Navigator.of(context).pop(); // 로딩 다이얼로그 닫기
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text(
              '장난감 만들기 완료',
              style: TextStyle(fontSize: 24, fontFamily: 'cookierun'), // 폰트 변경
            ),
            content: const Text(
              '장난감이 만들어졌어! \n 장난감 상자에서 확인해봐~',
              style: TextStyle(fontSize: 18, fontFamily: 'cookierun'), // 폰트 변경
            ),
            actions: [
              CupertinoDialogAction(
                child: const Text(
                  '확인',
                  style:
                      TextStyle(fontSize: 20, fontFamily: 'cookierun'), // 폰트 변경
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      // 에러 발생 시
      Navigator.of(context).pop(); // 로딩 다이얼로그 닫기
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text(
              '장난감 만들기 실패',
              style: TextStyle(fontSize: 24, fontFamily: 'cookierun'), // 폰트 변경
            ),
            content: const Text(
              '장난감 만들기에 실패했어. \n 다시 시도해봐',
              style: TextStyle(fontSize: 18, fontFamily: 'cookierun'), // 폰트 변경
            ),
            actions: [
              CupertinoDialogAction(
                child: const Text(
                  '확인',
                  style:
                      TextStyle(fontSize: 20, fontFamily: 'cookierun'), // 폰트 변경
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.transparent, // 네비게이션 바 색상
        middle: Text(
          title,
          style: const TextStyle(
            color: CupertinoColors.systemIndigo,
            fontSize: 32, // 제목 텍스트 크기 증가
            fontFamily: 'cookierun', // 폰트 변경
          ),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(
            CupertinoIcons.back,
            color: CupertinoColors.systemIndigo, // 뒤로가기 버튼 색상
            size: 40, // 아이콘 크기 증가
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
                horizontal: 24, // 버튼 패딩 확대
                vertical: 14, // 버튼 패딩 확대
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
                  // 로딩 다이얼로그 표시
                  showCupertinoDialog(
                    context: context,
                    barrierDismissible: false, // 다이얼로그 밖을 클릭해도 닫히지 않게
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: const Text(
                          '3D 변환중',
                          style: TextStyle(
                              fontSize: 24, fontFamily: 'cookierun'), // 폰트 변경
                        ),
                        content: Column(
                          children: const [
                            SizedBox(height: 16),
                            CupertinoActivityIndicator(radius: 20), // 로딩 인디케이터
                            SizedBox(height: 16),
                            Text(
                              '3D 변환 중입니다...',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'cookierun'), // 폰트 변경
                            ),
                          ],
                        ),
                      );
                    },
                  );

                  // API 요청 시작
                  await _convertToToy(context);
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    CupertinoIcons.cube_box,
                    color: CupertinoColors.white,
                    size: 32, // 아이콘 크기 증가
                  ),
                  SizedBox(width: 8),
                  Text(
                    '장난감 만들기',
                    style: TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 32, // 버튼 텍스트 크기 증가
                      fontWeight: FontWeight.bold,
                      fontFamily: 'cookierun', // 폰트 변경
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
