import 'package:flutter/material.dart';
import 'package:flutter_demo/component/image_set.dart';
import 'package:flutter_demo/model/test_info.dart';
import 'package:flutter_demo/pages/learning/question_bank/do_question_page.dart';
import 'package:flutter_demo/pages/learning/question_bank/test_purchase_page.dart';
import 'package:flutter_demo/provide/global_provide.dart';
import 'package:flutter_demo/utils/format_util.dart';
import 'package:flutter_demo/utils/style_util.dart';
import 'package:flutter_demo/utils/toast_util.dart';

class TestInfoCard extends StatefulWidget {
  /// 用于展示试题信息的卡片，用在历年真题页面、模拟题页面和首页

  TestInfoCard({
    Key key,
    @required this.testInfo,
    this.onJump,
  }) : super(key: key);

  final TestInfo testInfo;

  final VoidCallback onJump;

  @override
  _TestInfoCardState createState() => _TestInfoCardState();
}

class _TestInfoCardState extends State<TestInfoCard> {
  TestInfo get testInfo => widget.testInfo;

  VoidCallback get onJump => widget.onJump;

  String get _subject => testInfo.subject;

  String get _name => testInfo.name;

  String get _description => testInfo.description;

  int get _questionNum => testInfo.questionNum;

  String get _doneNum => FormatUtil.intAbbr(testInfo.doneNum);

  bool get _isFree => testInfo.isFree ?? true;

  bool get _isPurchased => testInfo.isPurchased ?? false;

  /// 当isFree为真，可直接做，
  /// 当isFree为假但isPurchased为真，可直接做
  /// 当isFree为假且isPurchased为假，需购买
  bool get _isAccessible => _isFree || _isPurchased;

  double get _price => testInfo.price;

  /// 渲染按钮区域
  List<Widget> _getBtn() {
    List<Widget> renderWidgets = [
      Container(
        height: 28,
        width: 65,
        margin: EdgeInsets.only(left: 5),
        child: FlatButton(
          textColor: Colors.white,
          color: ColorM.G3,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          onPressed: () {
            if (!getGlobalProvide(context).isLogin) {
              ToastUtil.showText(text: '请先登录');
              return;
            }
            if (onJump != null) onJump();
            if (_isAccessible) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoQuestionPage(
                    testInfo: testInfo,
                  ),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TestPurchasePage(
                    testInfo: testInfo,
                  ),
                ),
              );
            }
          },
          child: Text(_isAccessible ? '去做题' : '去购买'),
        ),
      )
    ];
    if (!_isAccessible) {
      renderWidgets.insert(
          0,
          Row(
            children: [
              ImageSet(
                ImageSets.bcoin,
                height: 20,
                width: 20,
              ),
              Text('×$_price', style: TextStyleM.O1_B)
            ],
          ));
    }
    return renderWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            height: 74,
            width: 60,
            padding: EdgeInsets.all(8),
            color: ColorM.C1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$_subject'),
                ...List.generate(
                  3,
                  (index) => Divider(
                    color: ColorM.C5,
                    height: 12,
                    thickness: 1,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: 74,
              margin: EdgeInsets.only(left: 15),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$_name',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '$_description',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyleM.D5_12.merge(TextStyle(height: 1.5)),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      '$_questionNum题 | $_doneNum人做过',
                      style: TextStyleM.D5_12.merge(TextStyle(height: 2)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: _getBtn(),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
