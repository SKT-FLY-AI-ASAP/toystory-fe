import 'package:flutter/cupertino.dart';
import 'package:toystory/widget/toy_card.dart';
import 'package:toystory/services/api_service.dart';

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
  @override
  _ToyListViewState createState() => _ToyListViewState();
}

class _ToyListViewState extends State<ToyListView> {
  List<Toy> toys = [];

  @override
  void initState() {
    super.initState();
    fetchToyList(); // 데이터를 가져오는 함수 호출
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
          Text(
            '장난감 상자',
            style:
                CupertinoTheme.of(context).textTheme.navTitleTextStyle.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.systemIndigo,
                    ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Container(
              height: double.infinity,
              child: toys.isEmpty
                  ? Center(child: CupertinoActivityIndicator()) // 로딩 인디케이터
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: toys.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(width: 20), // 아이템 사이의 간격 설정
                      itemBuilder: (context, index) {
                        final toy = toys[index];
                        return ToyCard(
                          toyId: toy.toyId,
                          toyTitle: toy.toyTitle,
                          toyUrl: toy.toyUrl,
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
