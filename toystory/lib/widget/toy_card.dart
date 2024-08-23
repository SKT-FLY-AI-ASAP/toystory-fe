import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:toystory/screen/sketch_viewer_page.dart';
import 'package:toystory/screen/glb_viewer_page.dart';

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
      width: 300,
      height: 300,
      child: CupertinoButton(
        padding: EdgeInsets.all(8.0),
        // onPressed: () {
        //   // ToyCard 클릭 시 SketchViewerPage로 이동
        //   print('ToyCard 클릭: $toyTitle');
        //   Navigator.push(
        //     context,
        //     CupertinoPageRoute(
        //       builder: (context) => SketchViewer(
        //         title: toyTitle,
        //         imageUrl: toyUrl,
        //         imageId: toyId,
        //       ),
        //     ),
        //   );
        // },
        onPressed: () {
          // content_id를 My3DModel에 전달하여 3D 뷰어로 이동
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => My3DModel(
                contentId: toyId, // contentId 전달
              ),
            ),
          );
          //print('${item.contentTitle} 클릭됨');
        },
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 원격 이미지를 로드하는 부분
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.network(
                    toyUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.error,
                        color: Colors.red,
                      ); // 오류 발생 시 표시
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
