import 'package:flutter/material.dart';
import 'package:flutter_demo/component/no_data_tip.dart';
import 'package:flutter_demo/model/wrong_item.dart';
import 'package:flutter_demo/pages/learning/question_bank/mixin/search_box_mixin.dart';
import 'package:flutter_demo/pages/learning/question_bank/wrong_test/wrong_question_page.dart';
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
  // todo: 拉取错题数据
  List<WrongItem> wrongItems = [
    WrongItem.fromJson(
      {
        'tid': 233,
        'name': '2020年全国硕士研究生入学统一考试',
        'questionIds': [1, 2, 3],
      },
    ),
    WrongItem.fromJson(
      {
        'tid': 233,
        'name': '2020年全国硕士研究生入学统一考试',
        'questionIds': [1, 2, 3],
      },
    ),
  ];

  List<WrongItem> curWrongItems = [
    WrongItem.fromJson(
      {
        'tid': 233,
        'name': '2020年全国硕士研究生入学统一考试',
        'questionIds': [1, 2, 3],
      },
    ),
    WrongItem.fromJson(
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

  /// todo: 错题跳转
  void jumpWrongTest(WrongItem item) {
    Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => WrongQuestionPage(
          wrongItem: item,
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
        title: Text('错题集($subject)'),
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
              child: curWrongItems.isNotEmpty
                  ? ListView.separated(
                      itemCount: curWrongItems.length,
                      separatorBuilder: (context, index) => Divider(height: 1),
                      itemBuilder: (context, index) {
                        WrongItem item = curWrongItems[index];
                        return ListTile(
                          title: Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text('错题数量 ${item.questionIds.length}'),
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            size: 30,
                          ),
                          dense: true,
                          enabled: true,
                          onTap: () => jumpWrongTest(item),
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
