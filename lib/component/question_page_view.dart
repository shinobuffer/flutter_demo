import 'package:flutter/material.dart';
import 'package:flutter_demo/model/question.dart';
import 'package:flutter_demo/utils/style_util.dart';

enum QuestionPageViewTypes {
  doQuestion,
  wrongQuestion,
  collection,
}

class QuestionPageView extends StatefulWidget {
  // todo: 构造接收question
  QuestionPageView({Key key, @required this.pageType}) : super(key: key);

  final Question question = Question({
    'qid': 114514,
    'type': 1,
    'chapter': '物质世界和实践——哲学概述',
    'chapterId': 233,
    'content': '在维可的回忆中，伊尔缪伊一共使用了多少个“欲望的摇篮”？',
    'choices': ['两个', '三个', '四个', '五个'],
    'correctChoices': [0, 1],
    'correctBlank': '我的世界',
  });

  final QuestionPageViewTypes pageType;

  final List<String> questionTypes = ['单选题', '多选题', '填空题', '简答题'];

  bool get isDoQuestion => pageType == QuestionPageViewTypes.doQuestion;
  bool get isWrongQuestion => pageType == QuestionPageViewTypes.wrongQuestion;
  bool get isCollection => pageType == QuestionPageViewTypes.collection;

  @override
  _QuestionPageViewState createState() =>
      _QuestionPageViewState(question: question);
}

class _QuestionPageViewState extends State<QuestionPageView> {
  _QuestionPageViewState({@required this.question});

  final Question question;

  String _int2Char(int index) {
    return String.fromCharCodes([65 + index]);
  }

  String _ints2Char(List<int> indexes) {
    if (indexes.isEmpty) return '未答';
    return indexes.map((int index) => _int2Char(index)).join(',');
  }

  /// 渲染答题区
  Widget getAnswerArea() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(), //禁止滚动
      shrinkWrap: true,
      itemCount: question.choices.length,
      separatorBuilder: (BuildContext context, int index) => Divider(height: 1),
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Text(
            _int2Char(index),
            style: TextStyle(fontSize: 16),
          ),
          title: Transform(
            transform: Matrix4.translationValues(-20, 0, 0),
            child: Text(
              question.choices[index],
              maxLines: 2,
              style: TextStyle(height: 1, fontSize: 15),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          dense: true,
          enabled: widget.isDoQuestion,
          selected: question.containChoice(index),
          selectedTileColor: Color(0xFFE5F4F3),
          onTap: () => setState(() {
            question.revertChoice(index);
          }),
        );
      },
    );
  }

  /// 渲染答案对比（收藏夹只显示正确答案，错题集显示正确答案和用户答案）
  Widget getAnswerCmp() {
    List<Widget> renderWidgets = widget.isWrongQuestion
        ? [
            SizedBox(width: 38),
            Text.rich(TextSpan(children: [
              TextSpan(text: '你的答案'),
              TextSpan(
                text: '  ${_ints2Char(question.userChoices)}',
                style: TextStyle(
                  color: question.isCorrect ? ColorM.G1 : ColorM.R1,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ])),
          ]
        : [];

    return Container(
      height: 30,
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Color(0xFFE8F5FF),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Row(children: [
        Text.rich(TextSpan(children: [
          TextSpan(text: '正确答案'),
          TextSpan(
            text: '  ${_ints2Char(question.correctChoices)}',
            style: TextStyle(
              color: ColorM.G1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ])),
        ...renderWidgets,
      ]),
    );
  }

  /// 渲染题目解析
  Widget getAnsweranalysis() {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: ColorM.C1,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: DefaultTextStyle(
            style: TextStyleM.D7_13,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '题目解析',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Divider(height: 6),
                Text('${question.analysis ?? "无"}'),
                SizedBox(height: 10),
                Text(
                  '核心考点',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Divider(height: 6),
                Text('${question.chapter}'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> renderWidgets = [];
    if (!widget.isDoQuestion) {
      if (question.isChoiceQuestion) {
        renderWidgets.add(getAnswerCmp());
      }
      renderWidgets.add(getAnsweranalysis());
    }
    return Container(
      height: double.maxFinite,
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 题目内容
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.questionTypes[question.type.index]}',
                  style: TextStyleM.D1_12,
                ),
                Text('    ${question.content}'),
              ],
            ),
          ),
          // 答题区
          getAnswerArea(),
          // 题目答案和题目解析
          ...renderWidgets,
        ],
      ),
    );
  }
}
