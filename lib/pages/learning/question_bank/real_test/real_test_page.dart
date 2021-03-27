import 'package:flutter/material.dart';
import 'package:flutter_demo/component/loading_first_screen.dart';
import 'package:flutter_demo/component/no_data_tip.dart';
import 'package:flutter_demo/model/test_info.dart';
import 'package:flutter_demo/pages/learning/question_bank/component/test_info_card.dart';
import 'package:flutter_demo/pages/learning/question_bank/mixin/search_box_mixin.dart';
import 'package:flutter_demo/service/api_service.dart';
import 'package:flutter_demo/utils/style_util.dart';

class RealTestPage extends StatefulWidget {
  /// 历年真题库页面
  RealTestPage({Key key, this.arguments}) : super(key: key);

  final arguments;

  @override
  _RealTestPageState createState() => _RealTestPageState();
}

class _RealTestPageState extends State<RealTestPage> with SearchBoxMixin {
  String get subject => widget.arguments['subject'] as String;
  int get subjectId => widget.arguments['subjectId'] as int;

  List<TestInfo> testInfos = [];

  List<TestInfo> curTestInfos = [];

  Future<void> initFuture;

  /// 首屏数据初始化，拉取试卷信息 testInfos
  Future<void> initData() async {
    var resp = await ApiService.getTestInfosBySubjectId(
      subjectId: subjectId,
      isFree: true,
    );
    List<Map<String, dynamic>> testInfosJson = resp.data;
    testInfos = testInfosJson.map((json) => TestInfo.fromJson(json)).toList();
    if (curSearch.isEmpty) {
      // 页面初始化，不考虑搜索过滤；不带过滤的页面刷新
      setState(() {
        curTestInfos = testInfos;
      });
    } else {
      // 页面刷新，考虑过滤
      setState(() {
        curTestInfos =
            testInfos.where((info) => info.name.contains(curSearch)).toList();
      });
    }
  }

  /// 取消搜索，恢复数据
  @override
  void onCancelSearch() {
    setState(() {
      curTestInfos = testInfos;
      curSearch = searchController.text = '';
    });
  }

  /// 触发搜索，过滤数据
  @override
  void onSearch(String search) {
    if (curSearch != search) {
      setState(() {
        curTestInfos =
            testInfos.where((info) => info.name.contains(search)).toList();
        curSearch = search;
      });
    }
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
        title: Text('历年真题($subject)'),
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
                  child: curTestInfos.isNotEmpty
                      ? RefreshIndicator(
                          onRefresh: initData,
                          child: ListView.separated(
                            itemCount: curTestInfos.length,
                            separatorBuilder: (context, index) =>
                                Divider(height: 1),
                            itemBuilder: (context, index) =>
                                TestInfoCard(testInfo: curTestInfos[index]),
                          ),
                        )
                      : NoDataTip(
                          imgHeight: 100,
                          imgFit: BoxFit.fitHeight,
                          text: '空空如也...',
                          textStyle: TextStyleM.D4,
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
