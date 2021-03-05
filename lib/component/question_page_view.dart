import 'package:flutter/material.dart';
import 'package:flutter_demo/model/question.dart';
import 'package:flutter_demo/utils/style_util.dart';

enum QuestionPageViewTypes {
  doQuestion,
  wrongQuestion,
  collection,
}

class QuestionPageView extends StatefulWidget {
  QuestionPageView({
    Key key,
    @required this.pageType,
    @required this.question,
  }) : super(key: key);

  final Question question;

  final QuestionPageViewTypes pageType;

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
    if (question.isChoiceQuestion) {
      return ListView.separated(
        physics: const NeverScrollableScrollPhysics(), //禁止滚动
        shrinkWrap: true,
        itemCount: question.choices.length,
        separatorBuilder: (BuildContext context, int index) =>
            Divider(height: 1),
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
              if (question.isMultiChoice) {
                question.revertChoice(index);
              } else if (question.isFill && question.containChoice(index)) {
                question.revertChoice(index);
              } else {
                question
                  ..clearChoice()
                  ..addChoice(index);
              }
            }),
          );
        },
      );
    } else if (widget.isDoQuestion) {
      return Container(
        height: 110,
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: ColorM.C2,
              child: Icon(
                Icons.description,
                color: ColorM.C4,
                size: 20,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '暂不支持该题型作答\n交卷后可查看解析',
              textAlign: TextAlign.center,
              style: TextStyleM.D1_14,
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
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
                  '${QuestionStrTypes[question.type.index]}',
                  style: TextStyleM.D1_12,
                ),
                Text(
                  '    ${question.content}${question.isMultiChoice ? "(多选)" : ""}',
                ),
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