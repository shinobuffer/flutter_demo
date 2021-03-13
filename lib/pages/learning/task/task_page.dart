import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/learning/task/task_card.dart';
import 'package:flutter_demo/utils/style_util.dart';

class TaskPage extends StatefulWidget {
  TaskPage({Key key}) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  /// todo: 获取任务，统计任务完成状态
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('任务'),
        centerTitle: true,
      ),
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.all(20),
        color: ColorM.C1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text('当前任务'), TaskCard(), TaskCard()],
        ),
      ),
    );
  }
}
