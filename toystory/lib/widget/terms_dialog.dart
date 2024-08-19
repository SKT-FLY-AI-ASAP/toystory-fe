import 'package:flutter/cupertino.dart';
import 'package:toystory/widget/reusable_dialog.dart';

void showTermsDialog(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (context) {
      return ReusableDialog(
        title: '약관 조회',
        content: Text('여기에 약관 조회에 대한 내용이 들어갑니다.'),
      );
    },
  );
}
