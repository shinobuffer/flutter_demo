import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/learning/question_bank/component/question_bank_page_view.dart';
import 'package:flutter_demo/utils/style_util.dart';

class QuestionBankPage extends StatefulWidget {
  QuestionBankPage({Key key}) : super(key: key);

  @override
  _QuestionBankPageState createState() => _QuestionBankPageState();
}

class _QuestionBankPageState extends State<QuestionBankPage> {
  TabController _controller;

  // todo: 获取预设科目
  Map<int, String> subjectMap = {0: '政治', 1: '英语', 11: '计算机'};

  List<int> get subjectKeys => subjectMap.keys.toList();

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: subjectKeys.length,
      vsync: ScrollableState(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('题库'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.playlist_add_rounded,
            ),
            onPressed: () {
              // todo: 修改学科
            },
          )
        ],
        // 魔改TabBar的高度和背景
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(32),
          child: Container(
            width: double.maxFinite,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                )
              ],
            ),
            child: Material(
              color: Colors.white,
              child: TabBar(
                labelColor: ColorM.C7,
                isScrollable: true,
                controller: _controller,
                tabs: subjectKeys
                    .map(
                      (e) => Container(
                        alignment: Alignment.center,
                        height: 32,
                        child: Text(subjectMap[e]),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: subjectKeys
            .map(
              (e) => QuestionBankPageView(
                subjectId: e,
                subject: subjectMap[e],
              ),
            )
            .toList(),
      ),
    );
  }
}
