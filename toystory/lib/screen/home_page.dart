import 'package:flutter/cupertino.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:toystory/widget/sketch_list_view.dart';
import 'package:toystory/widget/toy_list_view.dart';
import 'package:toystory/widget/sidebar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AudioPlayer _audioPlayer;
  bool _isBGMPlaying = true; // BGM 상태 추적

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setReleaseMode(ReleaseMode.loop); // 반복 모드로 설정
    _playBGM();
  }

  void _playBGM() async {
    if (_isBGMPlaying) {
      await _audioPlayer.play(AssetSource('sounds/cute2.mp3'), volume: 0.5);
    } else {
      await _audioPlayer.stop();
    }
  }

  void _onBGMChanged(bool isPlaying) {
    setState(() {
      _isBGMPlaying = isPlaying;
    });
    _playBGM();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Sidebar(onBGMChanged: _onBGMChanged),
          ),
          // 메인 컨텐츠 영역
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  SketchListView(),
                  SizedBox(height: 40),
                  ToyListView(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
