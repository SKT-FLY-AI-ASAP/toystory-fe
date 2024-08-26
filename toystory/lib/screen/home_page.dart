import 'package:flutter/cupertino.dart';
import 'package:toystory/widget/sketch_list_view.dart';
import 'package:toystory/widget/toy_list_view.dart';
import 'package:toystory/widget/sidebar.dart'; // 사이드바 파일을 임포트

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Row(
        children: [
          // 사이드바
          Expanded(
            flex: 1,
            child: Sidebar(), // 분리된 사이드바 위젯을 사용
          ),
          // 메인 컨텐츠 영역
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  // 스케치북 리스트
                  SketchListView(),
                  SizedBox(height: 40),
                  // 장난감 상자 리스트
                  ToyListView(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
