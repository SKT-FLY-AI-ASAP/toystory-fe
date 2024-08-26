import 'package:flutter/cupertino.dart';
import 'package:toystory/widget/reusable_dialog.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:toystory/services/api_service.dart';

class MagicDialog extends StatefulWidget {
  const MagicDialog({Key? key}) : super(key: key);

  @override
  _MagicDialogState createState() => _MagicDialogState();
}

class _MagicDialogState extends State<MagicDialog> {
  late stt.SpeechToText _speechToText;
  bool _isListening = false;
  String _recognizedText = "여기에 음성 인식된 텍스트가 표시됩니다.";
  String _finalRecognizedText = ""; // 최종 녹음된 텍스트를 저장
  TextEditingController _titleController =
      TextEditingController(); // title 입력을 위한 컨트롤러

  @override
  void initState() {
    super.initState();
    _speechToText = stt.SpeechToText();
  }

  void _toggleListening() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() {
          _isListening = true;
          _recognizedText = "듣고 있어요...";
        });
        _speechToText.listen(
          onResult: (result) {
            setState(() {
              _recognizedText = result.recognizedWords;
              _finalRecognizedText = result.recognizedWords; // 최종 텍스트 저장
            });
          },
          localeId: 'ko_KR', // 한국어로 설정
        );
      }
    } else {
      setState(() {
        _isListening = false;
        _speechToText.stop(); // 녹음이 끝난 후 stop 호출
      });
    }
  }

  Future<void> _createToy(BuildContext context) async {
    String title = _titleController.text.isNotEmpty
        ? _titleController.text
        : "기본 제목"; // 사용자가 title 입력을 안했을 경우 기본 제목 사용

    try {
      // 로딩 다이얼로그 표시
      showCupertinoDialog(
        context: context,
        barrierDismissible: false, // 다이얼로그 밖을 클릭해도 닫히지 않게
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('3D 변환중'),
            content: Column(
              children: const [
                SizedBox(height: 16),
                CupertinoActivityIndicator(radius: 20), // 로딩 인디케이터
                SizedBox(height: 16),
                Text('3D 변환 중입니다...'),
              ],
            ),
          );
        },
      );

      // 장난감 만들기 API 호출
      final response = await ApiService().createStt(
        title: title, // 사용자가 입력한 title 사용
        prompt: _finalRecognizedText.isNotEmpty
            ? _finalRecognizedText
            : "기본 프롬프트", // 녹음된 텍스트를 프롬프트로 사용
      );

      // 로딩 다이얼로그 닫기
      Navigator.of(context).pop();

      // 성공 다이얼로그 표시
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('3D 변환 성공'),
            content: const Text('장난감 변환이 완료되었습니다!'),
            actions: [
              CupertinoDialogAction(
                child: const Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      // 로딩 다이얼로그 닫기
      Navigator.of(context).pop();

      // 실패 다이얼로그 표시
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('3D 변환 실패'),
            content: const Text('장난감 변환에 실패했습니다. 다시 시도해주세요.'),
            actions: [
              CupertinoDialogAction(
                child: const Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReusableDialog(
      title: '주문 외우기',
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '무한한 공간 저 너머로 주문을 전달하는 중 ...',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.black,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 500,
            height: 100,
            color: CupertinoColors.white,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            child: Text(
              _recognizedText,
              style: const TextStyle(
                color: CupertinoColors.black,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _toggleListening,
            child: Icon(
              _isListening
                  ? CupertinoIcons.stop_circle
                  : CupertinoIcons.mic_circle,
              size: 70,
              color: CupertinoColors.systemIndigo,
            ),
          ),
          const SizedBox(height: 20),
          if (!_isListening && _finalRecognizedText.isNotEmpty)
            // 녹음이 끝나면 최종 텍스트를 표시
            Text(
              '최종 녹음된 텍스트: $_finalRecognizedText',
              style: const TextStyle(
                fontSize: 18,
                color: CupertinoColors.systemGrey,
              ),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 20),
          // 제목 입력 필드 추가
          CupertinoTextField(
            controller: _titleController,
            placeholder: "제목을 입력하세요",
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          const SizedBox(height: 20),
          CupertinoButton(
            color: CupertinoColors.systemIndigo, // 배경 색 지정
            onPressed: () {
              // 그림 만들기 API 호출
              _createToy(context);
            },
            child: const Text(
              '그림 만들기',
              style: TextStyle(
                color: CupertinoColors.white, // 텍스트 색상도 설정 가능
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showMagicDialog(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (context) => const MagicDialog(),
  );
}
