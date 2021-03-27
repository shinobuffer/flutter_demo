import 'package:flutter/material.dart';
import 'package:flutter_demo/component/loading_first_screen.dart';
import 'package:flutter_demo/component/no_data_tip.dart';
import 'package:flutter_demo/model/collect_item.dart';
import 'package:flutter_demo/pages/learning/question_bank/collect_test/collect_question_page.dart';
import 'package:flutter_demo/pages/learning/question_bank/mixin/search_box_mixin.dart';
import 'package:flutter_demo/service/api_service.dart';
import 'package:flutter_demo/utils/style_util.dart';

class CollectTestPage extends StatefulWidget {
  /// 收藏夹页面
  CollectTestPage({Key key, this.arguments}) : super(key: key);

  final arguments;

  @override
  _CollectTestPageState createState() => _CollectTestPageState();
}

class _CollectTestPageState extends State<CollectTestPage> with SearchBoxMixin {
  String get subject => widget.arguments['subject'] as String;
  int get subjectId => widget.arguments['subjectId'] as int;

  List<CollectItem> collectItems = [];

  List<CollectItem> curCollectItems = [];

  Future<void> initFuture;

  /// 首屏数据初始化，通过subjectId拉取collectItems
  Future<void> initData() async {
    var resp = await ApiService.getCollectItemsBySubjectId(subjectId);
    List<Map<String, dynamic>> collectItemsJson = resp.data;
    // 给collectItemsJson追加subjectId
    collectItemsJson
        .forEach((e) => e.putIfAbsent('subjectId', () => subjectId));
    collectItems =
        collectItemsJson.map((e) => CollectItem.fromJson(e)).toList();
    if (curSearch.isEmpty) {
      // 页面初始化，不考虑搜索过滤；不带过滤的页面刷新
      setState(() {
        curCollectItems = collectItems;
      });
    } else {
      // 页面刷新，考虑过滤
      setState(() {
        curCollectItems = collectItems
            .where((item) => item.name.contains(curSearch))
            .toList();
      });
    }
  }

  /// 取消搜索，恢复数据
  @override
  void onCancelSearch() {
    setState(() {
      curCollectItems = collectItems;
      curSearch = searchController.text = '';
    });
  }

  /// 触发搜索，过滤数据
  @override
  void onSearch(String search) {
    if (curSearch != search) {
      setState(() {
        curCollectItems =
            collectItems.where((item) => item.name.contains(search)).toList();
        curSearch = search;
      });
    }
  }

  /// 收藏跳转
  void jumpCollectTest(CollectItem item) {
    Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => CollectQuestionPage(
          collectItem: item,
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
        title: Text('收藏夹($subject)'),
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
                  child: curCollectItems.isNotEmpty
                      ? RefreshIndicator(
                          onRefresh: initData,
                          child: ListView.separated(
                            itemCount: curCollectItems.length,
                            separatorBuilder: (context, index) =>
                                Divider(height: 1),
                            itemBuilder: (context, index) {
                              CollectItem item = curCollectItems[index];
                              return ListTile(
                                title: Text(
                                  item.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle:
                                    Text('收藏数量 ${item.questionIds.length}'),
                                trailing: Icon(
                                  Icons.chevron_right_rounded,
                                  size: 30,
                                ),
                                dense: true,
                                enabled: true,
                                onTap: () => jumpCollectTest(item),
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
