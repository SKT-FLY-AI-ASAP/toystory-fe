import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'magic_dialog.dart';
import 'package:toystory/screen/draw_page.dart';
import 'package:toystory/services/api_service.dart';
import 'package:audioplayers/audioplayers.dart';

class Sidebar extends StatefulWidget {
  final Function(bool) onBGMChanged;

  Sidebar({required this.onBGMChanged});

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  String nickname = "User";
  bool _isBGMPlaying = true;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    fetchUserInfo();
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

  void _toggleBGM() {
    setState(() {
      _isBGMPlaying = !_isBGMPlaying;
    });
    widget.onBGMChanged(_isBGMPlaying);
  }

  Future<void> _playMagicSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/magic_sound.wav'));
    } catch (e) {
      print('효과음 재생 실패: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.systemIndigo.withOpacity(0.3),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          CupertinoButton(
            onPressed: _toggleBGM,
            padding: EdgeInsets.zero,
            child: Icon(
              _isBGMPlaying
                  ? CupertinoIcons.speaker_2_fill
                  : CupertinoIcons.speaker_slash_fill,
              size: 30,
              color: CupertinoColors.systemIndigo,
            ),
          ),

          //const SizedBox(height: 10),

          // 원형 사진을 위한 CircleAvatar
          Center(
            child: CircleAvatar(
              radius: 100, // 원형의 반지름
              backgroundImage:
                  AssetImage('assets/img/profile_image.png'), // 사진 경로
              backgroundColor:
                  CupertinoColors.systemGrey.withOpacity(0.3), // 사진이 없을 때의 배경색
            ),
          ),

          const SizedBox(height: 20),

          // 안녕, $nickname! 텍스트
          Center(
            child: Text(
              '안녕, $nickname!',
              style: CupertinoTheme.of(context)
                  .textTheme
                  .navTitleTextStyle
                  .copyWith(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.systemIndigo,
                    fontFamily: 'cookierun',
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),

          // 너만의 세상을 만들어볼래? 텍스트
          Center(
            child: Text(
              '너만의 세상을             만들어볼래?',
              style: CupertinoTheme.of(context)
                  .textTheme
                  .navTitleTextStyle
                  .copyWith(
                    fontSize: 30,
                    color: CupertinoColors.systemIndigo,
                    fontFamily: 'cookierun',
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),

          const Spacer(), // Spacer to push the buttons to the bottom

          // 주문외우기 버튼
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: Offset(2, 4),
                ),
              ],
              borderRadius: BorderRadius.circular(12),
            ),
            child: CupertinoButton(
              color: CupertinoColors.systemIndigo,
              onPressed: () {
                if (_isBGMPlaying) {
                  _toggleBGM();
                }
                _playMagicSound();
                showMagicDialog(context);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.auto_fix_high,
                      color: CupertinoColors.white, size: 24),
                  SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      '주문외우기',
                      style: TextStyle(
                          color: CupertinoColors.white,
                          fontSize: 22,
                          fontFamily: 'cookierun',
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 그림그리기 버튼
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: Offset(2, 4),
                ),
              ],
              borderRadius: BorderRadius.circular(12),
            ),
            child: CupertinoButton(
              color: CupertinoColors.systemIndigo,
              onPressed: () {
                if (_isBGMPlaying) {
                  _toggleBGM();
                }
                _playMagicSound();
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute(
                    fullscreenDialog: false,
                    builder: (context) => const DrawPage(),
                  ),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.palette, color: CupertinoColors.white, size: 24),
                  SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      '그림그리기',
                      style: TextStyle(
                        color: CupertinoColors.white,
                        fontSize: 22,
                        fontFamily: 'cookierun',
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
