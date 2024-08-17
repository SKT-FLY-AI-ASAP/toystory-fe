import 'package:flutter/cupertino.dart';

class DocumentPage extends StatelessWidget {
  const DocumentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 화면의 너비를 가져옴
    final double screenWidth = MediaQuery.of(context).size.width;

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
      child: SafeArea(
        child: GridView.count(
          crossAxisCount: 5, // 한 행에 5개의 아이템을 배치
          padding: const EdgeInsets.all(16.0),
          crossAxisSpacing: 16.0, // 아이템 사이의 가로 간격
          mainAxisSpacing: 16.0, // 아이템 사이의 세로 간격
          children: List.generate(5, (index) {
            return Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (index == 0) {
                        // Navigator.push(
                        //   context,
                        //   CupertinoPageRoute(
                        //     builder: (context) => const DrawScreen(title: '제목'),
                        //   ),
                        // );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: index == 0
                            ? CupertinoColors.activeBlue
                            : CupertinoColors.systemGrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: screenWidth / 6, // 아이템 너비 (화면의 1/6로 설정)
                      child: index == 0
                          ? Center(
                              child: Icon(
                                CupertinoIcons.add, // 첫 번째 박스에 아이콘을 표시
                                color: CupertinoColors.white,
                                size: 40,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/img/2d/image_$index.png', // 이미지 파일 경로
                                fit: BoxFit.cover, // 이미지를 꽉 채우기
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 8), // 아이템과 제목 사이의 간격
                Text(
                  index == 0 ? '새로 만들기' : '아이템 $index 제목',
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
