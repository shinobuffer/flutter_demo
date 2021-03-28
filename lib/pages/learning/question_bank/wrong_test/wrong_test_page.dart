import 'package:flutter/material.dart';
import 'package:flutter_demo/component/loading_first_screen.dart';
import 'package:flutter_demo/component/no_data_tip.dart';
import 'package:flutter_demo/model/wrong_item.dart';
import 'package:flutter_demo/pages/learning/question_bank/mixin/search_box_mixin.dart';
import 'package:flutter_demo/pages/learning/question_bank/wrong_test/wrong_question_page.dart';
import 'package:flutter_demo/service/api_service.dart';
import 'package:flutter_demo/utils/style_util.dart';

class WrongTestPage extends StatefulWidget {
  /// 错题集页面
  WrongTestPage({Key key, this.arguments}) : super(key: key);

  final arguments;

  @override
  _WrongTestPageState createState() => _WrongTestPageState();
}

class _WrongTestPageState extends State<WrongTestPage> with SearchBoxMixin {
  String get subject => widget.arguments['subject'] as String;
  int get subjectId => widget.arguments['subjectId'] as int;

  List<WrongItem> wrongItems = [];

  List<WrongItem> curWrongItems = [];

  Future<void> initFuture;

  /// 首屏数据初始化，通过subjectId拉取wrongItem
  Future<void> initData() async {
    var resp = await ApiService.getWrongItemsBySubjectId(subjectId);
    List<Map<String, dynamic>> wrongItemsJson = resp.data;
    wrongItems = wrongItemsJson.map((e) => WrongItem.fromJson(e)).toList();
    if (curSearch.isEmpty) {
      // 页面初始化，不考虑搜索过滤；不带过滤的页面刷新
      setState(() {
        curWrongItems = wrongItems;
      });
    } else {
      // 页面刷新，考虑过滤
      setState(() {
        curWrongItems =
            wrongItems.where((item) => item.name.contains(curSearch)).toList();
      });
    }
  }

  /// 取消搜索，恢复数据
  @override
  void onCancelSearch() {
    setState(() {
      curWrongItems = wrongItems;
      curSearch = searchController.text = '';
    });
  }

  /// 触发搜索，过滤数据
  @override
  void onSearch(String search) {
    if (curSearch != search) {
      setState(() {
        curWrongItems =
            wrongItems.where((item) => item.name.contains(search)).toList();
        curSearch = search;
      });
    }
  }

  /// 错题跳转
  void jumpWrongTest(WrongItem item) {
    Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => WrongQuestionPage(
          wrongItem: item,
        ),
      ),
    ).then((needRefresh) {
      if (needRefresh) {
        initData();
      }
    });
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
        title: Text('错题集($subject)'),
        centerTitle: true,
      ),
      body: LoadingFirstScreen(
        future: initFuture,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      getSearchBox(),
                      ...getSearchTitle(),
                    ],
                  ),
                ),
                Expanded(
                  child: curWrongItems.isNotEmpty
                      ? RefreshIndicator(
                          onRefresh: initData,
                          child: ListView.separated(
                            itemCount: curWrongItems.length,
                            separatorBuilder: (context, index) =>
                                Divider(height: 1),
                            itemBuilder: (context, index) {
                              WrongItem item = curWrongItems[index];
                              return ListTile(
                                title: Text(
                                  item.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle:
                                    Text('错题数量 ${item.questionIds.length}'),
                                trailing: Icon(
                                  Icons.chevron_right_rounded,
                                  size: 30,
                                ),
                                dense: true,
                                enabled: true,
                                onTap: () => jumpWrongTest(item),
                              );
                            },
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
