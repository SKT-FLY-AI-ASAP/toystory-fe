import 'package:flutter/cupertino.dart';
import 'package:toystory/widget/settings_button.dart';
import 'package:toystory/widget/magic_dialog.dart';
import 'draw_page.dart';

class Painting {
  final int paintingId;
  final int userId;
  final String paintingTitle;
  final String paintingUrl;
  final bool isRemoved;

  Painting({
    required this.paintingId,
    required this.userId,
    required this.paintingTitle,
    required this.paintingUrl,
    required this.isRemoved,
  });
}

List<Painting> samplePaintings = [
  Painting(
    paintingId: 1,
    userId: 101,
    paintingTitle: 'Sunset',
    paintingUrl: 'assets/img/2d/image_1.png',
    isRemoved: false,
  ),
  Painting(
    paintingId: 2,
    userId: 102,
    paintingTitle: 'Ocean View',
    paintingUrl: 'assets/img/2d/image_2.png',
    isRemoved: false,
  ),
  Painting(
    paintingId: 3,
    userId: 103,
    paintingTitle: 'Mountain',
    paintingUrl: 'assets/img/2d/image_3.png',
    isRemoved: false,
  ),
  // 추가적인 샘플 아이템...
];

class TrashPage extends StatelessWidget {
  const TrashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: const Color.fromARGB(18, 54, 23, 206), // 배경색 변경
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.white, // 하단 경계선 색상 변경
            width: 0.0, // 경계선 두께 조정 (없애기 위해 0 설정)
          ),
        ),
        middle: Text(
          '주문외우기',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 54, 23, 206), // 텍스트 색상 변경
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                print('휴지통 페이지의 휴지통 버튼 눌림');
              },
              child: Icon(
                CupertinoIcons.trash,
                color: const Color.fromARGB(255, 54, 23, 206), // 아이콘 색상 변경
                size: 22.0,
              ),
            ),
            const SizedBox(width: 8),
            SettingsButton(),
          ],
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 16), // 네비게이션 바와 컨텐츠 사이에 간격 추가
          Expanded(
            child: Container(
              color: CupertinoColors.systemGrey5, // SafeArea의 배경색 변경
              child: SafeArea(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5, // 한 행에 5개의 아이템을 배치
                    crossAxisSpacing: 16.0, // 아이템 사이의 가로 간격
                    mainAxisSpacing: 16.0, // 아이템 사이의 세로 간격
                  ),
                  itemCount: samplePaintings.length + 1, // +1은 새로 만들기 버튼
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // magic_dialog.dart 파일에 정의된 showMagicDialog 함수 호출
                    return Column(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              showMagicDialog(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: CupertinoColors.systemGrey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Icon(
                                  CupertinoIcons.add,
                                  size: 40,
                                  color: CupertinoColors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '새로 만들기',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: CupertinoColors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                    } else {
                      final painting = samplePaintings[index - 1];
                      return Column(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                print('휴지통 아이템 ${painting.paintingId} 클릭됨');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: CupertinoColors.systemGrey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    painting.paintingUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8), // 아이템과 제목 사이의 간격
                          Text(
                            painting.paintingTitle,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: CupertinoColors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


