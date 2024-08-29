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
  static AudioPlayer? _audioPlayer;
  bool _isBGMPlaying = true;

  @override
  void initState() {
    super.initState();

    if (_audioPlayer == null) {
      _audioPlayer = AudioPlayer();
      _audioPlayer!.setReleaseMode(ReleaseMode.loop);
      _audioPlayer!.onPlayerStateChanged.listen((PlayerState state) {
        setState(() {
          _isBGMPlaying = state == PlayerState.playing;
        });
      });
      _playBGM(); // 초기화 후 바로 재생
    }
  }

  Future<void> _playBGM() async {
    if (!_isBGMPlaying) {
      await _audioPlayer!.play(AssetSource('sounds/cute2.mp3'), volume: 0.5);
      setState(() {
        _isBGMPlaying = true;
      });
    }
  }

  void _stopBGM() {
    _audioPlayer!.stop();
    setState(() {
      _isBGMPlaying = false;
    });
  }

  void _onBGMChanged(bool isPlaying) {
    if (isPlaying) {
      _playBGM();
    } else {
      _stopBGM();
    }
  }

  @override
  void dispose() {
    _audioPlayer!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Sidebar(
              isBGMPlaying: _isBGMPlaying,
              onBGMChanged: _onBGMChanged,
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  SketchListView(),
                  SizedBox(height: 40),
                  ToyListView(
                    stopBGM: _stopBGM,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
