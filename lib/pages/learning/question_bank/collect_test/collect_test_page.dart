import 'package:flutter/material.dart';
import 'package:flutter_demo/component/no_data_tip.dart';
import 'package:flutter_demo/model/collect_item.dart';
import 'package:flutter_demo/pages/learning/question_bank/collect_test/collect_question_page.dart';
import 'package:flutter_demo/pages/learning/question_bank/mixin/search_box_mixin.dart';
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
  // todo: 拉取错题数据
  List<CollectItem> collectItems = [
    CollectItem.fromJson(
      {
        'tid': 233,
        'name': '2020年全国硕士研究生入学统一考试',
        'questionIds': [1, 2, 3],
      },
    ),
    CollectItem.fromJson(
      {
        'tid': 233,
        'name': '2020年全国硕士研究生入学统一考试',
        'questionIds': [1, 2, 3],
      },
    ),
  ];

  List<CollectItem> curCollectItems = [
    CollectItem.fromJson(
      {
        'tid': 233,
        'name': '2020年全国硕士研究生入学统一考试',
        'questionIds': [1, 2, 3],
      },
    ),
    CollectItem.fromJson(
      {
        'tid': 233,
        'name': '2020年全国硕士研究生入学统一考试',
        'questionIds': [1, 2, 3],
      },
    ),
  ];

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

  /// todo: 收藏跳转
  void jumpCollectTest(CollectItem item) {
    Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => CollectQuestionPage(
          collectItem: item,
        ),
      ),
    ).then((needRefresh) {
      if (needRefresh) {}
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('收藏夹($subject)'),
        centerTitle: true,
      ),
      body: Container(
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
                  ? ListView.separated(
                      itemCount: curCollectItems.length,
                      separatorBuilder: (context, index) => Divider(height: 1),
                      itemBuilder: (context, index) {
                        CollectItem item = curCollectItems[index];
                        return ListTile(
                          title: Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text('收藏数量 ${item.questionIds.length}'),
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            size: 30,
                          ),
                          dense: true,
                          enabled: true,
                          onTap: () => jumpCollectTest(item),
                        );
                      },
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
    );
  }
}
