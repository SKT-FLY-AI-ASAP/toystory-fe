import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:toystory/widget/download_stl_dialog.dart';
import 'package:toystory/services/stl_downloader.dart';
import 'package:toystory/services/api_service.dart';

class My3DModel extends StatefulWidget {
  final int contentId;

  const My3DModel({super.key, required this.contentId});

  @override
  _My3DModelState createState() => _My3DModelState();
}

class _My3DModelState extends State<My3DModel> {
  String? modelUrlWithBackground;
  String? modelUrlWithoutBackground;
  String? stlUrl;
  String? contentTitle;
  bool showBackground = true;

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
        stlUrl = response['design_url'];
        contentTitle = response['content_title'];
        modelUrlWithBackground = 'assets/glb/5.glb';
        modelUrlWithoutBackground = 'assets/glb/5.glb';
      });
    } catch (e) {
      print('3D 모델 데이터 로드 실패: $e');
      setState(() {
        modelUrlWithBackground = 'assets/glb/5.glb';
        modelUrlWithoutBackground = 'assets/glb/5.glb';
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
        //backgroundColor: CupertinoColors.systemIndigo.withOpacity(0.3),
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
                  child: Text(
                    '3D 모델을 불러올 수 없습니다.',
                    style: TextStyle(
                      fontFamily: 'cookierun',
                      fontSize: 22, // 폰트 크기 증가
                    ),
                  ),
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
                      color: CupertinoColors.white, size: 24), // 아이콘 크기 증가
                  SizedBox(width: 8),
                  Text(
                    '3D 프린트용 파일 다운로드',
                    style: TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 20, // 텍스트 크기 증가
                      fontFamily: 'cookierun',
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
                true: Text(
                  '배경 있음',
                  style: TextStyle(
                    fontFamily: 'cookierun',
                    fontSize: 26, // 텍스트 크기 증가
                  ),
                ),
                false: Text(
                  '배경 없음',
                  style: TextStyle(
                    fontFamily: 'cookierun',
                    fontSize: 26, // 텍스트 크기 증가
                  ),
                ),
              },
              onValueChanged: (bool value) {
                setState(() {
                  showBackground = value; // 사용자 선택에 따라 배경 상태 변경
                });
              },
              groupValue: showBackground,
              selectedColor: CupertinoColors.systemIndigo,
              unselectedColor: CupertinoColors.white,
              borderColor: CupertinoColors.systemIndigo,
            ),
          ),
        ],
      ),
    );
  }
}
