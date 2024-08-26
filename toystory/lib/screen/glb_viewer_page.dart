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
  String? modelUrlWithBackground;
  String? modelUrlWithoutBackground;
  String? stlUrl;
  String? contentTitle;
  bool showBackground = true; // 배경 표시 여부를 위한 상태 변수

  @override
  void initState() {
    super.initState();
    fetch3DModelData();
  }

  Future<void> fetch3DModelData() async {
    try {
      final response =
          await ApiService().fetch3DItemDetails(contentId: widget.contentId);
      setState(() {
        modelUrlWithBackground =
            response['content_url_with_bg']; // 배경이 있는 GLB 파일
        modelUrlWithoutBackground =
            response['content_url_without_bg']; // 배경 없는 GLB 파일
        stlUrl = response['design_url'];
        contentTitle = response['content_title'];
      });
    } catch (e) {
      print('3D 모델 데이터 로드 실패: $e');
      setState(() {
        modelUrlWithBackground = null;
        modelUrlWithoutBackground = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 배경 유무에 따라 해당하는 모델 URL을 선택
    final modelUrl =
        showBackground ? modelUrlWithBackground : modelUrlWithoutBackground;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemIndigo.withOpacity(0.3),
        middle: Text(
          contentTitle ?? 'Loading...',
          style: const TextStyle(color: CupertinoColors.white),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            CupertinoIcons.back,
            color: CupertinoColors.white,
          ),
        ),
      ),
      child: Stack(
        children: [
          modelUrl != null && modelUrl!.isNotEmpty
              ? ModelViewer(
                  backgroundColor: Colors.transparent,
                  src: modelUrl!,
                  alt: contentTitle ?? 'A 3D model of a toy',
                  ar: true,
                  autoRotate: true,
                  iosSrc:
                      'https://modelviewer.dev/shared-assets/models/Astronaut.usdz',
                  disableZoom: false,
                )
              : const Center(
                  child: Text('3D 모델을 불러올 수 없습니다.'),
                ),
          Positioned(
            bottom: 80, // 세그먼트 컨트롤러 위에 배치되도록 버튼을 위로 이동
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
                      color: CupertinoColors.white),
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
          Positioned(
            bottom: 30, // 하단에 세그먼트 컨트롤러 배치
            left: 30,
            right: 30,
            child: CupertinoSegmentedControl<bool>(
              children: const {
                true: Text('배경 있음'),
                false: Text('배경 없음'),
              },
              onValueChanged: (bool value) {
                setState(() {
                  showBackground = value; // 사용자 선택에 따라 배경 상태 변경
                });
              },
              groupValue: showBackground,
              selectedColor: CupertinoColors.systemIndigo, // 선택된 색상 설정
              unselectedColor: CupertinoColors.white, // 선택되지 않은 색상 설정
              borderColor: CupertinoColors.systemIndigo, // 테두리 색상 설정
            ),
          ),
        ],
      ),
    );
  }
}
