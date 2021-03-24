import 'package:flutter/material.dart';
import 'package:flutter_demo/component/image_set.dart';
import 'package:flutter_demo/component/no_data_tip.dart';
import 'package:flutter_demo/model/test_info.dart';
import 'package:flutter_demo/provide/global_provide.dart';
import 'package:flutter_demo/service/api_service.dart';
import 'package:flutter_demo/utils/style_util.dart';
import 'package:flutter_demo/utils/toast_util.dart';

class TestPurchasePage extends StatefulWidget {
  TestPurchasePage({Key key, @required this.testInfo}) : super(key: key);

  final TestInfo testInfo;

  @override
  _TestPurchasePageState createState() => _TestPurchasePageState();
}

class _TestPurchasePageState extends State<TestPurchasePage> {
  TestInfo get testInfo => widget.testInfo;

  /// 提交按钮文案
  String getSubmitBtnText() {
    if (!getGlobalProvide(context).isLogin) {
      return '请先登录';
    } else {
      return getGlobalProvide(context).userInfo.bCoin > testInfo.price
          ? '购买试题'
          : '余额不足';
    }
  }

  /// 检查能否提交（仅限登录且余额足够）
  bool checkSubmitable() {
    if (!getGlobalProvide(context).isLogin) {
      return false;
    } else {
      return getGlobalProvide(context).userInfo.bCoin > testInfo.price;
    }
  }

  /// todo 订单提交
  void onSubmitOrder() {}

  /// 渲染试卷信息1
  Widget _getTestInfo1() {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(bottom: 20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            children: [
              Text('售价:'),
              ImageSet(
                ImageSets.bcoin,
                height: 20,
              ),
              Text(
                '×${testInfo.price}',
                style: TextStyleM.O1_B,
              )
            ],
          ),
          SizedBox(height: 8),
          Text(
            '${testInfo.name}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyleM.D7_B,
          ),
          Text(
            '${testInfo.description}',
            style: TextStyleM.D1_12,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// 渲染试卷信息2
  Widget _getTestInfo2() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Icon(Icons.publish_rounded),
                Expanded(
                  child: Text(
                    '    ${testInfo.publisher}',
                    style: TextStyleM.D7_18_B,
                  ),
                ),
                Container(
                  height: 25,
                  width: 60,
                  margin: EdgeInsets.only(left: 10),
                  child: FlatButton(
                    padding: EdgeInsets.zero,
                    color: ColorM.G3,
                    textColor: Colors.white,
                    child: Text(
                      '订阅',
                      style: TextStyleM.D0_12,
                    ),
                    onPressed: () {
                      // todo: 订阅逻辑
                    },
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Text('时间    '),
              Text('${testInfo.time}'),
            ],
          ),
          Row(
            children: [
              Text('科目    '),
              Text('${testInfo.subject}'),
            ],
          ),
          Row(
            children: [
              Text('题数    '),
              Text('${testInfo.questionNum}'),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('购买项目'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: ColorM.C1,
        width: double.maxFinite,
        child: Stack(
          children: [
            Column(
              children: [
                NoDataTip(
                  text: '暂无图片',
                  textStyle: TextStyleM.D4,
                  imgHeight: 150,
                  margin: EdgeInsets.symmetric(vertical: 10),
                ),
                _getTestInfo1(),
                _getTestInfo2(),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 40,
                width: double.maxFinite,
                child: FlatButton(
                  color: Colors.white,
                  disabledColor: Colors.white,
                  textColor: ColorM.O2,
                  disabledTextColor: ColorM.R2,
                  child: Text(getSubmitBtnText()),
                  onPressed: checkSubmitable() ? onSubmitOrder : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
