import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';
import 'package:value_notifier_tools/value_notifier_tools.dart';
import 'package:toystory/widget/title_input_dialog.dart';
import 'package:toystory/services/api_service.dart'; // Your API service
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'home_page.dart';

class DrawPage extends StatefulWidget {
  const DrawPage({super.key});

  @override
  State<DrawPage> createState() => _DrawPageState();
}

class _DrawPageState extends State<DrawPage> {
  late ScribbleNotifier notifier;
  String _title = ""; // Title entered by the user

  @override
  void initState() {
    super.initState();
    notifier = ScribbleNotifier();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGrey6,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: const Color.fromARGB(18, 54, 23, 206),
        middle: const Text(
          '너만의 상상을 펼쳐봐!',
          style: TextStyle(
            fontFamily: 'cookierun',
            color: CupertinoColors.systemIndigo,
            fontSize: 22.0,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: _buildActions(context),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 64),
        child: Column(
          children: [
            Expanded(
              child: Card(
                clipBehavior: Clip.hardEdge,
                margin: EdgeInsets.zero,
                color: CupertinoColors.white,
                child: Scribble(
                  notifier: notifier,
                  drawPen: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildColorToolbar(context),
                  const VerticalDivider(width: 32),
                  _buildStrokeToolbar(context),
                  const Expanded(child: SizedBox()),
                  _buildPointerModeSwitcher(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      ValueListenableBuilder(
        valueListenable: notifier,
        builder: (context, value, child) => CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: notifier.canUndo ? notifier.undo : null,
          child: const Icon(CupertinoIcons.arrow_turn_up_left,
              color: CupertinoColors.systemIndigo),
        ),
      ),
      ValueListenableBuilder(
        valueListenable: notifier,
        builder: (context, value, child) => CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: notifier.canRedo ? notifier.redo : null,
          child: const Icon(CupertinoIcons.arrow_turn_up_right,
              color: CupertinoColors.systemIndigo),
        ),
      ),
      CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: notifier.clear,
        child: const Icon(CupertinoIcons.clear,
            color: CupertinoColors.systemIndigo),
      ),
      CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: _handleTitleInput, // Handle title input button press
        child: Text(
          '제목 입력 및 저장',
          style: TextStyle(
              color: CupertinoColors.systemIndigo,
              fontFamily: 'cookierun',
              fontWeight: FontWeight.bold),
        ),
      ),
    ];
  }

  Future<void> _handleTitleInput() async {
    // Show TitleInputDialog and handle the title input
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return TitleInputDialog(
          onTitleSaved: (result) {
            setState(() {
              _title = result; // Save title
            });
            Navigator.of(context).pop(); // Close the dialog
            _saveSketch(); // Save the sketch after title is set
          },
        );
      },
    );
  }

  Future<void> _saveSketch() async {
    // Show "Saving" dialog
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const CupertinoAlertDialog(
          title: Text('저장 중...'),
          content: Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: CupertinoActivityIndicator(radius: 15),
          ),
        );
      },
    );

    // Render the image from Scribble
    final ByteData? imageData = await notifier.renderImage();
    if (imageData != null) {
      final Uint8List imageBytes = imageData.buffer.asUint8List();
      final savedFile = await _saveImageToFile(imageBytes);

      if (savedFile != null) {
        try {
          // Call the API to create the sketchbook with title and image
          await ApiService().createSketchbook(
            title: _title,
            file: savedFile,
          );

          Navigator.of(context).pop(); // Close the saving dialog

          // Show success dialog
          await _showSaveSuccessDialog();
        } catch (e) {
          Navigator.of(context).pop(); // Close the saving dialog
          // Show failure dialog
          await _showSaveFailureDialog();
          print("Error during saving: $e");
        }
      }
    } else {
      Navigator.of(context).pop(); // Close the saving dialog
      await _showSaveFailureDialog(); // Show failure dialog
      print("Error: Failed to render the image.");
    }
  }

  Future<File?> _saveImageToFile(Uint8List imageBytes) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath =
          '${directory.path}/sketchbook_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(filePath);

      await file.writeAsBytes(imageBytes);
      return file;
    } catch (e) {
      print('이미지 파일 저장 실패: $e');
      return null;
    }
  }

  Future<void> _showSaveSuccessDialog() async {
    await showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('저장 성공'),
          content: const Text('스케치북이 성공적으로 생성되었습니다.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => HomePage(), // Navigate to HomePage
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSaveFailureDialog() async {
    await showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('저장 실패'),
          content: const Text('스케치북 저장에 실패하였습니다. 다시 시도해주세요.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  ///////////////////////////

  Widget _buildStrokeToolbar(BuildContext context) {
    return ValueListenableBuilder<ScribbleState>(
      valueListenable: notifier,
      builder: (context, state, _) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (final w in notifier.widths)
            _buildStrokeButton(
              context,
              strokeWidth: w,
              state: state,
            ),
        ],
      ),
    );
  }

  Widget _buildStrokeButton(
    BuildContext context, {
    required double strokeWidth,
    required ScribbleState state,
  }) {
    final selected = state.selectedWidth == strokeWidth;
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        elevation: selected ? 4 : 0,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: () => notifier.setStrokeWidth(strokeWidth),
          customBorder: const CircleBorder(),
          child: AnimatedContainer(
            duration: kThemeAnimationDuration,
            width: strokeWidth * 2,
            height: strokeWidth * 2,
            decoration: BoxDecoration(
              color: state.map(
                drawing: (s) => Color(s.selectedColor),
                erasing: (_) => Colors.transparent,
              ),
              border: state.map(
                drawing: (_) => null,
                erasing: (_) => Border.all(width: 1),
              ),
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorToolbar(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildColorButton(context, color: CupertinoColors.black),
        _buildColorButton(context, color: CupertinoColors.systemRed),
        _buildColorButton(context, color: CupertinoColors.systemGreen),
        _buildColorButton(context, color: CupertinoColors.systemBlue),
        _buildColorButton(context, color: CupertinoColors.systemYellow),
        _buildColorButton(context, color: CupertinoColors.systemPink),
        _buildColorButton(context, color: CupertinoColors.systemPurple),
        _buildColorButton(context, color: CupertinoColors.systemTeal),
        _buildColorButton(context, color: CupertinoColors.systemOrange),
        _buildEraserButton(context),
      ],
    );
  }

  Widget _buildEraserButton(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifier.select((value) => value is Erasing),
      builder: (context, isErasing, child) => ColorButton(
        color: Colors.transparent,
        outlineColor: Colors.black,
        isActive: isErasing,
        onPressed: () => notifier.setEraser(),
        child: const Icon(
          Icons.cleaning_services,
          color: CupertinoColors.systemIndigo,
        ),
      ),
    );
  }

  Widget _buildPointerModeSwitcher(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifier.select((value) => value.allowedPointersMode),
      builder: (context, value, child) {
        return CupertinoSegmentedControl<ScribblePointerMode>(
          groupValue: value,
          onValueChanged: (v) => notifier.setAllowedPointersMode(v),
          children: const {
            ScribblePointerMode.all: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(CupertinoIcons.hand_draw),
            ),
            ScribblePointerMode.penOnly: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(CupertinoIcons.pencil),
            ),
          },
        );
      },
    );
  }

  Widget _buildColorButton(
    BuildContext context, {
    required Color color,
  }) {
    return ValueListenableBuilder(
      valueListenable: notifier.select(
          (value) => value is Drawing && value.selectedColor == color.value),
      builder: (context, isSelected, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ColorButton(
          color: color,
          isActive: isSelected,
          onPressed: () => notifier.setColor(color),
        ),
      ),
    );
  }
}

class ColorButton extends StatelessWidget {
  const ColorButton({
    required this.color,
    required this.isActive,
    required this.onPressed,
    this.outlineColor,
    this.child,
    super.key,
  });

  final Color color;
  final Color? outlineColor;
  final bool isActive;
  final VoidCallback onPressed;
  final Icon? child;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: kThemeAnimationDuration,
      decoration: ShapeDecoration(
        shape: CircleBorder(
          side: BorderSide(
            color: isActive ? outlineColor ?? color : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: child ??
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
      ),
    );
  }
}
