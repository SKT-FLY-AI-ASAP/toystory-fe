import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';
import 'package:value_notifier_tools/value_notifier_tools.dart';
import 'package:toystory/widget/confirm_3d_dialog.dart';

class DrawPage extends StatefulWidget {
  const DrawPage({super.key, required this.title});

  final String title;

  @override
  State<DrawPage> createState() => _DrawPageState();
}

class _DrawPageState extends State<DrawPage> {
  late ScribbleNotifier notifier;

  @override
  void initState() {
    notifier = ScribbleNotifier();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGrey6,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: const Color.fromARGB(18, 54, 23, 206),
        middle: Text(widget.title),
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
      CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () async {
          // Show the confirm dialog on cube button press
          final result = await showCupertinoDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return const Confirm3DTransformDialog(); // Your custom dialog
            },
          );

          if (result == true) {
            showCupertinoDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: const Text('3D 변환중'),
                  content: Column(
                    children: [
                      const Text('3D 변환 중입니다...'),
                      const SizedBox(height: 16), // 간격 추가
                      Image.asset(
                        'assets/img/loading/3D_loading.png', // 로컬 이미지 경로
                        height: 150, // 이미지 크기
                        width: 150,
                      ),
                    ],
                  ),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text('확인'),
                      onPressed: () {
                        Navigator.of(context).pop(); // 확인 버튼 누를 시 다이얼로그 닫기
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
        child: const Icon(CupertinoIcons.cube),
      ),
      ValueListenableBuilder(
        valueListenable: notifier,
        builder: (context, value, child) => CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: notifier.canUndo ? notifier.undo : null,
          child: const Icon(CupertinoIcons.arrow_turn_up_left),
        ),
      ),
      ValueListenableBuilder(
        valueListenable: notifier,
        builder: (context, value, child) => CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: notifier.canRedo ? notifier.redo : null,
          child: const Icon(CupertinoIcons.arrow_turn_up_right),
        ),
      ),
      CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: notifier.clear,
        child: const Icon(CupertinoIcons.clear),
      ),
    ];
  }

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
                borderRadius: BorderRadius.circular(50.0)),
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
        _buildColorButton(context, color: CupertinoColors.systemPink), // 추가된 색상
        _buildColorButton(context,
            color: CupertinoColors.systemPurple), // 추가된 색상
        _buildColorButton(context, color: CupertinoColors.systemTeal), // 추가된 색상
        _buildColorButton(context,
            color: CupertinoColors.systemOrange), // 추가된 색상
        _buildEraserButton(context), // Add Eraser Button
      ],
    );
  }

  Widget _buildEraserButton(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifier.select((value) => value is Erasing),
      builder: (context, isErasing, child) => ColorButton(
        color: Colors.transparent, // Transparent to indicate eraser
        outlineColor: Colors.black,
        isActive: isErasing,
        onPressed: () => notifier.setEraser(), // Switch to eraser mode
        child: const Icon(Icons.cleaning_services), // Eraser icon
      ),
    );
  }

  Widget _buildPointerModeSwitcher(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: notifier.select(
          (value) => value.allowedPointersMode,
        ),
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
        });
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
          onPressed: () => notifier.setColor(color), // Set the drawing color
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
