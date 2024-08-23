import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:toystory/widget/download_stl_dialog.dart';
import 'package:toystory/services/stl_downloader.dart'; // URLLauncher 클래스를 import
import 'package:toystory/services/api_service.dart'; // API Service import

class My3DModel extends StatefulWidget {
  final int contentId; // contentId를 받는 필드 추가

  const My3DModel({super.key, required this.contentId});

  @override
  _My3DModelState createState() => _My3DModelState();
}

class _My3DModelState extends State<My3DModel> {
  String? modelUrl; // GLB 파일의 URL을 저장하는 변수
  String? stlUrl; // STL 파일의 URL을 저장하는 변수
  String? contentTitle; // 모델의 제목을 저장하는 변수

  @override
  void initState() {
    super.initState();
    fetch3DModelData(); // 초기화 시 3D 모델 데이터를 가져옴
  }

  // 3D 모델 데이터를 API에서 받아오는 함수
  Future<void> fetch3DModelData() async {
    try {
      final response =
          await ApiService().fetch3DItemDetails(contentId: widget.contentId);
      setState(() {
        modelUrl = response['content_url']; // 모델의 GLB URL
        stlUrl = response['design_url']; // STL 파일의 다운로드 URL
        contentTitle = response['content_title']; // 모델의 제목
      });
    } catch (e) {
      print('3D 모델 데이터 로드 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemIndigo.withOpacity(0.3),
        middle: Text(contentTitle ?? 'Loading...',
            style: TextStyle(color: CupertinoColors.white)), // 모델 제목 표시
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            CupertinoIcons.back,
            color: CupertinoColors.white, // 뒤로가기 버튼 색상 변경
          ),
        ),
      ),
      child: Stack(
        children: [
          // 모델 뷰어
          modelUrl != null
              ? ModelViewer(
                  backgroundColor: const Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
                  src: modelUrl!, // 동적으로 받아온 모델 URL 적용
                  //src: 'assets/obj/임지혜.glb',
                  alt: contentTitle ?? 'A 3D model of a toy', // 모델 제목 표시
                  ar: true,
                  autoRotate: true,
                  iosSrc:
                      'https://modelviewer.dev/shared-assets/models/Astronaut.usdz',
                  disableZoom: false,
                )
              : const Center(
                  child: CupertinoActivityIndicator(),
                ),
          // Floating Action Button
          Positioned(
            bottom: 30,
            right: 30,
            child: CupertinoButton(
              color: CupertinoColors.systemIndigo,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              borderRadius: BorderRadius.circular(30),
              onPressed: () async {
                // STL 파일 다운로드 확인 다이얼로그 표시
                final result = await showCupertinoDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return const DownloadSTLDialog(); // 다운로드 확인을 위한 커스텀 다이얼로그
                  },
                );

                if (result == true && stlUrl != null) {
                  // STL 파일 다운로드 시작
                  await URLLauncher.openURL(
                      context, stlUrl!); // Safari로 STL 파일 다운로드 URL 열기
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(CupertinoIcons.cloud_download,
                      color: CupertinoColors.white), // 다운로드 아이콘 추가
                  SizedBox(width: 8),
                  Text(
                    '3D 프린트용 파일 다운로드',
                    style: TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 16,
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
