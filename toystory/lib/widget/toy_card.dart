import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // 오디오 플레이어 패키지 추가
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
    final AudioPlayer _audioPlayer = AudioPlayer(); // 오디오 플레이어 초기화

    return SizedBox(
      width: 250, // 카드의 너비
      height: 250, // 카드의 높이
      child: CupertinoButton(
        onPressed: () async {
          // 효과음 재생
          try {
            await _audioPlayer.play(AssetSource('sounds/boing.mp3'));
          } catch (e) {
            print('Error playing sound: $e');
          }

          // 효과음이 재생된 후 3D 뷰어로 이동
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
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 원격 이미지를 로드하는 부분
                Flexible(
                  flex: 5,
                  child: SizedBox(
                    height: 200,
                    width: 200, // 원하는 이미지의 고정 너비
                    child: Image.network(
                      toyUrl,
                      fit: BoxFit.cover,
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
                ),
                const SizedBox(height: 10),
                Flexible(
                  flex: 1,
                  child: Text(
                    toyTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 22, // 폰트 크기를 더 크게 설정
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.systemIndigo,
                        fontFamily: 'cookierun'),
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
