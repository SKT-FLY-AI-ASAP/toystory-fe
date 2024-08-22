import 'package:flutter/cupertino.dart';

class DownloadSTLDialog extends StatelessWidget {
  const DownloadSTLDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('3D 프린터용 파일을 다운로드 하시겠습니까?'),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.of(context).pop(true); // "예" 선택 시 true 반환
          },
          child: const Text('예'),
        ),
        CupertinoDialogAction(
          onPressed: () {
            Navigator.of(context).pop(false); // "아니요" 선택 시 false 반환
          },
          child: const Text('아니요'),
        ),
      ],
    );
  }
}
