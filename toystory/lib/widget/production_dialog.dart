import 'package:flutter/cupertino.dart';
import 'package:toystory/widget/reusable_dialog.dart';

void showProductionDialog(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (context) {
      return ReusableDialog(
        title: '제작 현황 확인',
        content: Text('여기에 제작 현황 확인에 대한 내용이 들어갑니다.'),
      );
    },
  );
}
