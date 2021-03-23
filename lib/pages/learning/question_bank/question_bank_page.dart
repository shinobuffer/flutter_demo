import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/learning/question_bank/component/question_bank_page_view.dart';
import 'package:flutter_demo/pages/learning/question_bank/component/subject_selector.dart';
import 'package:flutter_demo/utils/dialog_util.dart';
import 'package:flutter_demo/utils/style_util.dart';
import 'package:sp_util/sp_util.dart';

class QuestionBankPage extends StatefulWidget {
  QuestionBankPage({Key key}) : super(key: key);

  @override
  _QuestionBankPageState createState() => _QuestionBankPageState();
}

class _QuestionBankPageState extends State<QuestionBankPage> {
  TabController _controller;

  /// 选择的科目，必须非空，如果第一次使用则初始化为政治
  List<Map<String, dynamic>> selectedSubjects = [
    {'subjectId': 1, 'subject': '政治'}
  ];

  /// 学科修改
  void popSubjectSelector() async {
    bool needRefresh = await showBottomModal<bool>(
      context: context,
      backgroundColor: ColorM.C1,
      body: SubjectSelector(
        previousSubjectIds: selectedSubjects
            .map((subject) => subject['subjectId'])
            .toList()
            ?.cast<int>(),
      ),
      dismissible: false,
      dragable: false,
    );
    if (needRefresh is bool && needRefresh) {
      // 科目有变更，更新页面
      // BUG 有bar和view对不上的情况
      setState(() {
        selectedSubjects = SpUtil.getObjectList('selected_subjects')
            ?.cast<Map<String, dynamic>>();
        _controller = TabController(
          length: selectedSubjects.length,
          vsync: ScrollableState(),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // 从本地获取选中的科目
    var tmp =
        SpUtil.getObjectList('selected_subjects')?.cast<Map<String, dynamic>>();
    // 如果本地没记录，即初次使用，初始化一个政治在本地
    if (tmp == null) {
      SpUtil.putObjectList('selected_subjects', [
        {'subjectId': 1, 'subject': '政治'}
      ]);
    } else {
      selectedSubjects = tmp;
    }
    _controller = TabController(
      length: selectedSubjects.length,
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
            onPressed: popSubjectSelector,
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
                tabs: selectedSubjects
                    .map(
                      (e) => Container(
                        key: ValueKey<int>(e['subjectId']),
                        alignment: Alignment.center,
                        height: 32,
                        child: Text(e['subject']),
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
        children: selectedSubjects
            .map(
              (e) => QuestionBankPageView(
                key: ValueKey<int>(e['subjectId']),
                subjectId: e['subjectId'],
                subject: e['subject'],
              ),
            )
            .toList(),
      ),
    );
  }
}
