class WrongItem {
  WrongItem({
    this.tid,
    this.name,
    this.subjectId,
    this.questionIds,
  });

  WrongItem.fromJson(Map<String, dynamic> json)
      : tid = json['tid'] ?? json['sheetId'],
        name = json['name'],
        subjectId = json['subjectId'],
        questionIds = json['questionIds']?.cast<int>() ?? [];

  /// 试卷编号
  final int tid;

  /// 试卷标题
  final String name;

  /// 试卷科目id
  final int subjectId;

  /// 错题编号集
  final List<int> questionIds;

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('\n==========>WrongItem<==========\n');
    sb.write('"tid":$tid,\n');
    sb.write('"name":`$name`,\n');
    sb.write('"subjectId":$subjectId,\n');
    sb.write('"questionIds":$questionIds,\n');
    return sb.toString();
  }
}

// void main(List<String> args) {
//   Map<String, dynamic> json = {
//     'tid': 233,
//     'name': '2020年全国硕士研究生入学统一考试',
//     'questionIds': [1, 2, 3],
//   };
//   print(WrongItem.fromJson(json));
// }
