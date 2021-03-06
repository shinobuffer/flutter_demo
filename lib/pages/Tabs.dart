import 'package:flutter/material.dart';
import 'learning/question_bank/do_question_page.dart';

class HomeTabs extends StatefulWidget {
  HomeTabs({Key key}) : super(key: key);

  @override
  _HomeTabsState createState() => _HomeTabsState();
}

class _HomeTabsState extends State<HomeTabs> {
  final List<Map> tabItems = [
    {
      'icon': Icons.menu_book_rounded,
      'label': '学习',
    },
    {
      'icon': Icons.explore,
      'label': '发现',
    },
    {
      'icon': Icons.account_circle_rounded,
      'label': '我的',
    },
  ];
  int curIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: curIndex,
      fixedColor: Color(0xff5abebc),
      items: tabItems
          .map((e) =>
              BottomNavigationBarItem(icon: Icon(e['icon']), label: e['label']))
          .toList(),
      onTap: (index) {
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DoQuestionPage(
                tId: 233,
              ),
            ),
          );
        }
        setState(() {
          curIndex = index;
        });
      },
    );
  }
}
