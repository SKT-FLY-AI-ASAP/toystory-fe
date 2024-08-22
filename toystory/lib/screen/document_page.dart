import 'package:flutter/cupertino.dart';
import 'draw_page.dart';
import 'package:toystory/widget/settings_button.dart';
import 'package:toystory/services/api_service.dart';
import 'package:toystory/screen/sketch_viewer_page.dart'; // SketchViewer import

class Painting {
  final int paintingId;
  final String paintingTitle;
  final String paintingUrl;

  Painting({
    required this.paintingId,
    required this.paintingTitle,
    required this.paintingUrl,
  });
}

class DocumentPage extends StatefulWidget {
  const DocumentPage({Key? key}) : super(key: key);

  @override
  _DocumentPageState createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  List<Painting> paintings = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 페이지가 다시 로드될 때마다 API 호출
    fetchSketchbookList();
  }

  // API 호출 함수
  Future<void> fetchSketchbookList() async {
    try {
      // API 서비스에서 데이터를 가져옴
      final response = await ApiService().fetchSketchbookList();
      setState(() {
        // 응답 데이터가 리스트라고 가정하고 변환
        paintings = (response['data'] as List).map<Painting>((json) {
          return Painting(
            paintingId: json['sketch_id'],
            paintingTitle: json['sketch_title'],
            paintingUrl: json['sketch_url'],
          );
        }).toList();
      });
    } catch (e) {
      print(e); // 에러 발생 시 처리
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: const Color.fromARGB(18, 54, 23, 206),
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.systemGrey,
            width: 0.0,
          ),
        ),
        middle: Text(
          '스케치북',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: CupertinoColors.systemGrey,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                print('문서 페이지의 휴지통 버튼 눌림');
              },
              child: Icon(
                CupertinoIcons.trash,
                color: const Color.fromARGB(255, 54, 23, 206),
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
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              color: CupertinoColors.extraLightBackgroundGray,
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
                                    builder: (context) => const DrawPage(),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(80, 54, 23, 206),
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
                            child: GestureDetector(
                              onTap: () {
                                // 해당 그림 클릭 시 SketchViewer 페이지로 이동
                                Navigator.of(context, rootNavigator: true).push(
                                  CupertinoPageRoute(
                                    builder: (context) => SketchViewer(
                                      title: painting.paintingTitle,
                                      imageUrl: painting.paintingUrl,
                                      imageId: painting.paintingId,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: CupertinoColors.systemGrey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: screenWidth / 6,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    painting.paintingUrl,
                                    fit: BoxFit.cover,
                                  ),
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
            ),
          ),
        ],
      ),
    );
  }
}
