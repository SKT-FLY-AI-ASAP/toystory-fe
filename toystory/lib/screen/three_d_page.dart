import 'package:flutter/cupertino.dart';
import 'package:toystory/widget/settings_button.dart';
import 'glb_viewer_page.dart';

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

List<ThreeDItem> sampleThreeDItems = [
  ThreeDItem(
    contentId: 1,
    contentTitle: '빙봉',
    userId: 101,
    contentUrl: 'assets/img/3d/image_1.webp',
    isRemoved: false,
  ),
  ThreeDItem(
    contentId: 2,
    contentTitle: '비행기',
    userId: 102,
    contentUrl: 'assets/img/3d/image_2.webp',
    isRemoved: false,
  ),
  ThreeDItem(
    contentId: 3,
    contentTitle: '전설의 동물',
    userId: 103,
    contentUrl: 'assets/img/3d/image_3.webp',
    isRemoved: false,
  ),
  ThreeDItem(
    contentId: 4,
    contentTitle: '곰돌이',
    userId: 104,
    contentUrl: 'assets/img/3d/image_4.webp',
    isRemoved: false,
  ),
  ThreeDItem(
    contentId: 1,
    contentTitle: '엑스칼리버',
    userId: 101,
    contentUrl: 'assets/img/3d/image_5.webp',
    isRemoved: false,
  ),
  ThreeDItem(
    contentId: 2,
    contentTitle: '라이언킹',
    userId: 102,
    contentUrl: 'assets/img/3d/image_6.webp',
    isRemoved: false,
  ),
  ThreeDItem(
    contentId: 3,
    contentTitle: '거북이',
    userId: 103,
    contentUrl: 'assets/img/3d/image_7.webp',
    isRemoved: false,
  ),
  ThreeDItem(
    contentId: 4,
    contentTitle: '사자',
    userId: 104,
    contentUrl: 'assets/img/3d/image_8.webp',
    isRemoved: false,
  ),
  ThreeDItem(
    contentId: 4,
    contentTitle: '칼',
    userId: 104,
    contentUrl: 'assets/img/3d/image_9.webp',
    isRemoved: false,
  ),
];

class ThreeDPage extends StatelessWidget {
  const ThreeDPage({Key? key}) : super(key: key);

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
          '장난감상자',
          style: TextStyle(
            //fontFamily: 'crayon',
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
                print('3D 페이지의 휴지통 버튼 눌림');
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
          const SizedBox(height: 16), // 네비게이션 바와 컨텐츠 사이에 간격 추가
          Expanded(
            child: Container(
              color:
                  CupertinoColors.extraLightBackgroundGray, // SafeArea의 배경색 변경
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
                                  builder: (context) =>
                                      My3DModel(), // 3D 모델 뷰어로 이동
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
            ),
          ),
        ],
      ),
    );
  }
}
