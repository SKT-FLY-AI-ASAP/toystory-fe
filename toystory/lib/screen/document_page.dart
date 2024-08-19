import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'draw_page.dart';
import 'package:toystory/widget/settings_button.dart';

class DocumentPage extends StatelessWidget {
  const DocumentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

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
          children: List.generate(5, (index) {
            return Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (index == 0) {
                        // Use rootNavigator to hide the tab bar
                        Navigator.of(context, rootNavigator: true).push(
                          CupertinoPageRoute(
                            fullscreenDialog: false,
                            builder: (context) => const DrawPage(title: '제목'),
                          ),
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: index == 0
                            ? CupertinoColors.activeBlue
                            : CupertinoColors.systemGrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: screenWidth / 6,
                      child: index == 0
                          ? Center(
                              child: Icon(
                                CupertinoIcons.add,
                                color: CupertinoColors.white,
                                size: 40,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/img/2d/image_$index.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
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
