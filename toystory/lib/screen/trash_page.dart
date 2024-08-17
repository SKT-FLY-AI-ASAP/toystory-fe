import 'package:flutter/cupertino.dart';

class TrashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('휴지통'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            // 영구 삭제 기능 구현
            print('휴지통 페이지의 휴지통 버튼 눌림');
          },
          child: Icon(CupertinoIcons.trash),
        ),
      ),
      child: Center(
        child: Text('휴지통에서 삭제된 이미지를 보여줍니다.'),
      ),
    );
  }
}
