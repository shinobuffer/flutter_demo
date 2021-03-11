import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_demo/component/base/icon_label_button.dart';
import 'package:flutter_demo/model/record.dart';
import 'package:flutter_demo/model/test.dart';
import 'package:flutter_demo/pages/learning/question_bank/test_result_page.dart';
import 'package:flutter_demo/utils/dialog_util.dart';
import 'package:flutter_demo/utils/style_util.dart';
import 'component/answer_card.dart';
import 'component/correction_feedback.dart';
import 'component/question_page_view.dart';

class DoQuestionPage extends StatefulWidget {
  DoQuestionPage({Key key, this.tid, this.rid}) : super(key: key);

  final int tid;
  final int rid;

  @override
  _DoQuestionPageState createState() => _DoQuestionPageState();
}

class _DoQuestionPageState extends State<DoQuestionPage> {
  Record record;

  Test test = new Test({
    'tid': 233,
    'time': '2020-11-11',
    'name': '2020年全国硕士研究生入学统一考试（政治）',
    'description': '2020年全国硕士研究生入学统一考试（政治）',
    'subject': '政治',
    'subjectId': 233,
    'publisher': '教育部',
    'publisherId': 233,
    'isFree': true,
    'price': 0.0,
    'questions': [
      {
        'qid': 114514,
        'type': 0,
        'chapter': '物质世界和实践——哲学概述',
        'chapterId': 233,
        'content': '在维可的回忆中，伊尔缪伊一共使用了多少个“欲望的摇篮”？',
        'choices': ['两个', '三个', '四个', '五个'],
        'correctChoices': [0],
        'userChoices': [0],
        'analysis': '无解析',
      },
      {
        'qid': 114514,
        'type': 1,
        'chapter': '物质世界和实践——哲学概述',
        'chapterId': 233,
        'content': '生骸村三贤包括？',
        'choices': ['维可', '袜子强', '贝拉弗', '嘛啊啊'],
        'correctChoices': [0, 1, 2],
        'userChoices': [0, 1, 2],
        'analysis': '无解析',
      },
      {
        'qid': 114514,
        'type': 2,
        'chapter': '物质世界和实践——哲学概述',
        'chapterId': 233,
        'content': '生骸村三贤包括？',
        'correctBlank': '维可、袜子强、贝拉弗',
        'userBlank': '555',
        'analysis': '无解析',
      }
    ],
  });

  ShapeBorder _bottomBtnShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
  );
  int _curIndex = 0;
  int _costSeconds = 0;
  Timer _timer;
  PageController _pageController = PageController(initialPage: 0);

  int get _curPage => _curIndex + 1;

  int get _pageNum => test.questions.length;

  bool get _isEndPage => _curPage == _pageNum;

  String get _second {
    int _ = _costSeconds % 60;
    return _ > 9 ? _.toString() : '0$_';
  }

  String get _minute {
    int _ = _costSeconds % 3600 ~/ 60;
    return _ > 9 ? _.toString() : '0$_';
  }

  String get _hour {
    int _ = (_costSeconds ~/ 3600) % 24;
    return _ > 9 ? _.toString() : '0$_';
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _timer = null;
  }

  void starTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _costSeconds++;
      });
    });
  }

  void showInitDialog(BuildContext context) async {
    bool confirmed = await showConfirmDialog<bool>(
      context: context,
      title: '${test.name}',
      content: Container(
        height: 130,
        child: Text(
          '${test.description}',
          maxLines: 7,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14),
        ),
      ),
      confirmText: '开始做题',
      onConfirm: () {
        starTimer();
        Navigator.pop(context, true);
      },
    );
    // 退出做题
    if (confirmed == null) {
      Navigator.pop(context);
    }
  }

  /// 退出做题
  Future<bool> doQuit(BuildContext context) async {
    bool confirmed = await showCancelOkDialog<bool>(
      context: context,
      title: '提醒',
      content: '确定要退出做题？退出后做题进度将保存在做题记录中，可随时继续。',
      onCancel: () => Navigator.pop(context, false),
      onOk: () => Navigator.pop(context, true),
    );
    if (confirmed is bool && confirmed) {
      // todo: 退出保存记录
      Navigator.pop(context);
    }
    return confirmed;
  }

  /// 弹出答题卡
  void popAnswerCard(BuildContext context) async {
    bool confirmed = await showBottomModal<bool>(
      context: context,
      backgroundColor: ColorM.C1,
      body: AnswerCard(
        questions: test.questions,
        // todo: 提交试卷，跳转结果，记录本次测试，做题累计（科目和总计）
        onSubmit: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TestResultPage(
                record: record,
              ),
            ),
          );
        },
        onJump: (int index) {
          Navigator.pop(context);
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }

  // todo: 下面两个的逻辑都要填充
  /// 弹出纠错反馈
  void popCorrectFeedback(BuildContext context) async {
    await showBottomModal(
      context: context,
      backgroundColor: Colors.transparent,
      dismissible: false,
      dragable: false,
      body: CorrectionFeedback(
        name: test.questions[_curIndex].content,
        qid: test.questions[_curIndex].qid,
      ),
    );
  }

  /// 收藏题目
  void doCollect() {}

  /// 下一题
  void doNext() {
    if (_isEndPage) {
      popAnswerCard(context);
    } else {
      _pageController.animateToPage(
        _curIndex + 1,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // todo: 如果有rid，读取缓存获取record和record.test，恢复做题状态，提示继续做题
    // 如果只有tid，请求test，创建record，提示开始做题
    record = new Record(test: test);
    print(record);
    // 等待context出来
    Future.delayed(Duration.zero, () => showInitDialog(context));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => doQuit(context),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(test.name),
          centerTitle: true,
          actions: [
            Container(
              padding: EdgeInsets.only(right: 20),
              alignment: Alignment.center,
              child: Text('$_curPage/$_pageNum'),
            )
          ],
        ),
        body: Container(
          height: double.maxFinite,
          child: Column(
            children: [
              //顶部菜单
              Container(
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 2),
                      blurRadius: 2,
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: IconLabelButton(
                        Icons.timer_rounded,
                        '$_hour:$_minute:$_second',
                        iconSize: 20,
                        labelSize: 10,
                        lineHeight: 1.5,
                      ),
                    ),
                    Expanded(
                      child: IconLabelButton(
                        Icons.check_circle_outline_rounded,
                        '答题卡',
                        iconSize: 20,
                        labelSize: 10,
                        lineHeight: 1.5,
                        onTap: () => popAnswerCard(context),
                      ),
                    ),
                    Expanded(
                      child: IconLabelButton(
                        Icons.feedback_outlined,
                        '纠错',
                        iconSize: 20,
                        labelSize: 10,
                        lineHeight: 1.5,
                        onTap: () => popCorrectFeedback(context),
                      ),
                    ),
                  ],
                ),
              ),
              //做题区域
              Expanded(
                child: Container(
                  child: PageView(
                    controller: _pageController,
                    children: test.questions
                        .map(
                          (q) => QuestionPageView(
                            pageType: QuestionPageViewTypes.doQuestion,
                            question: q,
                          ),
                        )
                        .toList(),
                    onPageChanged: (index) {
                      setState(() {
                        _curIndex = index;
                      });
                    },
                  ),
                ),
              ),
              //底部菜单
              Container(
                height: 40,
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 1,
                      child: RaisedButton(
                        color: Colors.white,
                        elevation: 5,
                        shape: _bottomBtnShape,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.star_outline_rounded),
                            Text('收藏'),
                          ],
                        ),
                        onPressed: doCollect,
                      ),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      flex: 2,
                      child: RaisedButton(
                        color: Colors.white,
                        elevation: 5,
                        shape: _bottomBtnShape,
                        child: Text(_isEndPage ? '提交' : '下一题'),
                        onPressed: doNext,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
