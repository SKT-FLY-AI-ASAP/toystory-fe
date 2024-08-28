import 'package:flutter/cupertino.dart';
import 'package:toystory/widget/sketch_card.dart';
import 'package:toystory/services/api_service.dart';
import 'package:getwidget/getwidget.dart';

class Sketch {
  final int sketchId;
  final String sketchTitle;
  final String sketchUrl;

  Sketch({
    required this.sketchId,
    required this.sketchTitle,
    required this.sketchUrl,
  });
}

class SketchListView extends StatefulWidget {
  @override
  _SketchListViewState createState() => _SketchListViewState();
}

class _SketchListViewState extends State<SketchListView> {
  String nickname = 'User';
  List<Sketch> sketches = [];
  int userLevel = 1; // 사용자 레벨 상태 초기화
  int nextLevel = 2;
  int totalSketches = 0; // 전체 스케치 개수
  double progressPercent = 0.0; // 프로그레스 바 진행률

  @override
  void initState() {
    super.initState();
    fetchSketchbookList(); // 데이터를 가져오는 함수 호출
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    try {
      final response = await ApiService().fetchUserInfo();
      setState(() {
        nickname = response["data"]["nickname"];
      });
    } catch (e) {
      print(e);
    }
  }

  // API 호출 함수
  Future<void> fetchSketchbookList() async {
    try {
      // API 서비스에서 데이터를 가져옴
      final response = await ApiService().fetchSketchbookList();
      setState(() {
        // 응답 데이터를 Sketch 객체 리스트로 변환
        sketches = (response['data'] as List).map<Sketch>((json) {
          return Sketch(
            sketchId: json['sketch_id'],
            sketchTitle: json['sketch_title'],
            sketchUrl: json['sketch_url'],
          );
        }).toList();

        // 스케치 개수에 따라 레벨 계산
        totalSketches = sketches.length;
        userLevel = (totalSketches / 5).ceil(); // 레벨 계산 (5개의 스케치당 1레벨)
        nextLevel = userLevel + 1; // 다음 레벨

        // 현재 레벨에서 그린 스케치 수
        int sketchesInCurrentLevel = totalSketches % 5;
        // 다음 레벨까지 남은 진행률 계산 (0.0 ~ 1.0)
        progressPercent = sketchesInCurrentLevel / 5;
      });
    } catch (e) {
      print(e); // 에러 발생 시 처리
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween, // 좌우 배치
            children: [
              SizedBox(
                width: 320, // 원하는 너비 설정
                child: Row(
                  children: [
                    Text(
                      '$nickname의 스케치북',
                      style: TextStyle(
                        fontSize: 30,
                        color: CupertinoColors.systemIndigo,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'cookierun',
                      ),
                      overflow: TextOverflow.ellipsis, // 텍스트가 너무 길 경우 생략표시(...)
                    ),
                    SizedBox(width: 10), // 텍스트와 아이콘 사이 간격 설정
                    Icon(
                      CupertinoIcons.book, // 원하는 아이콘 설정
                      color: CupertinoColors.systemIndigo,
                      size: 30, // 아이콘 크기 설정
                    ),
                  ],
                ),
              ),
              SizedBox(width: 30),
              // 프로그레스바를 SizedBox로 감싸서 크기 지정
              SizedBox(
                width: 350, // 너비 설정
                height: 30, // 높이 설정
                child: GFProgressBar(
                  percentage: progressPercent, // 다음 레벨까지 남은 진행률
                  lineHeight: 25,
                  width: 170,
                  alignment: MainAxisAlignment.spaceBetween,
                  backgroundColor: CupertinoColors.systemGrey4,
                  progressBarColor: CupertinoColors.systemIndigo,
                  leading: Text('레벨 $userLevel',
                      style: TextStyle(
                          fontSize: 20,
                          color: CupertinoColors.systemGrey,
                          fontFamily: 'cookierun')),
                  trailing: Text('레벨 $nextLevel',
                      style: TextStyle(
                          fontSize: 20,
                          color: CupertinoColors.systemGrey,
                          fontFamily: 'cookierun')),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: Container(
              height: double.infinity,
              child: sketches.isEmpty
                  ? Center(child: CupertinoActivityIndicator()) // 로딩 중 표시
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: sketches.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(width: 20), // 간격 설정
                      itemBuilder: (context, index) {
                        final sketch = sketches[index];
                        return GestureDetector(
                          onTap: () {
                            // 카드 클릭 시 추가 동작을 수행할 수 있습니다.
                          },
                          child: SketchCard(
                            sketchId: sketch.sketchId,
                            sketchTitle: sketch.sketchTitle,
                            sketchUrl: sketch.sketchUrl,
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
