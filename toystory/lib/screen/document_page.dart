import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'draw_page.dart';
import 'package:toystory/widget/settings_button.dart';

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

class DocumentPage extends StatelessWidget {
  const DocumentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    List<Painting> paintings = samplePaintings; // 샘플 데이터 불러오기

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('문서'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                print('문서 페이지의 휴지통 버튼 눌림');
              },
              child: Icon(CupertinoIcons.trash),
            ),
            const SizedBox(width: 8),
            SettingsButton(),
          ],
        ),
      ),
      child: SafeArea(
        child: GridView.count(
          crossAxisCount: 5,
          padding: const EdgeInsets.all(16.0),
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: List.generate(paintings.length + 1, (index) {
            if (index == 0) {
              return Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          CupertinoPageRoute(
                            fullscreenDialog: false,
                            builder: (context) => const DrawPage(title: '제목'),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: CupertinoColors.activeBlue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: screenWidth / 6,
                        child: Center(
                          child: Icon(
                            CupertinoIcons.add,
                            color: CupertinoColors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '새로 만들기',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: CupertinoColors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            } else {
              final painting = paintings[index - 1];
              return Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: screenWidth / 6,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          painting.paintingUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    painting.paintingTitle,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: CupertinoColors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            }
          }),
        ),
      ),
    );
  }
}
