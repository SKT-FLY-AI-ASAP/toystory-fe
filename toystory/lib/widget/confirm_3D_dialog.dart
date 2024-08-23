import 'package:flutter/cupertino.dart';

class Confirm3DTransformDialog extends StatelessWidget {
  const Confirm3DTransformDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('장난감으로 만드시겠습니까?'),
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
