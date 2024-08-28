import 'package:flutter/cupertino.dart';
import 'package:toystory/widget/reusable_dialog.dart';

void showTermsDialog(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (context) {
      return ReusableDialog(
        title: '사용 안내',
        content: Text(
            '1. 주문외우기 버튼을 눌러서 말로 장난감을 만들 수 있어요! \n\n2. 그림그리기 버튼을 눌러서 그림으로 나의 상상을 표현할 수 있어요!\n\n3. 스케치북에서 내가 그린 그림을 확인할 수 있어요!\n\n4. 스케치북에 들어가면 내가 그린 그림을 장난감으로 만들 수 있어요!\n\n5. 장난감 상자에서 내가 만든 장난감을 확인하고, 3D 프린트를 위한 파일을 다운받을 수 있어요! \n\n6. 스케치북에서 5개를 새로 만들면 레벨이 올라가요!\n\n7. 장난감을 5개 새로 만들면 레벨이 올라가요!',
            style: TextStyle(
                fontFamily: 'cookierun',
                color: CupertinoColors.black,
                fontSize: 20)),
      );
    },
  );
}
