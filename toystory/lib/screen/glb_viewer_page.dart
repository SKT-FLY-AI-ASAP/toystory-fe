import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:toystory/widget/sending_3D_dialog.dart';
import 'package:flutter/cupertino.dart';

class My3DModel extends StatelessWidget {
  const My3DModel({super.key});

  void _sendTo3DPrinter(BuildContext context) {
    // Show the sending 3D dialog when the share icon is clicked
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return const Sending3DDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('3D Model Viewer'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(CupertinoIcons.back),
        ),
        trailing: GestureDetector(
          // onTap: () {
          //   _sendTo3DPrinter(context);
          // },
          onTap: () async {
            // Show the confirm dialog on cube button press
            final result = await showCupertinoDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return const Sending3DDialog(); // Your custom dialog
              },
            );

            if (result == true) {
              showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: const Text('3D 프린터 전송중'),
                    content: Column(
                      children: [
                        const Text('3D 프린터로 전송중입니다...'),
                        // const SizedBox(height: 16), // 간격 추가
                        // Image.asset(
                        //   'assets/img/loading/3D_loading.png', // 로컬 이미지 경로
                        //   height: 150, // 이미지 크기
                        //   width: 150,
                        // ),
                      ],
                    ),
                    actions: [
                      CupertinoDialogAction(
                        child: const Text('확인'),
                        onPressed: () {
                          Navigator.of(context).pop(); // 확인 버튼 누를 시 다이얼로그 닫기
                        },
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: Icon(CupertinoIcons.share),
        ),
      ),
      child: const ModelViewer(
        backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
        src: 'assets/glb/white_bear.glb',
        alt: 'A 3D model of a white bear',
        ar: true,
        autoRotate: true,
        iosSrc: 'https://modelviewer.dev/shared-assets/models/Astronaut.usdz',
        disableZoom: true,
      ),
    );
  }
}
