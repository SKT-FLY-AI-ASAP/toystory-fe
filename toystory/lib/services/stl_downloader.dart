import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class URLLauncher {
  // Safari로 URL 열기 함수
  static Future<void> openURL(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);

    // URL을 열 수 있는지 확인하고 Safari로 열기
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // URL을 열 수 없을 때 에러 다이얼로그 표시
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('에러'),
            content: const Text('URL을 열 수 없습니다.'),
            actions: [
              CupertinoDialogAction(
                child: const Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
              ),
            ],
          );
        },
      );
    }
  }
}

// class STLDownloaderWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return CupertinoPageScaffold(
//       navigationBar: CupertinoNavigationBar(
//         middle: Text('Safari에서 STL 다운로드'),
//       ),
//       child: Center(
//         child: CupertinoButton(
//           child: Text('Safari로 파일 다운로드'),
//           onPressed: () {
//             // Safari로 URL 열기
//             URLLauncher.openURL(
//               context,
//               'https://asap-bucket.s3.ap-northeast-2.amazonaws.com/3d-contents/1-stl/best_bear.stl',
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
