import 'package:flutter/cupertino.dart';
import 'package:toystory/widget/reusable_dialog.dart';

void showMagicDialog(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (context) {
      return ReusableDialog(
        title: 'STT',
        content: Text('여기에 약관 조회에 대한 내용이 들어갑니다.'),
      );
    },
  );
}