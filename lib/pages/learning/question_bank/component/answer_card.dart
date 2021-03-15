import 'package:flutter/material.dart';
import 'package:flutter_demo/model/question.dart';
import 'package:flutter_demo/utils/dialog_util.dart';
import 'package:flutter_demo/utils/screen_util.dart';
import 'package:flutter_demo/utils/style_util.dart';

typedef void OnJump(int index);

// ignore: must_be_immutable
class AnswerCard extends StatelessWidget {
  AnswerCard({
    Key key,
    @required this.questions,
    @required this.onJump,
    @required this.onSubmit,
  }) : super(key: key) {
    List<int> breakPoints = [];
    QuestionType curType;
    List.generate(questions.length, (index) {
      if (curType != questions[index].type) {
        curType = questions[index].type;
        breakPoints.add(index);
      }
    });
    _breakPoints = breakPoints..add(questions.length);
    unfilledQuestionNum =
        questions.where((q) => q.isChoiceQuestion && !q.isFill).length;
  }

  final List<Question> questions;

  final OnJump onJump;

  final Function onSubmit;

  /// 题型下标分界点，用于划分题型
  List<int> _breakPoints;

  /// 未完成题目数（只计算选择题）
  int unfilledQuestionNum;

  /// 渲染每类题的完成情况
  List<Widget> getSections() {
    List<Widget> sections = [];
    for (int i = 0; i < _breakPoints.length - 1; i++) {
      String questionStrType =
          QuestionStrTypes[questions[_breakPoints[i]].type.index];
      sections.add(Container(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(questionStrType),
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Wrap(
                spacing: 10,
                runSpacing: 5,
                children: List.generate(
                  _breakPoints[i + 1] - _breakPoints[i],
                  (index) {
                    // 题目的真实下标
                    int qIndex = index + _breakPoints[i];
                    Question q = questions[qIndex];
                    return SizedBox(
                      height: 40,
                      width: 40,
                      child: FlatButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => onJump(qIndex),
                        child: Text(
                          '${qIndex + 1}',
                          style: TextStyle(fontSize: 16),
                        ),
                        textColor: q.isFill ? Colors.white : ColorM.C4,
                        color: q.isFill ? ColorM.G2 : ColorM.C1,
                        shape: CircleBorder(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ));
    }
    return sections;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil.getScreenH(context) - 100,
      child: Column(
        children: [
          Container(
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: ColorM.C2),
              ),
            ),
            child: Text(
              '答题卡',
              style: TextStyleM.D7_18_B,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  children: getSections(),
                ),
              ),
            ),
          ),
          Container(
            height: 40,
            width: double.maxFinite,
            child: OutlinedButton(
              child: Text(
                '交卷查看结果',
              ),
              onPressed: () async {
                String info =
                    questions.any((q) => q.isChoiceQuestion && !q.isFill)
                        ? '还有$unfilledQuestionNum道选择题目未完成，是否继续提交？'
                        : '即将提交，是否继续提交？';
                bool confirmed = await showCancelOkDialog<bool>(
                  context: context,
                  title: '提醒',
                  content: info,
                  onCancel: () => Navigator.pop(context, false),
                  onOk: () => Navigator.pop(context, true),
                );
                if (confirmed is bool && confirmed) {
                  onSubmit();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
