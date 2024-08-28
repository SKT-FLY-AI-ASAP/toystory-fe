import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ReusableDialog extends StatelessWidget {
  final String title;
  final Widget content;

  const ReusableDialog({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13.0), // Rounded dialog corners
      ),
      backgroundColor: Colors.white, // Dialog background color
      child: Stack(
        children: [
          Container(
            width: 540, // Dialog width
            height: 620, // Dialog height
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 25,
                    //fontWeight: FontWeight.bold,
                    fontFamily: 'cookierun', // Font family
                    color: CupertinoColors.systemIndigo, // Text color
                  ),
                ),
                const Divider(
                  thickness: 1.0,
                  color: Color.fromRGBO(200, 200, 200, 0.6),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: DefaultTextStyle(
                      style: const TextStyle(
                          //fontFamily: 'crayon', // Default font for content
                          ),
                      child: content,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Close button at the top right
          Positioned(
            right: 10,
            top: 10,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Icon(
                Icons.close,
                color: Colors.black,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
