import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'magic_dialog.dart';
import 'package:toystory/screen/draw_page.dart';
import 'package:toystory/services/api_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:toystory/widget/settings_button.dart';

class Sidebar extends StatefulWidget {
  final Function(bool) onBGMChanged;
  final bool isBGMPlaying;

  Sidebar({
    required this.onBGMChanged,
    required this.isBGMPlaying,
  });

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  String nickname = "앤디";
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    //fetchUserInfo();
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        CupertinoButton(
                          onPressed: () {
                            widget.onBGMChanged(!widget.isBGMPlaying);
                          },
                          padding: EdgeInsets.zero,
                          child: Icon(
                            widget.isBGMPlaying
                                ? CupertinoIcons.speaker_2_fill
                                : CupertinoIcons.speaker_slash_fill,
                            size: 30,
                            color: CupertinoColors.systemIndigo,
                          ),
                        ),
                        Flexible(
                          child: SettingsButton(),
                        ),
                      ],
                    ),

                    // 프로필 이미지
                    Center(
                      child: CircleAvatar(
                        radius: 100,
                        backgroundImage:
                            AssetImage('assets/img/3d/image_1.webp'),
                        backgroundColor:
                            CupertinoColors.systemGrey.withOpacity(0.3),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 닉네임 표시
                    Center(
                      child: Text(
                        '안녕, $nickname!',
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .navTitleTextStyle
                            .copyWith(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: CupertinoColors.systemIndigo,
                              fontFamily: 'cookierun',
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 안내 텍스트
                    Center(
                      child: Text(
                        '너만의 세상을\n만들어볼래?',
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .navTitleTextStyle
                            .copyWith(
                              fontSize: 25,
                              color:
                                  CupertinoColors.systemIndigo.withOpacity(0.7),
                              fontFamily: 'cookierun',
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 30),

                    Spacer(),

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
                          if (widget.isBGMPlaying) {
                            widget.onBGMChanged(false);
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
                          if (widget.isBGMPlaying) {
                            widget.onBGMChanged(false);
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
                            Icon(Icons.palette,
                                color: CupertinoColors.white, size: 24),
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
              ),
            ),
          );
        },
      ),
    );
  }
}
