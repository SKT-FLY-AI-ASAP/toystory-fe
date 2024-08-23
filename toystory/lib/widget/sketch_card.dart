import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toystory/screen/sketch_viewer_page.dart'; // SketchViewerPage 임포트

class SketchCard extends StatelessWidget {
  final int sketchId;
  final String sketchTitle;
  final String sketchUrl;

  SketchCard({
    required this.sketchId,
    required this.sketchTitle,
    required this.sketchUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300, // 정사각형 크기 설정
      height: 300, // 정사각형 크기 설정
      child: CupertinoButton(
        padding: EdgeInsets.all(8.0),
        onPressed: () {
          // 클릭 시 이벤트 처리
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => SketchViewer(
                title: sketchTitle,
                imageUrl: sketchUrl,
                imageId: sketchId,
              ),
            ),
          );
        },
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 네트워크 이미지 로드
                SizedBox(
                  height: 200, // 원하는 이미지의 고정 높이
                  width: 200, // 원하는 이미지의 고정 너비
                  child: Image.network(
                    sketchUrl, // 네트워크 이미지 URL
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error, color: Colors.red); // 오류 발생 시 표시
                    },
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  sketchTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
