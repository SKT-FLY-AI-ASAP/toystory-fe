import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:toystory/widget/sending_3D_dialog.dart';
import 'package:flutter/cupertino.dart';

class My3DModel extends StatelessWidget {
  const My3DModel({super.key});

  void _sendTo3DPrinter(BuildContext context) {
    // Show the sending 3D dialog when the share icon is clicked
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return const Sending3DDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('3D Model Viewer'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(CupertinoIcons.back),
        ),
        trailing: GestureDetector(
          onTap: () {
            _sendTo3DPrinter(context);
          },
          child: Icon(CupertinoIcons.share),
        ),
      ),
      child: const ModelViewer(
        backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
        src: 'assets/glb/white_bear.glb',
        alt: 'A 3D model of a white bear',
        ar: true,
        autoRotate: true,
        iosSrc: 'https://modelviewer.dev/shared-assets/models/Astronaut.usdz',
        disableZoom: true,
      ),
    );
  }
}
