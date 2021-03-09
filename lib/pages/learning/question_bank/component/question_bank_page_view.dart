import 'package:flutter/material.dart';
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
  // todo: 拉取科目相关数据（做题数，正确率，学习天数等）

  Widget _createGridViewItem(
    IconData icon,
    String title,
    VoidCallback onPressed,
  ) {
    return FlatButton(
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: ColorM.C5,
            size: 32,
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyleM.D5,
          ),
        ],
      ),
    );
  }

  Widget _getGridView() {
    // todo: 逻辑填充
    return GridView(
      physics: const NeverScrollableScrollPhysics(), //禁止滚动
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      children: [
        _createGridViewItem(Icons.loop_rounded, '随机练习', () {}),
        _createGridViewItem(Icons.description_rounded, '历年真题', () {}),
        _createGridViewItem(Icons.library_books_rounded, '模拟题', () {}),
        _createGridViewItem(Icons.dangerous, '错题集', () {}),
        _createGridViewItem(Icons.star_rounded, '收藏夹', () {}),
        _createGridViewItem(Icons.access_time_rounded, '做题记录', () {}),
      ],
    );
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
                              '2.3k',
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
                                  TextSpan(text: '23', style: TextStyleM.G1_32),
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
                        Column(
                          children: [
                            Text(
                              '233',
                              style: TextStyleM.G1_24,
                            ),
                            Text('天数'),
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
