import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_demo/component/base/icon_label_button.dart';
import 'question_page_view.dart';

class DoQuestionPage extends StatefulWidget {
  DoQuestionPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DoQuestionPageState createState() => _DoQuestionPageState();
}

class _DoQuestionPageState extends State<DoQuestionPage> {
  ShapeBorder _bottomBtnShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
  );
  int _curIndex = 0;
  int _costSeconds = 0;
  Timer _timer;
  PageController _pageController = PageController(initialPage: 0);

  int get _curPage => _curIndex + 1;
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
  void initState() {
    super.initState();
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
    await showDialog<Null>(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        // backgroundColor: Color(0xff5abebc),
        // contentTextStyle: TextStyle(color: Colors.white),
        content: Container(
          height: 150,
          alignment: Alignment.center,
          child: Column(
            children: [
              Text(
                '2020高考题目',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                '这是2020高考题目2020高考题目2020高考题目2020高考题目2020高考题目',
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
        actions: [
          Container(
            width: double.maxFinite,
            child: RaisedButton(
                child: Text('开始做题'),
                onPressed: () {
                  // todo: 开始做题
                  starTimer();
                  Navigator.pop(context);
                }),
          )
        ],
      ),
    );
  }

  Future<bool> showQuitDialog(BuildContext context) async {
    bool confirmed = await showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text('提醒'),
        content: Text('确定要退出做题？退出后做题进度将保存在做题记录中，可随时继续'),
        actions: [
          RaisedButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('取消'),
          ),
          RaisedButton(
            color: Color(0xff5abebc),
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              '确定',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    if (confirmed) {
      // todo: 保存记录
      Navigator.pop(context);
    }
    return confirmed;
  }

  void showSubmitDialog(BuildContext context) async {}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => showQuitDialog(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          actions: [
            Container(
              padding: EdgeInsets.only(right: 20),
              alignment: Alignment.center,
              child: Text('$_curPage/*'),
            )
          ],
        ),
        body: Container(
          height: double.maxFinite,
          child: Column(
            children: [
              Container(
                //顶部Bar
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
                    IconLabelButton(
                      Icons.timer_rounded,
                      '$_hour:$_minute:$_second',
                      iconSize: 20,
                      labelSize: 10,
                      lineHeight: 1.5,
                    ),
                    IconLabelButton(
                      Icons.check_circle_outline_rounded,
                      '答题卡',
                      iconSize: 20,
                      labelSize: 10,
                      lineHeight: 1.5,
                    ),
                    IconLabelButton(
                      Icons.feedback_outlined,
                      '纠错',
                      iconSize: 20,
                      labelSize: 10,
                      lineHeight: 1.5,
                    ),
                  ],
                ),
              ),
              Expanded(
                //做题区域
                child: Container(
                  child: PageView(
                    controller: _pageController,
                    children: [
                      QuestionPageView(
                        pageType: QuestionPageViewTypes.doQuestion,
                      ),
                      QuestionPageView(
                        pageType: QuestionPageViewTypes.wrongQuestion,
                      ),
                      QuestionPageView(
                        pageType: QuestionPageViewTypes.collection,
                      ),
                    ],
                    onPageChanged: (int index) {
                      setState(() {
                        _curIndex = index;
                      });
                    },
                  ),
                ),
              ),
              Container(
                //底部Bar
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
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      flex: 2,
                      child: RaisedButton(
                        color: Colors.white,
                        elevation: 5,
                        shape: _bottomBtnShape,
                        child: Text('下一题|提交'),
                        onPressed: () {
                          _pageController.animateToPage(
                            _curIndex + 1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
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
