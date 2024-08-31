import 'package:flutter/cupertino.dart';
import 'package:toystory/widget/reusable_dialog.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:toystory/services/api_service.dart';
import 'package:toystory/screen/home_page.dart';

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
    String title =
        _titleController.text.isNotEmpty ? _titleController.text : "기본 제목";

    try {
      // 로딩 다이얼로그 표시
      showCupertinoDialog(
        context: context,
        barrierDismissible: false, // 다이얼로그 밖을 클릭해도 닫히지 않게
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('장난감이 만들어지는 중 ...'),
            content: Column(
              children: const [
                SizedBox(height: 16),
                CupertinoActivityIndicator(radius: 20), // 로딩 인디케이터
                SizedBox(height: 16),
                Text('장난감을 만들고 있어 \n 조금만 기다려줘'),
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
            title: const Text('장난감 만들기 성공'),
            content: const Text('장난감이 다 만들어졌어 \n 장난감 상자에서 확인해봐!'),
            actions: [
              CupertinoDialogAction(
                child: const Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
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
            title: const Text('장난감 만들기 실패'),
            content: const Text('장난감 만들기에 실패했어 \n 다시 시도해봐!'),
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
      title: '무한한 공간 저 너머로 주문을 전달하는 중...',
      content: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/design/magic_bg.png'), // 배경 이미지 경로 설정
            fit: BoxFit.contain, // 이미지가 꽉 차도록 설정
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '네가 만들고 싶은 장난감이 뭐야?',
              style: TextStyle(
                fontSize: 24,
                //fontWeight: FontWeight.bold,
                color: CupertinoColors.black,
                fontFamily: 'cookierun',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '말하는 대로 만들어줄게~',
              style: TextStyle(
                fontSize: 24,
                //fontWeight: FontWeight.bold,
                color: CupertinoColors.black,
                fontFamily: 'cookierun',
              ),
            ),
            Container(
              width: 500,
              height: 100,
              color: CupertinoColors.transparent,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16),
              child: Text(
                _recognizedText,
                style: const TextStyle(
                  color: CupertinoColors.systemGrey,
                  fontSize: 18,
                  fontFamily: 'cookierun',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
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
            const SizedBox(height: 10),
            if (!_isListening && _finalRecognizedText.isNotEmpty)
              Text(
                '최종 주문: $_finalRecognizedText',
                style: const TextStyle(
                  fontSize: 18,
                  color: CupertinoColors.systemIndigo,
                  fontFamily: 'cookierun',
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 50),
            // 제목 입력 필드 추가
            //Spacer(),
            CupertinoTextField(
              controller: _titleController,
              placeholder: "장난감 이름",
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              prefix: const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  '장난감의 이름을 지어줘! ',
                  style: TextStyle(
                    fontSize: 18,
                    color: CupertinoColors.systemGrey,
                    fontFamily: 'cookierun',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            CupertinoButton(
              color: CupertinoColors.systemIndigo, // 배경 색 지정
              onPressed: () {
                // 그림 만들기 API 호출
                _createToy(context);
              },
              child: const Text(
                '주문외우기',
                style: TextStyle(
                  color: CupertinoColors.white, // 텍스트 색상도 설정 가능
                  fontFamily: 'cookierun',
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
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
