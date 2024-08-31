import 'package:flutter/cupertino.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class TitleInputDialog extends StatefulWidget {
  final Function(String) onTitleSaved;

  const TitleInputDialog({required this.onTitleSaved, Key? key})
      : super(key: key);

  @override
  _TitleInputDialogState createState() => _TitleInputDialogState();
}

class _TitleInputDialogState extends State<TitleInputDialog> {
  late stt.SpeechToText _speechToText;
  bool _isListening = false;
  String _recognizedText = "여기에 음성 인식된 제목이 표시됩니다."; // 음성 인식된 텍스트 표시
  String _finalRecognizedText = ""; // 최종 녹음된 텍스트 저장

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
          _finalRecognizedText = ""; // 녹음 시작 시 이전 텍스트 초기화
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
        _speechToText.stop(); // 녹음 중지
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text(
        '그림의 제목을 말해줘!',
        style: TextStyle(
          fontFamily: 'cookierun',
          color: CupertinoColors.systemIndigo,
          fontSize: 22.0,
        ),
      ),
      content: Column(
        children: [
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _toggleListening, // Listening toggle
            child: Icon(
              _isListening
                  ? CupertinoIcons.stop_circle
                  : CupertinoIcons.mic_circle,
              size: 70,
              color: CupertinoColors.systemIndigo,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _recognizedText,
            style: const TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 18,
              fontFamily: 'cookierun',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          if (!_isListening && _finalRecognizedText.isNotEmpty)
            Text(
              '최종 제목: $_finalRecognizedText',
              style: const TextStyle(
                fontSize: 18,
                color: CupertinoColors.systemIndigo,
                fontFamily: 'cookierun',
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
      actions: [
        CupertinoDialogAction(
          child: const Text('저장'),
          onPressed: () {
            widget.onTitleSaved(_finalRecognizedText); // 저장된 제목 전달
            Navigator.of(context).pop(); // 다이얼로그 닫기
          },
        ),
        CupertinoDialogAction(
          child: const Text('취소'),
          onPressed: () {
            Navigator.of(context).pop(); // 다이얼로그 닫기
          },
        ),
      ],
    );
  }
}
