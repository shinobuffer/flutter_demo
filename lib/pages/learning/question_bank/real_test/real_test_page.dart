import 'package:flutter/material.dart';
import 'package:flutter_demo/model/test_info.dart';
import 'package:flutter_demo/pages/learning/question_bank/component/test_info_card.dart';
import 'package:flutter_demo/pages/learning/question_bank/mixin/search_box_mixin.dart';

class RealTestPage extends StatefulWidget {
  /// 历年真题库页面
  RealTestPage({Key key}) : super(key: key);

  @override
  _RealTestPageState createState() => _RealTestPageState();
}

class _RealTestPageState extends State<RealTestPage> with SearchBoxMixin {
  // todo: 拉取试卷信息 defaultTestInfos
  List<TestInfo> defalutTestInfos;

  List<TestInfo> curTestInfos = [
    TestInfo.fromJson({
      'tid': 233,
      'time': '2020-11-11',
      'name': '2020年全国硕士研究生入学统一考试（政治）',
      'description': '2020年考研政治',
      'subject': '政治',
      'subjectId': 233,
      'publisher': '教育部',
      'publisherId': 233,
      'isFree': true,
      'price': 0.0,
      'questionNum': 50,
      'doneNum': 2333,
    }),
  ];

  /// todo: 取消搜索，恢复数据
  @override
  void onCancelSearch() {
    setState(() {
      curSearch = searchController.text = '';
    });
  }

  /// todo: 触发搜索，拉取数据
  @override
  void onSearch(String search) {
    if (curSearch != search) {
      setState(() {
        curSearch = search;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('历年真题'),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              getSearchBox(),
              ...getSearchTitle(),
              Expanded(
                child: ListView.separated(
                  itemCount: curTestInfos.length,
                  separatorBuilder: (context, index) => Divider(height: 1),
                  itemBuilder: (context, index) =>
                      TestInfoCard(testInfo: curTestInfos[index]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
