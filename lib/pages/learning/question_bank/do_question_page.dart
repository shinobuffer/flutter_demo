import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_demo/component/base/icon_label_button.dart';
import 'package:flutter_demo/model/question.dart';
import 'package:flutter_demo/model/record_item.dart';
import 'package:flutter_demo/model/test_info.dart';
import 'package:flutter_demo/pages/learning/question_bank/test_result_page.dart';
import 'package:flutter_demo/utils/dialog_util.dart';
import 'package:flutter_demo/utils/style_util.dart';
import 'component/answer_card.dart';
import 'component/correction_feedback.dart';
import 'component/question_page_view.dart';

class DoQuestionPage extends StatefulWidget {
  DoQuestionPage({
    Key key,
    // todo
    // this.testInfo,
    // this.recordItem,
  }) : super(key: key);

  // 这两者只能传一个，对应做题和续题
  final TestInfo testInfo = TestInfo.fromJson({
    'tid': 233,
    'time': '2020-11-11',
    'name': '2020年全国硕士研究生入学统一考试（政治）',
    'description': '2020年考研政治',
    'subject': '政治',
    'subjectId': 233,
    'publisher': '教育部',
    'publisherId': 233,
    'isFree': true,
    'price': 0.0,
    'questionNum': 50,
    'doneNum': 2333,
  });
  final RecordItem recordItem = RecordItem.fromJson({
    'rid': 233,
    'costSeconds': 233,
    'isCompleted': false,
    'tid': 233,
    'name': '2020年全国硕士研究生入学统一考试',
    'description': '2020国考',
    'subject': '政治',
    'subjectId': 0,
    'timeStamp': DateTime.now().millisecondsSinceEpoch,
    'doneNum': 2,
    'questionNum': 2,
    'correctRate': 50,
  });

  @override
  _DoQuestionPageState createState() => _DoQuestionPageState();
}

class _DoQuestionPageState extends State<DoQuestionPage> {
  static const ShapeBorder _bottomBtnShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
  );

  final PageController _pageController = PageController(initialPage: 0);

  List<Question> questions;

  int _curIndex = 0;
  int _costSeconds = 0;
  Timer _timer;

  TestInfo get testInfo => widget.testInfo;

  RecordItem get recordItem => widget.recordItem;

  bool get isNewDo => testInfo != null;

  String get testName => testInfo?.name ?? recordItem?.name;

  String get testDescription =>
      testInfo?.description ?? recordItem?.description;

  Question get _curQuestion => questions[_curIndex];

  int get _curPage => _curIndex + 1;

  int get _pageNum => questions.length;

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

  void starTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _costSeconds++;
      });
    });
  }

  /// todo: 开始弹框，对于新做的题，初始化计数，提示开始做题
  /// 对于继续做题，恢复计数，提示继续做题
  void showInitDialog(BuildContext context) async {
    bool confirmed;
    if (isNewDo) {
      confirmed = await showConfirmDialog<bool>(
        context: context,
        title: '$testName',
        content: Container(
          height: 130,
          child: Text(
            '$testDescription',
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
    } else {
      confirmed = await showConfirmDialog<bool>(
        context: context,
        title: '$testName',
        content: Container(
          height: 130,
          child: Text(
            '$testDescription',
            maxLines: 7,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14),
          ),
        ),
        confirmText: '继续做题',
        onConfirm: () {
          starTimer();
          Navigator.pop(context, true);
        },
      );
    }

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
    await showBottomModal<bool>(
      context: context,
      backgroundColor: ColorM.C1,
      body: AnswerCard(
        questions: questions,
        // todo: 提交试卷，跳转结果，记录本次测试，做题累计（科目和总计）
        onSubmit: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TestResultPage(),
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

  /// 弹出纠错反馈
  void popCorrectFeedback(BuildContext context) async {
    await showBottomModal(
      context: context,
      backgroundColor: Colors.transparent,
      dismissible: false,
      dragable: false,
      body: CorrectionFeedback(
        name: _curQuestion.content,
        qid: _curQuestion.qid,
      ),
    );
  }

  /// todo: 收藏题目
  void toggleCollect() {}

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

  /// 渲染顶部菜单
  Widget _getTopBar() {
    return Container(
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
    );
  }

  /// 渲染底部菜单
  Widget _getBottomBar() {
    return Container(
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
              onPressed: toggleCollect,
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
    );
  }

  @override
  void initState() {
    super.initState();
    // todo: 如果只有testInfo，通过tid请求获取questions，初始化计数，提示开始做题
    // 如果只有recordItem，通过rid请求record，通过tid请求questions并合并得到最终question，并恢复计数，提示继续做题
    int tid = testInfo?.tid ?? recordItem?.tid;
    List<Map<String, dynamic>> qs = [
      {
        'qid': 114514,
        'type': 0,
        'chapter': '物质世界和实践——哲学概述',
        'chapterId': 233,
        'content': '在维可的回忆中，伊尔缪伊一共使用了多少个“欲望的摇篮”？',
        'choices': ['两个', '三个', '四个', '五个'],
        'correctChoices': [0],
        'analysis': '无解析',
      },
      {
        'qid': 114515,
        'type': 1,
        'chapter': '物质世界和实践——哲学概述',
        'chapterId': 233,
        'content': '生骸村三贤包括？',
        'choices': ['维可', '袜子强', '贝拉弗', '嘛啊啊'],
        'correctChoices': [0, 1, 2],
        'analysis': '无解析',
      },
      {
        'qid': 114516,
        'type': 2,
        'chapter': '物质世界和实践——哲学概述',
        'chapterId': 233,
        'content': '生骸村三贤包括？',
        'correctBlank': '维可、袜子强、贝拉弗',
        'analysis': '无解析',
      }
    ];
    Map<int, List<int>> answerMap = {
      114514: [0],
      114515: [0, 1, 2],
    };

    qs.forEach((q) {
      if (q['type'] < 2) {
        int qid = q['qid'];
        q['userChoices'] = answerMap[qid] ?? [];
      }
    });
    questions = qs.map((q) => Question.fromJson(q)).toList();
    questions.sort((a, b) => a.type.index.compareTo(b.type.index));

    if (testInfo != null) {
    } else if (recordItem != null) {}
    // 等待context出来
    Future.delayed(Duration.zero, () => showInitDialog(context));
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => doQuit(context),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(testName),
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
              _getTopBar(),
              //做题区域
              Expanded(
                child: PageView(
                  controller: _pageController,
                  children: questions
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
              _getBottomBar(),
            ],
          ),
        ),
      ),
    );
  }
}
