import 'package:flutter/material.dart';
import 'package:flutter_demo/component/image_set.dart';
import 'package:flutter_demo/component/loading_first_screen.dart';
import 'package:flutter_demo/service/api_service.dart';
import 'package:flutter_demo/utils/screen_util.dart';
import 'package:flutter_demo/utils/style_util.dart';

class HistoryBill extends StatefulWidget {
  HistoryBill({
    Key key,
    @required this.isBCoin,
  }) : super(key: key);

  final bool isBCoin;

  @override
  _HistoryBillState createState() => _HistoryBillState();
}

class _HistoryBillState extends State<HistoryBill> {
  // 前后端统一定死
  static const BCoinAlterationStrTypes = ['活动获取', 'B币充值', '兑换金瓜子', '购买试题'];
  static const GSeedAlterationStrTypes = ['活动获取', '兑换金瓜子'];

  List<Map<String, dynamic>> histories = [];
  bool get isBCoin => widget.isBCoin;

  Future<void> initFuture;

  /// 首屏数据初始化
  Future<void> initData() async {
    var resp = isBCoin
        ? await ApiService.getBCoinHistory()
        : await ApiService.getGoldSeedHistory();
    setState(() {
      histories = resp.data;
    });
  }

  @override
  void initState() {
    super.initState();
    initFuture = initData();
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
                bottom: BorderSide(width: 1, color: ColorM.C1),
              ),
            ),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${isBCoin ? "B币" : "瓜子"}账单',
                    style: TextStyleM.D7_18_B,
                  ),
                  TextSpan(
                    text: '(最多30条)',
                    style: TextStyleM.D4_12,
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: LoadingFirstScreen(
              future: initFuture,
              body: ListView.separated(
                itemCount: histories.length,
                separatorBuilder: (context, index) => Divider(height: 1),
                itemBuilder: (context, index) {
                  Map<String, dynamic> history = histories[index];
                  String title = isBCoin
                      ? BCoinAlterationStrTypes[history['type']]
                      : GSeedAlterationStrTypes[history['type']];
                  String subTitle = history['createTime'];
                  int value = history['value'];
                  String vary = value > 0 ? '   +$value' : '   $value';
                  return ListTile(
                    title: Text(title),
                    subtitle: Text(subTitle),
                    dense: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ImageSet(
                          isBCoin ? ImageSets.bcoin : ImageSets.gold_seed,
                          height: 20,
                        ),
                        Text(
                          vary,
                          style: value > 0 ? TextStyleM.O1_B : TextStyleM.R1_B,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
