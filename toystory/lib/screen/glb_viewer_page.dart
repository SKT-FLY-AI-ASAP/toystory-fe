import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:toystory/widget/download_stl_dialog.dart';
import 'package:toystory/services/stl_downloader.dart';
import 'package:toystory/services/api_service.dart';
import 'package:audioplayers/audioplayers.dart';

class My3DModel extends StatefulWidget {
  final int contentId;

  const My3DModel({super.key, required this.contentId});

  @override
  _My3DModelState createState() => _My3DModelState();
}

class _My3DModelState extends State<My3DModel> {
  String? modelUrl;
  String? stlUrl;
  String? contentTitle;
  String? backgroundUrl;
  String? backgroundMusicUrl;
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    fetch3DModelData();
  }

  Future<void> fetch3DModelData() async {
    try {
      final response =
          await ApiService().fetch3DItemDetails(contentId: widget.contentId);
      setState(() {
        stlUrl = response['design_url'];
        contentTitle = response['content_title'];
        //modelUrl = 'assets/glb/yong.glb'; // 하나의 GLB 파일만 사용
        modelUrl = response['model_url']; // API에서 받은 3D 모델 파일 URL로 설정
        //backgroundUrl = 'assets/img/design/8.webp'; // 배경 이미지 URL 설정
        //backgroundUrl = response['background_image_url']; // 배경 이미지 URL 설정
        backgroundUrl = response['background_image_url'];
        backgroundMusicUrl =
            'https://asap-bucket.s3.ap-northeast-2.amazonaws.com/bgm/0-1teddybear.mp3'; // 배경 음악 URL 설정
      });
      playBackgroundMusic(); // 배경 음악 재생
    } catch (e) {
      print('3D 모델 데이터 로드 실패: $e');
      setState(() {
        modelUrl = 'assets/glb/5.glb'; // 로드 실패 시 기본 파일 사용
      });
    }
  }

  // 배경 음악 재생 함수
  Future<void> playBackgroundMusic() async {
    if (backgroundMusicUrl != null && backgroundMusicUrl!.isNotEmpty) {
      await _audioPlayer.play(
        UrlSource(backgroundMusicUrl!), // API에서 받은 배경음악 파일 URL로 재생
      );
      setState(() {
        isPlaying = true; // 배경 음악이 재생 중임을 표시
      });
    }
  }

  // 배경 음악 정지 함수
  Future<void> stopBackgroundMusic() async {
    await _audioPlayer.stop();
    setState(() {
      isPlaying = false; // 배경 음악이 정지됨을 표시
    });
  }

  // 배경 음악 On/Off 토글 함수
  void toggleBgm() {
    if (isPlaying) {
      stopBackgroundMusic();
    } else {
      playBackgroundMusic();
    }
  }

  @override
  void dispose() {
    stopBackgroundMusic(); // 페이지 벗어날 때 배경 음악 정지
    _audioPlayer.dispose(); // 오디오 플레이어 리소스 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.transparent,
        middle: Text(
          contentTitle ?? 'Loading...',
          style: const TextStyle(
            color: CupertinoColors.systemIndigo,
            fontFamily: 'cookierun',
            fontSize: 28, // 텍스트 크기 증가
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            CupertinoIcons.back,
            color: CupertinoColors.systemIndigo,
            size: 40, // 아이콘 크기 증가
          ),
        ),
      ),
      child: Stack(
        children: [
          // 배경 이미지 설정
          if (backgroundUrl != null && backgroundUrl!.isNotEmpty)
            Positioned.fill(
              child: Image.asset(
                backgroundUrl!,
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              color: Colors.white, // 기본 배경색 설정
            ),
          modelUrl != null && modelUrl!.isNotEmpty
              ? ModelViewer(
                  backgroundColor: Colors.transparent,
                  src: modelUrl!,
                  alt: contentTitle ?? 'A 3D model of a toy',
                  ar: false,
                  autoRotate: true,
                  autoPlay: true,
                  animationName: 'worldAction',
                  iosSrc:
                      'https://modelviewer.dev/shared-assets/models/Astronaut.usdz',
                  disableZoom: false,
                )
              : const Center(
                  child: Text(
                    '3D 모델을 불러올 수 없습니다.',
                    style: TextStyle(
                      fontFamily: 'cookierun',
                      fontSize: 22, // 폰트 크기 증가
                    ),
                  ),
                ),
          Positioned(
            bottom: 80,
            right: 30,
            child: CupertinoButton(
              color: CupertinoColors.systemIndigo,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              borderRadius: BorderRadius.circular(30),
              onPressed: () async {
                final result = await showCupertinoDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return const DownloadSTLDialog();
                  },
                );

                if (result == true && stlUrl != null) {
                  await URLLauncher.openURL(context, stlUrl!);
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(CupertinoIcons.cloud_download,
                      color: CupertinoColors.white, size: 24),
                  SizedBox(width: 8),
                  Text(
                    '3D 프린트용 파일 다운로드',
                    style: TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 20,
                      fontFamily: 'cookierun',
                    ),
                  ),
                ],
              ),
            ),
          ),
          // BGM On/Off 버튼 추가
          Positioned(
            bottom: 150,
            right: 30,
            child: CupertinoButton(
              color: isPlaying
                  ? CupertinoColors.systemRed
                  : CupertinoColors.systemGreen,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              borderRadius: BorderRadius.circular(30),
              onPressed: toggleBgm,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPlaying
                        ? CupertinoIcons.pause
                        : CupertinoIcons.play_arrow_solid,
                    color: CupertinoColors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isPlaying ? 'BGM 끄기' : 'BGM 켜기',
                    style: const TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 20,
                      fontFamily: 'cookierun',
                    ),
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
