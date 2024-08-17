import 'package:flutter/cupertino.dart';

class ThreeDPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('3D'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            // 3D 이미지 삭제 기능 구현
            print('3D 페이지의 휴지통 버튼 눌림');
          },
          child: Icon(CupertinoIcons.trash),
        ),
      ),
      child: Center(
        child: Text('3D 페이지에서 3D 이미지를 보여줍니다.'),
      ),
    );
  }
}
