import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // 오디오 플레이어 패키지 추가
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
    final AudioPlayer _audioPlayer = AudioPlayer(); // 오디오 플레이어 초기화

    return SizedBox(
      width: 250, // 정사각형 크기 설정
      height: 250, // 정사각형 크기 설정
      child: CupertinoButton(
        onPressed: () async {
          // 효과음 재생
          try {
            await _audioPlayer.play(AssetSource('sounds/boing.mp3'));
          } catch (e) {
            print('Error playing sound: $e');
          }

          // 페이지 전환
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
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 네트워크 이미지 로드
                Flexible(
                  flex: 5,
                  child: SizedBox(
                    height: 200, // 원하는 이미지의 고정 높이
                    width: 200, // 원하는 이미지의 고정 너비
                    child: Image.network(
                      sketchUrl, // 네트워크 이미지 URL
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.white, // 이미지 로드 실패 시 흰색 네모를 그려줌
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
                ),
                SizedBox(height: 10),
                Flexible(
                  flex: 1,
                  child: Text(
                    sketchTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22, // 폰트 크기를 더 크게 설정
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.systemIndigo,
                      fontFamily: 'cookierun',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
