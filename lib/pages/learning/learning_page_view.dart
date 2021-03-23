import 'package:flutter/material.dart';
import 'package:flutter_demo/model/test_info.dart';
import 'package:flutter_demo/pages/learning/question_bank/component/test_info_card.dart';
import 'package:flutter_demo/utils/format_util.dart';
import 'package:flutter_demo/utils/style_util.dart';

class LearningPageView extends StatefulWidget {
  LearningPageView({Key key}) : super(key: key);

  @override
  _LearningPageViewState createState() => _LearningPageViewState();
}

class _LearningPageViewState extends State<LearningPageView> {
  /// todo: 获取当前时间、今日名言、推荐试题
  DateTime today = DateTime.now();

  /// 最近前后三天的日期
  List<DateTime> get dates => List.generate(7, (index) => index - 3)
      .map((e) => today.add(Duration(days: e)))
      .toList();

  List<TestInfo> recomTestInfos = [
    TestInfo.fromJson({
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
      'isPurchased': false,
      'questionNum': 50,
      'doneNum': 2333,
    }),
    TestInfo.fromJson({
      'tid': 233,
      'time': '2020-11-11',
      'name': '2020年全国硕士研究生入学统一考试（政治）',
      'description': '2020年考研政治',
      'subject': '政治',
      'subjectId': 233,
      'publisher': '教育部',
      'publisherId': 233,
      'isFree': false,
      'price': 0.0,
      'isPurchased': false,
      'questionNum': 50,
      'doneNum': 2333,
    }),
  ];

  // todo: 打卡
  void _doClockOn() {}

  /// 渲染倒计时
  /// todo: 获取考研年份计算
  Widget _getCountDown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('233天', style: TextStyleM.D0_28_B),
          Text('2021考研倒计时'),
        ],
      ),
    );
  }

  /// 渲染今日语句和打卡按钮
  Widget _getSayings() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              '我在这里，目送过好多踏上有去无回之旅，但今天是最悲伤的但今天是最悲伤的但今天是最悲伤的',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              semanticsLabel: 'Double dollars',
            ),
          ),
          Container(
            height: 28,
            width: 70,
            margin: EdgeInsets.only(left: 20),
            child: FlatButton(
              color: Colors.white54,
              textColor: ColorM.C7,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(14),
                ),
              ),
              onPressed: _doClockOn,
              child: Text('打卡'),
            ),
          ),
        ],
      ),
    );
  }

  /// 渲染日历
  Widget _getCalendar() {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 5, 15, 0),
      color: Colors.black26,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: dates
                .map(
                  (e) => Text(
                    '${DateUtil.getWeekday(e, short: true).toUpperCase()}\n${e.day}',
                    textAlign: TextAlign.center,
                    style: TextStyle(height: 1.3),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 5),
          ClipPath(
            clipper: TrianglePath(),
            child: Container(
              height: 10,
              width: 20,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getMenuItem({
    IconData icon,
    String title,
    VoidCallback onPressed,
  }) {
    return Column(
      children: [
        SizedBox(
          height: 45,
          width: 45,
          child: FlatButton(
            color: ColorM.C2,
            textColor: ColorM.C5,
            padding: EdgeInsets.zero,
            shape: CircleBorder(),
            onPressed: onPressed,
            child: Icon(icon),
          ),
        ),
        Text(title),
      ],
    );
  }

  /// 渲染菜单
  Widget _getMenu() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _getMenuItem(
            icon: Icons.assignment_outlined,
            title: '任务',
            onPressed: () {
              Navigator.pushNamed(context, '/task');
            },
          ),
          _getMenuItem(
            icon: Icons.chrome_reader_mode_outlined,
            title: '题库',
            onPressed: () {
              Navigator.pushNamed(context, '/question_bank');
            },
          ),
          _getMenuItem(
            icon: Icons.all_inbox_outlined,
            title: '资源',
            onPressed: () {},
          ),
          _getMenuItem(
            icon: Icons.question_answer_outlined,
            title: '问答',
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  /// 渲染推荐试题
  Widget _getRecommendation() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 15),
      child: Column(
        children: [
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: ColorM.C1),
              ),
            ),
            child: Text(
              '推荐试题',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              itemCount: recomTestInfos.length,
              separatorBuilder: (context, index) => Divider(height: 1),
              itemBuilder: (context, index) =>
                  TestInfoCard(testInfo: recomTestInfos[index]),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      color: ColorM.C2,
      child: Column(
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/home_bg.png'),
                alignment: Alignment.topCenter,
                fit: BoxFit.fitWidth,
              ),
            ),
            child: DefaultTextStyle(
              style: TextStyleM.D0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _getCountDown(),
                  _getSayings(),
                  _getCalendar(),
                ],
              ),
            ),
          ),
          _getMenu(),
          Expanded(child: _getRecommendation()),
        ],
      ),
    );
  }
}

class TrianglePath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
