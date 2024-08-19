import 'package:flutter/cupertino.dart';
import 'package:toystory/widget/settings_button.dart';

class TrashPage extends StatelessWidget {
  const TrashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('휴지통'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                print('휴지통 페이지의 휴지통 버튼 눌림');
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
          children: List.generate(3, (index) {
            return Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      print('휴지통 아이템 $index 클릭됨');
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
                          'assets/img/trash/image_$index.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8), // 아이템과 제목 사이의 간격
                Text(
                  '휴지통 아이템 $index 제목',
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
