import 'package:flutter/material.dart';
import 'package:flutter_demo/model/user_info.dart';
import 'package:flutter_demo/pages/mine/component/history_bill.dart';
import 'package:flutter_demo/provide/global_provide.dart';
import 'package:flutter_demo/utils/dialog_util.dart';
import 'package:flutter_demo/utils/style_util.dart';
import 'package:provider/provider.dart';

class BCoinPage extends StatefulWidget {
  BCoinPage({Key key}) : super(key: key);

  @override
  _BCoinPageState createState() => _BCoinPageState();
}

class _BCoinPageState extends State<BCoinPage> {
  /// 弹出账单
  void popHistoryBill() {
    showBottomModal(
      context: context,
      dragable: false,
      body: HistoryBill(isBCoin: true),
    );
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
            '什么是B币',
            style: TextStyleM.D7_18_B,
          ),
          SizedBox(height: 10),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'B币是本平台为您提供的用于在本平台上进行消费的虚拟币，只可本平台上使用。'),
                TextSpan(
                  text: '\nB币和人民币的兑换比例是 1:1。 B币在任何情况下都不能兑换成法定货币，',
                  style: TextStyleM.D7_B,
                ),
                TextSpan(text: '请您根据自己的实际需求购买相应数量的B币。'),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(
            'B币可以干啥',
            style: TextStyleM.D7_18_B,
          ),
          SizedBox(height: 10),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: '1.购买收费试题\n'),
                TextSpan(text: '2.发起有偿求助\n'),
                TextSpan(text: '3.按1:10的比例兑换'),
                TextSpan(text: '金瓜子', style: TextStyleM.D7_B)
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
    getGlobalProvide(context).updateUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的B币'),
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
                      '${userInfo.bCoin ?? "--"}',
                      style: TextStyleM.O1_32_B,
                    ),
                  ),
                  Text(
                    'B币余额',
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
                      onPressed: () {},
                      child: Text('充值'),
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
