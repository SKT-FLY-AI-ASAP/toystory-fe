import 'package:flutter/cupertino.dart';
import 'package:toystory/widget/sketch_list_view.dart';
import 'package:toystory/widget/toy_list_view.dart';
import 'package:toystory/widget/sidebar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Sidebar(),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  SketchListView(),
                  SizedBox(height: 40),
                  ToyListView(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
