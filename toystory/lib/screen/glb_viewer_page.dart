import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:flutter/cupertino.dart';

class My3DModel extends StatelessWidget {
  const My3DModel({super.key});

  void _sendTo3DPrinter() {
    // Add the functionality for sending to a 3D printer here.
    print('Sending 3D model to printer...');
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
          onTap: _sendTo3DPrinter,
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
