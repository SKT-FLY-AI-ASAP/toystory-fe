import 'package:flutter/cupertino.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:toystory/widget/download_stl_dialog.dart';
import 'package:toystory/services/stl_downloader.dart'; // URLLauncher 클래스를 import

class My3DModel extends StatelessWidget {
  const My3DModel({super.key});

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
          onTap: () async {
            // Show the confirm dialog on cube button press
            final result = await showCupertinoDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return const DownloadSTLDialog(); // 다운로드 확인을 위한 커스텀 다이얼로그
              },
            );

            if (result == true) {
              // 다운로드가 확인되었을 때 Safari로 STL 파일 다운로드 시작
              const String fileUrl =
                  'https://asap-bucket.s3.ap-northeast-2.amazonaws.com/3d-contents/1-stl/best_bear.stl';
              await URLLauncher.openURL(
                  context, fileUrl); // Safari로 파일 다운로드 URL 열기
            }
          },
          child: Icon(CupertinoIcons.share),
        ),
      ),
      child: const ModelViewer(
        backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
        src:
            'https://asap-bucket.s3.ap-northeast-2.amazonaws.com/3d-contents/0-glb/tmp7flcqo65.glb',
        alt: 'A 3D model of a white bear',
        ar: true,
        autoRotate: true,
        iosSrc: 'https://modelviewer.dev/shared-assets/models/Astronaut.usdz',
        disableZoom: false,
      ),
    );
  }
}
