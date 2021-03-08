import 'dart:convert';

import 'package:flutter_demo/model/test.dart';

class Record {
  Record({
    Test test,
    int costSeconds = 0,
    bool isCompleted = false,
  }) : assert(test != null) {
    _rid = DateTime.now().millisecondsSinceEpoch;
    _costSeconds = costSeconds;
    _isCompleted = isCompleted;
    _test = test;
  }

  Record.fromJson(Map<String, dynamic> json)
      : _rid = json['rid'],
        _costSeconds = json['costSeconds'],
        _isCompleted = json['isCompleted'],
        _test = new Test(json['test']);

  /// 使用时间戳作为rid
  int _rid;

  /// 累计耗时
  int _costSeconds;

  /// 是否完成
  bool _isCompleted;

  /// 对应试题
  Test _test;

  int get rid => _rid;
  int get costSeconds => _costSeconds;
  bool get isCompleted => _isCompleted;
  Test get test => _test;

  /// 更新记录
  void updateRecord({
    int costSeconds,
    bool isCompleted,
  }) {
    _rid = DateTime.now().millisecondsSinceEpoch;
    _costSeconds ??= costSeconds;
    _isCompleted ??= isCompleted;
  }

  Map<String, dynamic> toJson() => {
        'rid': rid,
        'costSeconds': costSeconds,
        'isCompleted': isCompleted,
        'test': test,
      };

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('===========>Record<===========\n');
    sb.write('"rid":$rid,\n');
    sb.write('"costSeconds":$costSeconds,\n');
    sb.write('"isCompleted":$isCompleted,\n');
    sb.write('"test":$test,\n');
    return sb.toString();
  }
}

// void main(List<String> args) {
//   Map<String, dynamic> json = {
//     'name': '政治随机题',
//     'description': '政治随机题',
//     'subject': '政治',
//     'subjectId': 233,
//     'isFree': true,
//     'questions': [
//       {
//         'qid': 114514,
//         'type': 0,
//         'chapter': '物质世界和实践——哲学概述',
//         'chapterId': 233,
//         'content': '在维可的回忆中，伊尔缪伊一共使用了多少个“欲望的摇篮”？',
//         'choices': ['两个', '三个', '四个', '五个'],
//         'correctChoices': [0],
//         'userChoices': [0],
//         'analysis': '无解析',
//       },
//       {
//         'qid': 114514,
//         'type': 1,
//         'chapter': '物质世界和实践——哲学概述',
//         'chapterId': 233,
//         'content': '生骸村三贤包括？',
//         'choices': ['维可', '袜子强', '贝拉弗', '嘛啊啊'],
//         'correctChoices': [0, 1, 2],
//         'userChoices': [0, 1, 2],
//         'analysis': '无解析',
//       },
//       {
//         'qid': 114514,
//         'type': 1,
//         'chapter': '物质世界和实践——哲学概述',
//         'chapterId': 233,
//         'content': '生骸村三贤包括？',
//         'correctBlank': '维可、袜子强、贝拉弗',
//         'userBlank': '555',
//         'analysis': '无解析',
//       }
//     ],
//   };
//   Test test = Test.fromJson(json);
//   Record record = new Record(test: test);
//   // print(jsonDecode(jsonEncode(record)));
//   print(Record.fromJson(jsonDecode(jsonEncode(record))));
// }
