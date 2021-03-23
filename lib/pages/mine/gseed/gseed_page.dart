import 'package:flutter/material.dart';
import 'package:flutter_demo/model/user_info.dart';
import 'package:flutter_demo/pages/mine/component/exchange_card.dart';
import 'package:flutter_demo/pages/mine/component/history_bill.dart';
import 'package:flutter_demo/provide/global_provide.dart';
import 'package:flutter_demo/utils/dialog_util.dart';
import 'package:flutter_demo/utils/style_util.dart';
import 'package:provider/provider.dart';

class GSeedPage extends StatefulWidget {
  GSeedPage({Key key}) : super(key: key);

  @override
  _GSeedPageState createState() => _GSeedPageState();
}

class _GSeedPageState extends State<GSeedPage> {
  void refreshData() {
    getGlobalProvide(context).updateUserInfo();
  }

  /// 弹出账单
  void popHistoryBill() {
    showBottomModal(
      context: context,
      dragable: false,
      body: HistoryBill(isBCoin: false),
    );
  }

  /// 弹出兑换
  void popExchange() {
    showBottomModal<bool>(
      context: context,
      dragable: false,
      body: ExchangeCard(),
    ).then((changed) {
      // 如果兑换成功就刷新数据
      if (changed is bool && changed) refreshData();
    });
  }

  /// 渲染条例声明
  Widget _getStatement() {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '什么是金瓜子',
            style: TextStyleM.D7_18_B,
          ),
          SizedBox(height: 10),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                    text: '金瓜子系本平台为您提供的数字化商品，用于兑换本平台上的各种虚拟道具和增值服务，只可本平台上使用。'),
                TextSpan(
                  text: '\n金瓜子和B币的兑换比例是 10:1。',
                  style: TextStyleM.D7_B,
                ),
                TextSpan(text: 'B币可以兑换为金瓜子，'),
                TextSpan(
                  text: '金瓜子在任何情况下都不能兑换成B币。',
                  style: TextStyleM.D7_B,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(
            '金瓜子可以干啥',
            style: TextStyleM.D7_18_B,
          ),
          SizedBox(height: 10),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: '1.发起有偿求助\n'),
                TextSpan(text: '2.兑换各种虚拟道具\n'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('我的金瓜子'),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: popHistoryBill,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              child: Text('账单'),
            ),
          )
        ],
      ),
      body: Container(
        width: double.maxFinite,
        color: ColorM.C1,
        child: Column(
          children: [
            Container(
              width: double.maxFinite,
              height: 200,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 2),
                  blurRadius: 2,
                )
              ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Selector<GlobalProvide, UserInfo>(
                    selector: (context, provide) => provide.userInfo,
                    builder: (context, userInfo, child) => Text(
                      '${userInfo.gSeed ?? "--"}',
                      style: TextStyleM.O1_32_B,
                    ),
                  ),
                  Text(
                    '金瓜子余额',
                    style: TextStyleM.D5,
                  ),
                  Container(
                    height: 40,
                    width: 140,
                    margin: EdgeInsets.only(top: 20),
                    child: FlatButton(
                      color: ColorM.O2,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      onPressed: popExchange,
                      child: Text('兑换'),
                    ),
                  ),
                ],
              ),
            ),
            _getStatement(),
          ],
        ),
      ),
    );
  }
}
