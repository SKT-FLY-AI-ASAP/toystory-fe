import 'package:flutter/cupertino.dart';
import 'package:toystory/widget/toy_card.dart';
import 'package:toystory/services/api_service.dart';
import 'package:getwidget/getwidget.dart';

class Toy {
  final int toyId;
  final String toyTitle;
  final String toyUrl;

  Toy({
    required this.toyId,
    required this.toyTitle,
    required this.toyUrl,
  });
}

class ToyListView extends StatefulWidget {
  final VoidCallback stopBGM;
  ToyListView({required this.stopBGM});
  @override
  _ToyListViewState createState() => _ToyListViewState();
}

class _ToyListViewState extends State<ToyListView> {
  String nickname = '앤디';
  List<Toy> toys = [];
  int userLevel = 1; // 사용자 레벨 상태 초기화
  int nextLevel = 2;
  int totalToys = 0;
  double progressPercent = 0.0; // 프로그레스 바 진행률

  @override
  void initState() {
    super.initState();
    fetchToyList(); // 데이터를 가져오는 함수 호출
    //fetchUserInfo();
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
  Future<void> fetchToyList() async {
    try {
      // API 서비스에서 데이터를 가져옴
      final response = await ApiService().fetchThreeDItems();
      setState(() {
        // 응답 데이터를 Toy 객체 리스트로 변환
        toys = (response['data'] as List).map<Toy>((json) {
          return Toy(
            toyId: json['content_id'],
            toyTitle: json['content_title'],
            toyUrl: json['content_url'],
          );
        }).toList();

        // toys의 개수에 따라 userLevel을 계산 (toys.length 나누기 5)
        totalToys = toys.length;
        userLevel = (toys.length / 5).ceil(); // 나눈 값의 올림 처리
        nextLevel = userLevel + 1;

        int toysInCurrentLevel = totalToys % 5;
        progressPercent = toysInCurrentLevel / 5;
      });
    } catch (e) {
      print('Error fetching toy data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // 좌우 배치
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 320, // 원하는 너비 설정
                    child: Row(
                      children: [
                        Text(
                          '$nickname의 장난감상자',
                          style: TextStyle(
                            fontSize: 30,
                            color: CupertinoColors.systemIndigo,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'cookierun',
                          ),
                          overflow:
                              TextOverflow.ellipsis, // 텍스트가 너무 길 경우 생략표시(...)
                        ),
                        SizedBox(width: 10), // 텍스트와 아이콘 사이 간격
                        Icon(
                          CupertinoIcons.cube_box, // 원하는 아이콘 설정
                          color: CupertinoColors.systemIndigo,
                          size: 30, // 아이콘 크기 설정
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 30), // 텍스트 간 간격
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
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: Container(
              child: toys.isEmpty
                  ? Center(child: CupertinoActivityIndicator()) // 로딩 인디케이터
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: toys.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(width: 20), // 아이템 사이의 간격 설정
                      itemBuilder: (context, index) {
                        final toy = toys[index];
                        return GestureDetector(
                          onTap: () {},
                          child: ToyCard(
                            toyId: toy.toyId,
                            toyTitle: toy.toyTitle,
                            toyUrl: toy.toyUrl,
                            stopBGM: widget.stopBGM,
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
