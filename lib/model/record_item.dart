class RecordItem {
  RecordItem(Map<String, dynamic> json)
      : rid = json['rid'],
        tid = json['tid'],
        name = json['name'],
        isCompleted = json['isCompleted'],
        timeStamp = json['timeStamp'],
        doneNum = json['doneNum'],
        questionNum = json['questionNum'],
        correctRate = json['correctRate'] ?? 0.0;

  RecordItem.fromJson(Map<String, dynamic> json) : this(json);

  /// 记录id
  final int rid;

  /// 关联试卷id
  final int tid;

  /// 关联试卷名
  final String name;

  /// 试卷是否完成
  final bool isCompleted;

  /// 最后退出/完成时间戳
  final int timeStamp;

  /// 答题数量（试卷未完成用到）
  final int doneNum;

  /// 题目总数（试卷未完成用到）
  final int questionNum;

  /// 正确率（试卷完成用到）
  final double correctRate;

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('\n==========>RecordItem<==========\n');
    sb.write('"rid":$rid,\n');
    sb.write('"tid":$tid,\n');
    sb.write('"name":`$name`,\n');
    sb.write('"isCompleted":$isCompleted,\n');
    sb.write('"timeStamp":$timeStamp,\n');
    sb.write('"doneNum":$doneNum,\n');
    sb.write('"questionNum":$questionNum,\n');
    sb.write('"correctRate":$correctRate,\n');

    return sb.toString();
  }
}

// void main(List<String> args) {
//   Map<String, dynamic> json = {
//     'rid': 233,
//     'tid': 233,
//     'name': '2020年全国硕士研究生入学统一考试',
//     'isCompleted': false,
//     'timeStamp': DateTime.now().millisecondsSinceEpoch,
//     'doneNum': 23,
//     'questionNum': 50,
//     'correctRate': .5
//   };

//   print(RecordItem.fromJson(json));
// }
