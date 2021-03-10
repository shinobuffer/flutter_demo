import 'package:flutter/material.dart';
import 'package:flutter_demo/component/base/progress_bar.dart';
import 'package:flutter_demo/model/question.dart';
import 'package:flutter_demo/model/record.dart';
import 'package:flutter_demo/model/test.dart';
import 'package:flutter_demo/utils/style_util.dart';

// ignore: must_be_immutable
class TestResultPage extends StatelessWidget {
  TestResultPage({Key key, @required this.record}) : super(key: key) {
    List<int> breakPoints = [];
    QuestionType curType;
    List.generate(questions.length, (index) {
      if (curType != questions[index].type) {
        curType = questions[index].type;
        breakPoints.add(index);
      }
    });
    _breakPoints = breakPoints..add(questions.length);
  }

  static const Map<String, Color> _map = {
    '正确': ColorM.G2,
    '错误': ColorM.R1,
    '未答': ColorM.C2,
  };

  final Record record;

  Test get test => record.test;

  List<Question> get questions => test.questions;

  int get _costSeconds => record.costSeconds;

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

  /// 题型下标分界点，用于划分题型
  List<int> _breakPoints;

  /// 选择题总数量
  int get choiceQuestionNum =>
      _breakPoints.length > 3 ? _breakPoints[2] : _breakPoints.last;

  /// 选择题正确总数量
  int get correctChoiceQuestionNum => questions
      .sublist(0, choiceQuestionNum)
      .where((q) => q.isCorrect)
      .toList()
      .length;

  /// 选择题正确率
  int get correctPercentage =>
      100 * correctChoiceQuestionNum ~/ choiceQuestionNum;

  static List<Widget> getInstructions() {
    return _map.keys
        .map(
          (key) => Container(
            margin: EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Container(
                  height: 12,
                  width: 12,
                  decoration:
                      BoxDecoration(color: _map[key], shape: BoxShape.circle),
                ),
                SizedBox(width: 5),
                Text(key),
              ],
            ),
          ),
        )
        .toList();
  }

  /// 获取题目对错颜色
  static Color getColor(bool isFill, bool isCorrect) {
    if (!isFill) {
      return ColorM.C1;
    } else if (isCorrect) {
      return ColorM.G2;
    }
    return ColorM.R1;
  }

  /// 渲染每类题的对错情况
  List<Widget> getSections() {
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
                          onPressed: () {},
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
            // 答题结果头
            Container(
              height: 140,
              width: double.maxFinite,
              color: Colors.teal,
              child: DefaultTextStyle(
                style: TextStyleM.D0_12,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${test.name}'),
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
            ),
            // 答题结果说明
            Container(
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
                      children: getInstructions(),
                    ),
                  ),
                ],
              ),
            ),
            // 答题结果体
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.maxFinite,
                  color: Colors.white,
                  child: Column(
                    children: getSections(),
                  ),
                ),
              ),
            ),
            // 答题结果底部菜单
            Container(
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
            )
          ],
        ),
      ),
    );
  }
}
