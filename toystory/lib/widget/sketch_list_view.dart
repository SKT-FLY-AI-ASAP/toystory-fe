import 'package:flutter/cupertino.dart';
import 'package:toystory/widget/sketch_card.dart';
import 'package:toystory/services/api_service.dart';

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
  List<Sketch> sketches = [];

  @override
  void initState() {
    super.initState();
    fetchSketchbookList(); // 데이터를 가져오는 함수 호출
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
          Text(
            '스케치북',
            style:
                CupertinoTheme.of(context).textTheme.navTitleTextStyle.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.systemPurple,
                    ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Container(
              height: double.infinity,
              child: sketches.isEmpty
                  ? Center(child: CupertinoActivityIndicator()) // 로딩 중 표시
                  : ListView(
                      scrollDirection: Axis.horizontal,
                      children: sketches.map((sketch) {
                        return SketchCard(
                          sketchId: sketch.sketchId,
                          sketchTitle: sketch.sketchTitle,
                          sketchUrl: sketch.sketchUrl,
                        );
                      }).toList(),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
