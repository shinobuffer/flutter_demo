import 'package:flutter/material.dart';
import 'package:flutter_demo/model/question.dart';
import 'package:flutter_demo/model/wrong_item.dart';
import 'package:flutter_demo/pages/learning/question_bank/component/question_page_view.dart';
import 'package:flutter_demo/service/api_service.dart';
import 'package:flutter_demo/utils/style_util.dart';

class WrongQuestionPage extends StatefulWidget {
  WrongQuestionPage({
    Key key,
    @required this.wrongItem,
    this.freshQuestions,
    this.freshIndex = 0,
  }) : super(key: key);

  final WrongItem wrongItem;

  /// 由刚试卷结果页传入，可以直接使用
  final List<Question> freshQuestions;

  /// 由刚试卷结果页传入，指定了初始题目index
  final int freshIndex;

  @override
  _WrongQuestionPageState createState() => _WrongQuestionPageState();
}

class _WrongQuestionPageState extends State<WrongQuestionPage> {
  static const ShapeBorder _bottomBtnShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
  );

  List<Question> generatedQuestions = [];

  WrongItem get wrongItem => widget.wrongItem;

  /// 是否从结算页跳转过来的
  bool get isFresh => widget.freshQuestions != null;

  List<Question> get questions => widget.freshQuestions ?? generatedQuestions;

  // List<Question> questions = [
  //   Question.fromJson(
  //     {
  //       'qid': 114511,
  //       'type': 0,
  //       'chapter': '物质世界和实践——哲学概述',
  //       'chapterId': 233,
  //       'content': '在维可的回忆中，伊尔缪伊一共使用了多少个“欲望的摇篮”？',
  //       'choices': ['两个', '三个', '四个', '五个'],
  //       'correctChoices': [0],
  //       'userChoices': [0],
  //       'analysis': '无解析',
  //     },
  //   ),
  //   Question.fromJson(
  //     {
  //       'qid': 114512,
  //       'type': 1,
  //       'chapter': '物质世界和实践——哲学概述',
  //       'chapterId': 233,
  //       'content': '生骸村三贤包括？',
  //       'choices': ['维可', '袜子强', '贝拉弗', '嘛啊啊'],
  //       'correctChoices': [0, 1, 2],
  //       'userChoices': [0, 1, 2],
  //       'analysis': '无解析',
  //     },
  //   ),
  //   Question.fromJson(
  //     {
  //       'qid': 114513,
  //       'type': 2,
  //       'chapter': '物质世界和实践——哲学概述',
  //       'chapterId': 233,
  //       'content': '生骸村三贤包括？',
  //       'correctBlank': '维可、袜子强、贝拉弗',
  //       'userBlank': '555',
  //       'analysis': '无解析',
  //     },
  //   ),
  // ];

  /// 移出错题集的题目id
  final List<int> removedQuestionIds = [];

  final PageController _pageController = PageController(initialPage: 0);
  int _curIndex = 0;
  int get _curQuestionId => questions[_curIndex].qid;
  int get _curPage => _curIndex + 1;
  int get _pageNum => wrongItem.questionIds.length;
  bool get _isEndPage => _curPage == _pageNum;

  /// todo 首屏数据初始化
  /// 如果widget.freshQuestion为null（来自做题错题集），通过wrongItem中的qids拉取错误questions，并拉取answerMap
  /// 如果widget.freshQuestion非null（来自做题页面结算），直接使用freshQuestion，什么都不用干
  Future<void> initData() async {
    if (!isFresh) {
      // 错题集跳转而来，拉取questions和answerMap
      print('[WRONG QUESTIONS FROM WRONG<tid:${wrongItem.tid}>]');
      var resps = await Future.wait([
        ApiService.getQuestionsByQids(wrongItem.questionIds),
      ]);
      List<Map<String, dynamic>> questionsJson = resps[0].data;
      Map<int, List<int>> answerMap = {
        25: [2],
        26: [2],
        27: [2],
        28: [2],
      };
      questionsJson.forEach((q) {
        if (q['type'] < 2) {
          int qid = q['questionId'];
          q['userChoices'] = answerMap[qid] ?? [];
        }
      });
      List<Question> qs =
          questionsJson.map((e) => Question.fromJson(e)).toList();
      // 对问题排序，选择题优先
      qs.sort((a, b) => a.type.index.compareTo(b.type.index));
      setState(() {
        generatedQuestions = qs;
      });
    } else {
      // 试卷结果页跳转而来，跳转到指定题目
      Future.delayed(
        Duration.zero,
        () => _pageController.animateToPage(
          widget.freshIndex,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        ),
      );
      print('[ANALYSIS FROM RESULT_PAGE<tid:${wrongItem.tid}>]');
    }
  }

  /// todo: 错题状态反转，发送请求
  void toggleWrong(int questionId) {
    if (removedQuestionIds.contains(questionId)) {
      setState(() {
        removedQuestionIds.remove(questionId);
      });
    } else {
      setState(() {
        removedQuestionIds.add(questionId);
      });
    }
  }

  /// 下一题目
  void doNext() {
    if (!_isEndPage) {
      _pageController.animateToPage(
        _curIndex + 1,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  /// 渲染顶部标题
  Widget _getTitle() {
    return Container(
      height: 45,
      padding: EdgeInsets.symmetric(horizontal: 25),
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
      child: Text(
        '${wrongItem.name}',
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyleM.G1,
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
          if (!isFresh)
            RaisedButton(
              color: Colors.white,
              elevation: 5,
              shape: _bottomBtnShape,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    removedQuestionIds.contains(_curQuestionId)
                        ? Icons.redo_rounded
                        : Icons.delete_outline_rounded,
                  ),
                  Text(
                    removedQuestionIds.contains(_curQuestionId) ? '取消删除' : '删除',
                  ),
                ],
              ),
              onPressed: () => toggleWrong(_curQuestionId),
            ),
          if (!isFresh) SizedBox(width: 15),
          Expanded(
            child: RaisedButton(
              color: Colors.white,
              disabledColor: ColorM.C2,
              elevation: 5,
              shape: _bottomBtnShape,
              child: Text('下一题'),
              onPressed: _isEndPage ? null : doNext,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, removedQuestionIds.isNotEmpty);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isFresh ? '题目解析' : '错题集'),
          centerTitle: true,
          actions: [
            Container(
              padding: EdgeInsets.only(right: 20),
              alignment: Alignment.center,
              child: Text('$_curPage/$_pageNum'),
            )
          ],
          elevation: 0,
        ),
        body: Container(
          height: double.maxFinite,
          width: double.maxFinite,
          child: Column(
            children: [
              _getTitle(),
              // 题目区域
              Expanded(
                child: PageView(
                  controller: _pageController,
                  children: questions
                      .map(
                        (q) => QuestionPageView(
                          pageType: QuestionPageViewTypes.wrongQuestion,
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
