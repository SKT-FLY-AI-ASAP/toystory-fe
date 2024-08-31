import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';
import 'package:value_notifier_tools/value_notifier_tools.dart';
import 'package:toystory/widget/title_input_dialog.dart';
import 'package:toystory/services/api_service.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui; // Import dart:ui for image manipulation
import 'dart:async'; // Import dart:async for Completer
import 'package:path_provider/path_provider.dart';
import 'home_page.dart';

class DrawPage extends StatefulWidget {
  const DrawPage({super.key});

  @override
  State<DrawPage> createState() => _DrawPageState();
}

class _DrawPageState extends State<DrawPage> {
  late ScribbleNotifier notifier;
  String _title = "";

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
          children: _buildActions(),
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
                  _buildColorToolbar(),
                  const VerticalDivider(width: 32),
                  _buildStrokeToolbar(),
                  const Expanded(child: SizedBox()),
                  _buildPointerModeSwitcher(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActions() {
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
        onPressed: _handleTitleInput,
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
    final result = await showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return TitleInputDialog(
          onTitleSaved: (title) {
            Navigator.of(context).pop(title);
          },
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _title = result;
      });
      await _saveSketch();
    }
  }

  Future<void> _saveSketch() async {
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

    try {
      // Step 1: Render the transparent image
      final ByteData? imageData = await notifier.renderImage();
      if (imageData == null) {
        throw Exception('Failed to render the image.');
      }

      // Convert ByteData to ui.Image
      final ui.Image originalImage = await _loadImage(imageData);

      // Step 2: Create a white background image with the same size
      final ui.Image whiteBackgroundImage = await _createWhiteBackgroundImage(
          originalImage.width, originalImage.height);

      // Step 3: Combine the white background and the original image
      final ui.Image combinedImage =
          await _combineImages(whiteBackgroundImage, originalImage);

      // Convert the combined image to PNG
      final ByteData? combinedByteData =
          await combinedImage.toByteData(format: ui.ImageByteFormat.png);
      if (combinedByteData != null) {
        final Uint8List imageBytes = combinedByteData.buffer.asUint8List();
        final savedFile = await _saveImageToFile(imageBytes);

        if (savedFile != null) {
          await ApiService().createSketchbook(
            title: _title,
            file: savedFile,
          );

          Navigator.of(context).pop();
          await _showSaveSuccessDialog();
        } else {
          throw Exception('Failed to save the image file.');
        }
      } else {
        throw Exception('Failed to convert the combined image.');
      }
    } catch (e) {
      Navigator.of(context).pop();
      await _showSaveFailureDialog();
      print("Error during saving: $e");
    }
  }

  // Helper method to convert ByteData to ui.Image
  Future<ui.Image> _loadImage(ByteData byteData) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(byteData.buffer.asUint8List(), (ui.Image img) {
      completer.complete(img);
    });
    return completer.future;
  }

  // Helper method to create a white background image
  Future<ui.Image> _createWhiteBackgroundImage(int width, int height) async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(
        recorder, Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()));
    final Paint paint = Paint()..color = Colors.white;
    canvas.drawRect(
        Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), paint);
    final ui.Picture picture = recorder.endRecording();
    return picture.toImage(width, height);
  }

  // Helper method to combine the background and original images
  Future<ui.Image> _combineImages(
      ui.Image background, ui.Image foreground) async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(
        recorder,
        Rect.fromLTWH(
            0, 0, background.width.toDouble(), background.height.toDouble()));
    canvas.drawImage(background, Offset.zero, Paint());
    canvas.drawImage(foreground, Offset.zero, Paint());
    final ui.Picture picture = recorder.endRecording();
    return picture.toImage(background.width, background.height);
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildStrokeToolbar() {
    return ValueListenableBuilder<ScribbleState>(
      valueListenable: notifier,
      builder: (context, state, _) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (final w in notifier.widths)
            _buildStrokeButton(
              strokeWidth: w,
              state: state,
            ),
        ],
      ),
    );
  }

  Widget _buildStrokeButton({
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

  Widget _buildColorToolbar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildColorButton(color: CupertinoColors.black),
        _buildColorButton(color: CupertinoColors.systemRed),
        _buildColorButton(color: CupertinoColors.systemGreen),
        _buildColorButton(color: CupertinoColors.systemBlue),
        _buildColorButton(color: CupertinoColors.systemYellow),
        _buildColorButton(color: CupertinoColors.systemPink),
        _buildColorButton(color: CupertinoColors.systemPurple),
        _buildColorButton(color: CupertinoColors.systemTeal),
        _buildColorButton(color: CupertinoColors.systemOrange),
        _buildEraserButton(),
      ],
    );
  }

  Widget _buildEraserButton() {
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

  Widget _buildPointerModeSwitcher() {
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

  Widget _buildColorButton({
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
