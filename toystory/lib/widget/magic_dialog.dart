import 'package:flutter/cupertino.dart';
import 'package:toystory/widget/reusable_dialog.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

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

  @override
  Widget build(BuildContext context) {
    return ReusableDialog(
      title: '주문 외우기',
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '무한한 공간 저 너머로 주문을 전달하는 중 ...',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.black,
            ),
          ),
          const SizedBox(height: 30),
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
          const SizedBox(height: 30),
          GestureDetector(
            onTap: _toggleListening,
            child: Icon(
              _isListening
                  ? CupertinoIcons.stop_circle
                  : CupertinoIcons.mic_circle,
              size: 150,
              color: const Color.fromARGB(255, 54, 23, 206),
            ),
          ),
          const SizedBox(height: 30),
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
          const SizedBox(height: 30),
          CupertinoButton(
            onPressed: () {
              // 그림 만들기 로직 추가
            },
            child: const Text('그림 만들기'),
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
