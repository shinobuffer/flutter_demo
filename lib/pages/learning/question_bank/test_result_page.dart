import 'package:flutter/material.dart';
import 'package:flutter_demo/component/base/progress_bar.dart';
import 'package:flutter_demo/model/question.dart';
import 'package:flutter_demo/model/record_item.dart';
import 'package:flutter_demo/utils/style_util.dart';

class TestResultPage extends StatefulWidget {
  TestResultPage({
    Key key,
    // todo @required this.recordItem,
    this.freshQuestions,
  }) : super(key: key);

  /// 由刚完成的试卷传入，可以直接使用
  final List<Question> freshQuestions;

  /// 如果只有recordItem没有freshQuestions，需要通过tid拉取questions并合成
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
  _TestResultPageState createState() => _TestResultPageState();
}

class _TestResultPageState extends State<TestResultPage> {
  static const Map<String, Color> _statusMap = {
    '正确': ColorM.G2,
    '错误': ColorM.R1,
    '未答': ColorM.C2,
  };

  List<Question> generatedQuestions;

  /// 题型下标分界点，用于划分题型
  List<int> _breakPoints;

  RecordItem get recordItem => widget.recordItem;

  /// 无论是传入还是合成，这里的questions应该是排过序的
  List<Question> get questions => widget.freshQuestions ?? generatedQuestions;

  int get _costSeconds => recordItem.costSeconds;

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

  /// 选择题总数量
  int get choiceQuestionNum => recordItem.questionNum;

  /// 选择题正确总数量
  int get correctChoiceQuestionNum => questions
      .sublist(0, choiceQuestionNum)
      .where((q) => q.isCorrect)
      .toList()
      .length;

  /// 选择题正确率
  int get correctPercentage => recordItem.correctRate;

  /// 错误的选择题
  List<Question> get wrongQuestions => questions
      .sublist(0, choiceQuestionNum)
      .where((q) => !q.isCorrect)
      .toList();

  /// 获取题目对错颜色
  static Color getColor(bool isFill, bool isCorrect) {
    if (!isFill) {
      return ColorM.C1;
    } else if (isCorrect) {
      return ColorM.G2;
    }
    return ColorM.R1;
  }

  /// 渲染答题结果头
  Widget _getHeader() {
    return Container(
      height: 140,
      width: double.maxFinite,
      color: Colors.teal,
      child: DefaultTextStyle(
        style: TextStyleM.D0_12,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${recordItem.name}'),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: '正确率'),
                      TextSpan(
                        text: '$correctPercentage',
                        style: TextStyleM.D0_32_B,
                      ),
                      TextSpan(
                        text: '%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  child: VerticalDivider(
                    width: 20,
                    color: Colors.white,
                    thickness: 1,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('正确题目(选择题) $correctChoiceQuestionNum'),
                    Text('题目总数(选择题) $choiceQuestionNum'),
                  ],
                )
              ],
            ),
            SizedBox(height: 10),
            Text('用时 $_hour:$_minute:$_second')
          ],
        ),
      ),
    );
  }

  /// 渲染状态说明
  static List<Widget> _getInstructions() {
    return _statusMap.keys
        .map(
          (key) => Container(
            margin: EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Container(
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                      color: _statusMap[key], shape: BoxShape.circle),
                ),
                SizedBox(width: 5),
                Text(key),
              ],
            ),
          ),
        )
        .toList();
  }

  /// 渲染title
  Widget _getTitle() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: ColorM.C1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '答题卡',
            style: TextStyleM.D4,
          ),
          DefaultTextStyle(
            style: TextStyleM.D5_10,
            child: Wrap(
              children: _getInstructions(),
            ),
          ),
        ],
      ),
    );
  }

  /// 渲染每类题的对错情况
  List<Widget> _getSections() {
    List<Widget> sections = [];
    for (int i = 0; i < _breakPoints.length - 1; i++) {
      int startInd = _breakPoints[i];
      int endInd = _breakPoints[i + 1];
      int questionNum = endInd - startInd;
      int correctNum =
          questions.sublist(startInd, endInd).where((q) => q.isCorrect).length;
      String questionStrType = QuestionStrTypes[questions[startInd].type.index];
      bool isChoiceQuestion = questions[startInd].isChoiceQuestion;

      // 只渲染选择题的对错情况
      List<Widget> renderWidgets = isChoiceQuestion
          ? [
              Row(
                children: [
                  Text(questionStrType),
                  ProgressBar(
                    width: 220,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    progress: correctNum / questionNum,
                    backgroundColor: ColorM.C2,
                    foregroundColor: ColorM.G2,
                  ),
                  Text('$correctNum/$questionNum'),
                ],
              ),
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 5,
                  children: List.generate(
                    questionNum,
                    (index) {
                      // 题目的真实下标
                      int qIndex = index + startInd;
                      Question q = questions[qIndex];
                      return SizedBox(
                        height: 40,
                        width: 40,
                        child: FlatButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            // todo: 跳转到指定题目
                          },
                          child: Text(
                            '${qIndex + 1}',
                            style: TextStyle(fontSize: 16),
                          ),
                          textColor: q.isFill ? Colors.white : ColorM.C4,
                          color: getColor(q.isFill, q.isCorrect),
                          shape: CircleBorder(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ]
          : [
              Row(
                children: [
                  Text(questionStrType),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    child: Text(
                      '查看解析',
                      style: TextStyleM.G1,
                    ),
                    onTap: () {
                      //todo: 非选择题解析
                    },
                  ),
                ],
              ),
            ];
      if (i != _breakPoints.length - 2) {
        renderWidgets.add(Divider(height: 1));
      }
      sections.add(
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: renderWidgets,
          ),
        ),
      );
    }
    return sections;
  }

  /// 渲染底部菜单
  Widget _getBottomBar() {
    return Container(
      height: 40,
      width: double.maxFinite,
      color: ColorM.C1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // todo: 逻辑待填充
          Expanded(
            child: FlatButton(
              textColor: ColorM.C5,
              onPressed: () {},
              child: Text('错题解析'),
            ),
          ),
          Expanded(
            child: FlatButton(
              textColor: ColorM.C5,
              onPressed: () {},
              child: Text('全部解析'),
            ),
          ),
          Expanded(
            child: FlatButton(
              textColor: ColorM.C5,
              onPressed: () {},
              child: Text('重新做题'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // todo 如果widget.freshQuestion 为null,通过recordItem中的rid、tid
    // 拉取questions和answerMap并整合出最终questions
    super.initState();
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
    generatedQuestions = qs.map((q) => Question.fromJson(q)).toList();
    generatedQuestions.sort((a, b) => a.type.index.compareTo(b.type.index));

    List<int> breakPoints = [];
    QuestionType curType;
    List.generate(questions.length, (index) {
      if (curType != questions[index].type) {
        curType = questions[index].type;
        breakPoints.add(index);
      }
    });
    _breakPoints = breakPoints..add(questions.length);
    print(choiceQuestionNum);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('答题结果'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        width: double.maxFinite,
        color: Colors.white,
        child: Column(
          children: [
            _getHeader(),
            _getTitle(),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.maxFinite,
                  color: Colors.white,
                  child: Column(
                    children: _getSections(),
                  ),
                ),
              ),
            ),
            _getBottomBar(),
          ],
        ),
      ),
    );
  }
}
