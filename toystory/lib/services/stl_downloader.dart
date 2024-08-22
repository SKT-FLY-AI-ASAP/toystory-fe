import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

//https://asap-bucket.s3.ap-northeast-2.amazonaws.com/3d-contents/1-stl/best_bear.stl

class STLDownloader {
  // STL 파일 다운로드 함수
  static Future<void> downloadSTL(
      BuildContext context, String contentId) async {
    final String fileUrl =
        'https://asap-bucket.s3.ap-northeast-2.amazonaws.com/3d-contents/1-stl/best_bear.stl'; // S3 링크
    final String fileName = '$contentId.stl'; // 저장할 파일 이름

    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = "${directory.path}/$fileName";

      final response = await http.get(Uri.parse(fileUrl));

      if (response.statusCode == 200) {
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // 성공 시 다운로드 완료 다이얼로그 표시
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text('파일 다운로드 완료'),
              content: Text('파일이 성공적으로 다운로드되었습니다: $filePath'),
              actions: [
                CupertinoDialogAction(
                  child: const Text('확인'),
                  onPressed: () {
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                  },
                ),
              ],
            );
          },
        );
      } else {
        throw Exception('파일 다운로드 실패');
      }
    } catch (e) {
      // 에러 시 에러 다이얼로그 표시
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('에러'),
            content: Text('파일 다운로드 중 문제가 발생했습니다: $e'),
            actions: [
              CupertinoDialogAction(
                child: const Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
              ),
            ],
          );
        },
      );
    }
  }
}
