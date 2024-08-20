import 'package:flutter/cupertino.dart';
import 'package:toystory/widget/settings_button.dart';
import 'glb_viewer_page.dart';

// 3D 아이템 모델 클래스
class ThreeDItem {
  final int contentId;
  final String contentTitle;
  final int userId;
  final String contentUrl;
  final bool isRemoved;

  ThreeDItem({
    required this.contentId,
    required this.contentTitle,
    required this.userId,
    required this.contentUrl,
    required this.isRemoved,
  });
}

// 샘플 데이터 리스트
List<ThreeDItem> sampleThreeDItems = [
  ThreeDItem(
    contentId: 1,
    contentTitle: '3D Model 1',
    userId: 101,
    contentUrl: 'assets/img/3d/image_1.png',
    isRemoved: false,
  ),
  ThreeDItem(
    contentId: 2,
    contentTitle: '3D Model 2',
    userId: 102,
    contentUrl: 'assets/img/3d/image_2.png',
    isRemoved: false,
  ),
  ThreeDItem(
    contentId: 3,
    contentTitle: '3D Model 3',
    userId: 103,
    contentUrl: 'assets/img/3d/image_3.png',
    isRemoved: false,
  ),
  ThreeDItem(
    contentId: 4,
    contentTitle: '3D Model 4',
    userId: 104,
    contentUrl: 'assets/img/3d/image_4.png',
    isRemoved: false,
  ),
  // ThreeDItem(
  //   contentId: 5,
  //   contentTitle: '3D Model 5',
  //   userId: 105,
  //   contentUrl: 'assets/img/3d/image_5.png',
  //   isRemoved: false,
  // ),
];

class ThreeDPage extends StatelessWidget {
  const ThreeDPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('3D'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                print('3D 페이지의 휴지통 버튼 눌림');
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
          crossAxisCount: 5, // 한 행에 5개의 아이템을 배치
          padding: const EdgeInsets.all(16.0),
          crossAxisSpacing: 16.0, // 아이템 사이의 가로 간격
          mainAxisSpacing: 16.0, // 아이템 사이의 세로 간격
          children: List.generate(sampleThreeDItems.length, (index) {
            final item = sampleThreeDItems[index]; // 샘플 데이터에서 아이템 가져오기

            return Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => My3DModel(), // 3D 모델 뷰어로 이동
                        ),
                      );
                      print('${item.contentTitle} 클릭됨');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: screenWidth / 6,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          item.contentUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8), // 아이템과 제목 사이의 간격
                Text(
                  item.contentTitle, // 3D 아이템의 제목 표시
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: CupertinoColors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
