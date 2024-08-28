import 'package:flutter/cupertino.dart';
import 'package:toystory/widget/edit_profile_dialog.dart';
import 'package:toystory/widget/production_dialog.dart';
import 'package:toystory/widget/delivery_dialog.dart';
import 'package:toystory/widget/terms_dialog.dart';
import 'package:toystory/services/api_service.dart';
import 'package:toystory/screen/login_page.dart'; // 로그인 페이지 import

class SettingsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        _showSettingsDialog(context);
      },
      child: Icon(
        CupertinoIcons.settings,
        color: const Color.fromARGB(255, 54, 23, 206),
        size: 22.0,
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("설정"),
          content: Text("설정 메뉴에서 무엇을 하시겠습니까?"),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                showEditProfileDialog(context);
              },
              child: Text('개인 정보 수정'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                showProductionDialog(context);
              },
              child: Text('제작 현황 확인'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                showDeliveryDialog(context);
              },
              child: Text('배송 상태 확인'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                showTermsDialog(context);
              },
              child: Text('사용 안내'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                _showLogoutActionSheet(context);
              },
              isDestructiveAction: true,
              child: Text('로그아웃'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutActionSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('로그아웃'),
        message: const Text('로그아웃 시 초기화면으로 돌아갑니다.'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () async {
              try {
                // 로그아웃 API 호출
                await ApiService().logout();

                // 로그아웃 성공 시 LoginPage로 이동
                Navigator.of(context).pushAndRemoveUntil(
                  CupertinoPageRoute(builder: (context) => const LoginPage()),
                  (Route<dynamic> route) => false,
                );
              } catch (e) {
                print('로그아웃 실패: $e');
                // 로그아웃 실패 시 에러 처리 로직 추가 가능
              }
            },
            child: const Text('로그아웃'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('취소'),
        ),
      ),
    );
  }
}
