import 'package:flutter/cupertino.dart';
import 'package:toystory/widget/reusable_dialog.dart';

void showDeliveryDialog(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (context) {
      return ReusableDialog(
        title: '배송 상태 확인',
        content: Text('여기에 배송 상태 확인에 대한 내용이 들어갑니다.'),
      );
    },
  );
}
