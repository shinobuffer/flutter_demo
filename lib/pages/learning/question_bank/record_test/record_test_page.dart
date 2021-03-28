import 'package:flutter/material.dart';
import 'package:flutter_demo/component/loading_first_screen.dart';
import 'package:flutter_demo/component/no_data_tip.dart';
import 'package:flutter_demo/model/record_item.dart';
import 'package:flutter_demo/pages/learning/question_bank/do_question_page.dart';
import 'package:flutter_demo/pages/learning/question_bank/test_result_page.dart';
import 'package:flutter_demo/service/api_service.dart';
import 'package:flutter_demo/utils/style_util.dart';

class RecordTestPage extends StatefulWidget {
  RecordTestPage({Key key, this.arguments}) : super(key: key);

  final arguments;

  @override
  _RecordTestPageState createState() => _RecordTestPageState();
}

class _RecordTestPageState extends State<RecordTestPage> {
  String get subject => widget.arguments['subject'] as String;
  int get subjectId => widget.arguments['subjectId'] as int;

  List<RecordItem> recordItems = [];

  Future<void> initFuture;

  /// 首屏数据初始化，通过subjectId拉取recordItems
  Future<void> initData() async {
    var resp = await ApiService.getRecordItemsBySubjectId(subjectId);
    List<Map<String, dynamic>> recordItemsJson = resp.data;
    setState(() {
      recordItems = recordItemsJson.map((e) => RecordItem.fromJson(e)).toList();
    });
  }

  /// 记录跳转
  void jumpRecordTest(RecordItem item) {
    if (item.isCompleted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TestResultPage(
            recordItem: item,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DoQuestionPage(
            recordItem: item,
          ),
        ),
      ).then(
        (value) => Future.delayed(
          Duration(seconds: 1),
          () => initData(),
        ),
      );
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
        title: Text('做题记录($subject)'),
        centerTitle: true,
      ),
      body: LoadingFirstScreen(
        future: initFuture,
        body: Container(
          height: double.maxFinite,
          alignment: Alignment.center,
          child: recordItems.isNotEmpty
              ? RefreshIndicator(
                  onRefresh: initData,
                  child: ListView.separated(
                    itemCount: recordItems.length,
                    separatorBuilder: (context, index) => Divider(height: 1),
                    itemBuilder: (context, index) {
                      RecordItem item = recordItems[index];
                      String correctRate = '${item.correctRate}%';
                      String subStr =
                          item.isCompleted ? '已完成 | 正确率 $correctRate' : '未完成';
                      return ListTile(
                        title: Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text('${item.lastCompleteTime} $subStr'),
                        trailing: SizedBox(
                          height: 25,
                          width: 60,
                          child: FlatButton(
                            onPressed: () => jumpRecordTest(item),
                            padding: EdgeInsets.zero,
                            color: ColorM.G3,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Text(
                              item.isCompleted ? '查看结果' : '继续做题',
                              style: TextStyleM.D0_12,
                            ),
                          ),
                        ),
                        dense: true,
                      );
                    },
                  ),
                )
              : NoDataTip(
                  imgHeight: 100,
                  imgFit: BoxFit.fitHeight,
                  margin: EdgeInsets.symmetric(vertical: 20),
                  text: '空空如也...',
                  textStyle: TextStyleM.D4,
                ),
        ),
      ),
    );
  }
}
