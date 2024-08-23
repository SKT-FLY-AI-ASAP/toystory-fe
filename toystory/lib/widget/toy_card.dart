import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toystory/screen/glb_viewer_page.dart'; // My3DModel 페이지 임포트

class ToyCard extends StatelessWidget {
  final int toyId;
  final String toyTitle;
  final String toyUrl;

  ToyCard({
    required this.toyId,
    required this.toyTitle,
    required this.toyUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250, // 정사각형 크기 설정
      height: 250, // 정사각형 크기 설정
      child: CupertinoButton(
        onPressed: () {
          // contentId를 My3DModel에 전달하여 3D 뷰어로 이동
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => My3DModel(
                contentId: toyId, // contentId 전달
              ),
            ),
          );
        },
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 원격 이미지를 로드하는 부분
                SizedBox(
                  height: 200, // 원하는 이미지의 고정 높이
                  width: 200, // 원하는 이미지의 고정 너비
                  child: Image.network(
                    toyUrl,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.white, // 이미지 로드 실패 시 흰색 네모를 표시
                        child: Center(
                          child: Text(
                            '이미지 불러오기 실패',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  toyTitle,
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
