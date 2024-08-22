import 'package:flutter/cupertino.dart';
import 'package:toystory/widget/settings_button.dart';
import 'package:toystory/widget/magic_dialog.dart';
import 'package:toystory/services/api_service.dart';

class MagicItems {
  final int contentId;
  final String contentTitle;
  final String contentUrl;

  MagicItems({
    required this.contentId,
    required this.contentTitle,
    required this.contentUrl,
  });

  // Factory constructor for creating a new MagicItems instance from a map
  factory MagicItems.fromJson(Map<String, dynamic> json) {
    return MagicItems(
      contentId: json['content_id'],
      contentTitle: json['content_title'],
      contentUrl: json['content_url'],
    );
  }
}

class TrashPage extends StatefulWidget {
  const TrashPage({Key? key}) : super(key: key);

  @override
  _TrashPageState createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  List<MagicItems> magicItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMagicItems();
  }

  Future<void> fetchMagicItems() async {
    try {
      final response = await ApiService().fetchMagicItems();
      setState(() {
        magicItems = (response['data'] as List)
            .map<MagicItems>((json) => MagicItems.fromJson(json))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: const Color.fromARGB(18, 54, 23, 206),
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.white,
            width: 0.0,
          ),
        ),
        middle: Text(
          '주문 외우기',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: CupertinoColors.systemGrey,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                debugPrint('휴지통 페이지의 휴지통 버튼 눌림');
              },
              child: Icon(
                CupertinoIcons.trash,
                color: Color.fromARGB(255, 54, 23, 206),
                size: 22.0,
              ),
            ),
            SizedBox(width: 8),
            SettingsButton(),
          ],
        ),
      ),
      child: isLoading
          ? Center(child: CupertinoActivityIndicator())
          : buildGridView(screenWidth),
    );
  }

  Widget buildGridView(double screenWidth) {
    return Column(
      children: [
        SizedBox(height: 16),
        Expanded(
          child: Container(
            color: CupertinoColors.systemGrey5,
            child: SafeArea(
              child: GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: magicItems.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return buildNewItem(screenWidth);
                  } else {
                    final content = magicItems[index - 1];
                    return buildMagicItem(content, screenWidth);
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildNewItem(double screenWidth) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              showMagicDialog(context);
            },
            child: Container(
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey,
                borderRadius: BorderRadius.circular(10),
              ),
              width: screenWidth / 6,
              child: Center(
                child: Icon(
                  CupertinoIcons.star,
                  size: 40,
                  color: CupertinoColors.white,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          '새로 만들기',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: CupertinoColors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget buildMagicItem(MagicItems content, double screenWidth) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              debugPrint('휴지통 아이템 ${content.contentId} 클릭됨');
            },
            child: Container(
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  content.contentUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          content.contentTitle,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: CupertinoColors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
