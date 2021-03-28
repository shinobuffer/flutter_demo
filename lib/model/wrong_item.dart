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
        questionIds = json['questionIds']?.cast<int>() ?? [] {
    Map<String, String> mistakeMap =
        (json['mistakeMap']?.cast<String, String>() ?? {})
            as Map<String, String>;
    // 将 {"2":"A,B"} 转换为 {2:[0,1]}
    questionIds = mistakeMap.keys.map((key) => int.parse(key)).toList();
    _answerMap = mistakeMap.map(
      (key, value) => MapEntry(
        int.tryParse(key) ?? -1,
        value.replaceAll(',', '').codeUnits.map((e) => e - 65).toList(),
      ),
    );
  }

  /// 试卷编号
  final int tid;

  /// 试卷标题
  final String name;

  /// 试卷科目id
  final int subjectId;

  /// 错题编号集
  List<int> questionIds = [];

  /// 用户错误选项
  Map<int, List<int>> _answerMap = {};

  Map<int, List<int>> get answerMap => _answerMap;

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('\n==========>WrongItem<==========\n');
    sb.write('"tid":$tid,\n');
    sb.write('"name":`$name`,\n');
    sb.write('"subjectId":$subjectId,\n');
    sb.write('"questionIds":$questionIds,\n');
    sb.write('"answerMap":$answerMap\n');
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
