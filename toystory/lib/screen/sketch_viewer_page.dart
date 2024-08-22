import 'package:flutter/cupertino.dart';
import 'package:toystory/widget/confirm_3d_dialog.dart';

class SketchViewer extends StatelessWidget {
  final String title;
  final String imageUrl;
  final int imageId;

  // 생성자에서 title, imageUrl, imageId를 매개변수로 받음
  SketchViewer({
    required this.title,
    required this.imageUrl,
    required this.imageId,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(title),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pop(context); // 뒤로 가기
          },
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
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
          child: const Icon(CupertinoIcons.cube),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // 적당한 패딩 설정
        child: Center(
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain, // 이미지 비율 유지
          ),
        ),
      ),
    );
  }
}
