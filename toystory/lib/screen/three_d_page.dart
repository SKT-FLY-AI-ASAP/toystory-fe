import 'package:flutter/cupertino.dart';
import 'glb_viewer_page.dart';
import 'package:toystory/widget/settings_button.dart';
import 'package:toystory/services/api_service.dart'; // API Service를 위한 임포트

class ThreeDItem {
  final int contentId;
  final String contentTitle;
  final String contentUrl;

  ThreeDItem({
    required this.contentId,
    required this.contentTitle,
    required this.contentUrl,
  });

  // JSON 데이터를 ThreeDItem 객체로 변환하는 팩토리 메서드
  factory ThreeDItem.fromJson(Map<String, dynamic> json) {
    return ThreeDItem(
      contentId: json['content_id'],
      contentTitle: json['content_title'],
      contentUrl: json['content_url'],
    );
  }
}

class ThreeDPage extends StatefulWidget {
  const ThreeDPage({Key? key}) : super(key: key);

  @override
  _ThreeDPageState createState() => _ThreeDPageState();
}

class _ThreeDPageState extends State<ThreeDPage> {
  List<ThreeDItem> threeDItems = [];

  @override
  void initState() {
    super.initState();
    // 페이지가 로드될 때 API 호출
    fetchThreeDItems();
  }

  // AWS API에서 데이터를 가져오는 함수
  Future<void> fetchThreeDItems() async {
    try {
      final response = await ApiService().fetchThreeDItems(); // AWS API에서 데이터 가져오기
      setState(() {
        // 응답 데이터를 리스트로 변환
        threeDItems = (response['data'] as List)
            .map<ThreeDItem>((json) => ThreeDItem.fromJson(json))
            .toList();
      });
    } catch (e) {
      print(e); // 에러 처리
    }
  }

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
          '장난감 상자',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: CupertinoColors.systemGrey, // 텍스트 색상 변경
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
              color: CupertinoColors.extraLightBackgroundGray, // SafeArea의 배경색 변경
              child: SafeArea(
                child: GridView.count(
                  crossAxisCount: 5, // 한 행에 5개의 아이템을 배치
                  padding: const EdgeInsets.all(16.0),
                  crossAxisSpacing: 16.0, // 아이템 사이의 가로 간격
                  mainAxisSpacing: 16.0, // 아이템 사이의 세로 간격
                  children: List.generate(threeDItems.length, (index) {
                    final item = threeDItems[index]; // API에서 가져온 3D 아이템 데이터

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
                                child: Image.network(
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
