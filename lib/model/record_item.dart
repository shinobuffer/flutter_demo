import 'package:flutter_demo/utils/format_util.dart';

class RecordItem {
  /// 不包含answerMap
  RecordItem({
    this.rid,
    this.costSeconds,
    this.isCompleted,
    this.tid,
    this.name,
    this.description,
    this.subject,
    this.subjectId,
    this.timeStamp,
    this.doneNum,
    this.questionNum,
    this.correctRate = 0,
  }) {
    _lastCompleteTime = DateUtil.formatDateMs(
        timeStamp ?? DateTime.now().millisecondsSinceEpoch);
  }

  RecordItem.fromJson(Map<String, dynamic> json)
      : rid = json['rid'] ?? json['recordId'],
        costSeconds = json['costSeconds'],
        isCompleted = json['isCompleted'],
        tid = json['tid'] ?? json['sheetId'],
        name = json['name'] ?? json['sheetTitle'],
        description = json['description'] ?? json['sheetDescription'],
        subject = json['subject'] ?? json['sheetSubject'],
        subjectId = json['subjectId'],
        timeStamp = json['timeStamp'],
        _lastCompleteTime = json['completeTime'],
        doneNum = json['doneNum'],
        questionNum = json['questionNum'],
        correctRate = json['correctRate'] ?? 0;

  /// 记录id
  final int rid;

  /// 做题耗时
  final int costSeconds;

  /// 是否完成
  final bool isCompleted;

  /// 试卷id
  final int tid;

  /// 试卷名
  final String name;

  /// 试卷描述
  final String description;

  /// 科目
  final String subject;

  /// 科目id
  final int subjectId;

  /// 上次完成时间（ms时间戳，用于生成lastCompleteTime，仅在前端存储）
  final int timeStamp;

  /// 上次完成时间（后端实际存储值）
  String _lastCompleteTime;

  String get lastCompleteTime => _lastCompleteTime;

  /// 完成题目数量（选择题）
  final int doneNum;

  /// 题目数量（选择题）
  final int questionNum;

  /// 正确率(百分号前面的整数，完成试卷后填入)
  final int correctRate;

  Map<String, dynamic> toJson() => {
        'recordId': rid,
        'subjectId': subjectId,
        'sheetId': tid,
        'isCompleted': isCompleted,
        'costSeconds': costSeconds,
        'completeTime': lastCompleteTime,
        'doneNum': doneNum,
        'questionNum': questionNum,
        'correctRate': correctRate,
      };

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('\n==========>RecordItem<==========\n');
    sb.write('"rid":$rid,\n');
    sb.write('"costSeconds":$costSeconds,\n');
    sb.write('"isCompleted":$isCompleted,\n');
    sb.write('"tid":$tid,\n');
    sb.write('"name":`$name`,\n');
    sb.write('"description":`$description`,\n');
    sb.write('"subject":`$subject`,\n');
    sb.write('"subjectId":$subjectId,\n');
    sb.write('"lastCompleteTime":`$lastCompleteTime`,\n');
    sb.write('"doneNum":$doneNum,\n');
    sb.write('"questionNum":$questionNum,\n');
    sb.write('"correctRate":$correctRate,\n');
    return sb.toString();
  }
}

// void main(List<String> args) {
//   Map<String, dynamic> json = {
//     'rid': 233,
//     'costSeconds': 233,
//     'isCompleted': false,
//     'tid': 233,
//     'name': '2020年全国硕士研究生入学统一考试',
//     'description': '2020国考',
//     'subject': '政治',
//     'subjectId': 0,
//     'timeStamp': DateTime.now().millisecondsSinceEpoch,
//     'doneNum': 23,
//     'questionNum': 50,
//     'correctRate': 50
//   };

//   print(RecordItem.fromJson(json));
// }
