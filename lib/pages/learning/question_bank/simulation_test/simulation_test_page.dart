import 'package:flutter/material.dart';
import 'package:flutter_demo/component/loading_first_screen.dart';
import 'package:flutter_demo/component/no_data_tip.dart';
import 'package:flutter_demo/model/test_info.dart';
import 'package:flutter_demo/pages/learning/question_bank/component/test_info_card.dart';
import 'package:flutter_demo/pages/learning/question_bank/mixin/search_box_mixin.dart';
import 'package:flutter_demo/service/api_service.dart';
import 'package:flutter_demo/utils/style_util.dart';

class SimulationTestPage extends StatefulWidget {
  /// 模拟题库页面
  SimulationTestPage({Key key, this.arguments}) : super(key: key);

  final arguments;

  @override
  _SimulationTestPageState createState() => _SimulationTestPageState();
}

class _SimulationTestPageState extends State<SimulationTestPage>
    with SearchBoxMixin {
  String get subject => widget.arguments['subject'] as String;
  int get subjectId => widget.arguments['subjectId'] as int;
  // todo: 拉取已购和未购试题信息 purchasedTestInfos、moreTestInfos
  List<TestInfo> purchasedTestInfos = [];

  List<TestInfo> moreTestInfos = [];

  List<TestInfo> curPurchasedTestInfos = [];

  List<TestInfo> curMoreTestInfos = [];

  Future<void> initFuture;

  /// 首屏数据初始化，拉取试卷信息 testInfos
  Future<void> initData() async {
    var resp = await ApiService.getTestInfosBySubjectId(subjectId);
    setState(() {
      List<Map<String, dynamic>> testInfosJson =
          resp.data['false']?.cast<Map<String, dynamic>>() ?? [];
      List<TestInfo> testInfos =
          testInfosJson.map((json) => TestInfo.fromJson(json)).toList();
      purchasedTestInfos =
          testInfos.where((testInfo) => testInfo.isPurchased).toList();
      curPurchasedTestInfos = purchasedTestInfos;
      moreTestInfos =
          testInfos.where((testInfo) => !testInfo.isPurchased).toList();
      curMoreTestInfos = moreTestInfos;
    });
  }

  /// 取消搜索，恢复数据
  @override
  void onCancelSearch() {
    setState(() {
      curPurchasedTestInfos = purchasedTestInfos;
      curMoreTestInfos = moreTestInfos;
      curSearch = searchController.text = '';
    });
  }

  /// 触发搜索，过滤数据
  @override
  void onSearch(String search) {
    if (curSearch != search) {
      setState(() {
        curPurchasedTestInfos = purchasedTestInfos
            .where((info) => info.name.contains(search))
            .toList();
        curMoreTestInfos =
            moreTestInfos.where((info) => info.name.contains(search)).toList();
        curSearch = search;
      });
    }
  }

  /// 渲染已购试题
  /// todo: 如果没登录则不渲染
  Widget _getPurchasedTest() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '已购试题',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          curPurchasedTestInfos.isNotEmpty
              ? ListView.separated(
                  physics: const NeverScrollableScrollPhysics(), //禁止滚动
                  shrinkWrap: true,
                  itemCount: curPurchasedTestInfos.length,
                  separatorBuilder: (context, index) => Divider(
                    color: ColorM.C2,
                    height: 1,
                    thickness: 1,
                  ),
                  itemBuilder: (context, index) =>
                      TestInfoCard(testInfo: curPurchasedTestInfos[index]),
                )
              : NoDataTip(
                  imgHeight: 100,
                  imgFit: BoxFit.fitHeight,
                  text: '空空如也...',
                  textStyle: TextStyleM.D4,
                ),
        ],
      ),
    );
  }

  /// 渲染更多试题(未购买)
  Widget _getMoreTest() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '更多试题',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          curMoreTestInfos.isNotEmpty
              ? ListView.separated(
                  physics: const NeverScrollableScrollPhysics(), //禁止滚动
                  shrinkWrap: true,
                  itemCount: curMoreTestInfos.length,
                  separatorBuilder: (context, index) => Divider(
                    color: ColorM.C2,
                    height: 1,
                    thickness: 1,
                  ),
                  itemBuilder: (context, index) =>
                      TestInfoCard(testInfo: curMoreTestInfos[index]),
                )
              : NoDataTip(
                  imgHeight: 100,
                  imgFit: BoxFit.fitHeight,
                  text: '空空如也...',
                  textStyle: TextStyleM.D4,
                ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initFuture = initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('模拟题($subject)'),
        centerTitle: true,
      ),
      body: LoadingFirstScreen(
        future: initFuture,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                getSearchBox(),
                ...getSearchTitle(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _getPurchasedTest(),
                        _getMoreTest(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
