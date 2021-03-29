import 'package:flutter/material.dart';
import 'package:flutter_demo/model/statistics.dart';
import 'package:flutter_demo/service/api_service.dart';
import 'package:flutter_demo/utils/style_util.dart';

class QuestionBankPageView extends StatefulWidget {
  QuestionBankPageView({
    Key key,
    @required this.subject,
    @required this.subjectId,
  }) : super(key: key);

  final String subject;
  final int subjectId;

  @override
  _QuestionBankPageViewState createState() => _QuestionBankPageViewState();
}

class _QuestionBankPageViewState extends State<QuestionBankPageView> {
  Statistics statistics = Statistics.fromJson({});

  // 拉取科目相关统计数据（做题数，正确率，学习天数等）
  Future<void> initData() async {
    var resp = await ApiService.getStatisticsBySubjectId(widget.subjectId);
    Map<String, dynamic> statisticsJson = resp.data;
    if (resp.isSucc) {
      setState(() {
        statistics = Statistics.fromJson(statisticsJson);
      });
    }
  }

  Widget _createGridViewItem(
    IconData icon,
    String title,
    VoidCallback onPressed,
  ) {
    return FlatButton(
      textColor: ColorM.C5,
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
          ),
          SizedBox(height: 10),
          Text(title),
        ],
      ),
    );
  }

  Widget _getGridView() {
    Map<String, dynamic> arguments = {
      'subject': widget.subject,
      'subjectId': widget.subjectId
    };
    // 逻辑填充
    return GridView(
      physics: const NeverScrollableScrollPhysics(), //禁止滚动
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      children: [
        _createGridViewItem(Icons.loop_rounded, '随机练习', () {}),
        _createGridViewItem(Icons.description_rounded, '历年真题', () {
          Navigator.pushNamed(
            context,
            '/question_bank/real_test',
            arguments: arguments,
          ).then((value) => initData());
        }),
        _createGridViewItem(Icons.library_books_rounded, '模拟题', () {
          Navigator.pushNamed(
            context,
            '/question_bank/simulation_test',
            arguments: arguments,
          ).then((value) => initData());
        }),
        _createGridViewItem(Icons.dangerous, '错题集', () {
          Navigator.pushNamed(
            context,
            '/question_bank/wrong_test',
            arguments: arguments,
          );
        }),
        _createGridViewItem(Icons.star_rounded, '收藏夹', () {
          Navigator.pushNamed(
            context,
            '/question_bank/collect_test',
            arguments: arguments,
          );
        }),
        _createGridViewItem(Icons.access_time_rounded, '做题记录', () {
          Navigator.pushNamed(
            context,
            '/question_bank/record_test',
            arguments: arguments,
          );
        }),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 160,
            width: double.maxFinite,
            color: ColorM.C1,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: DefaultTextStyle(
                style: TextStyleM.D5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.subject,
                      style: TextStyleM.D5_24,
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              '${statistics.doneNumStr}',
                              style: TextStyleM.G1_24,
                            ),
                            Text('刷题数'),
                          ],
                        ),
                        Column(
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${statistics.costTimeStr}',
                                    style: TextStyleM.G1_24,
                                  ),
                                  TextSpan(
                                    text: '${statistics.costTimeUnit}',
                                    style: TextStyleM.G1,
                                  ),
                                ],
                              ),
                            ),
                            Text('做题时长'),
                          ],
                        ),
                        Column(
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${statistics.correctRateStr}',
                                    style: TextStyleM.G1_24,
                                  ),
                                  TextSpan(
                                    text: '%',
                                    style: TextStyleM.G1,
                                  ),
                                ],
                              ),
                            ),
                            Text('正确率'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(child: _getGridView()),
        ],
      ),
    );
  }
}
