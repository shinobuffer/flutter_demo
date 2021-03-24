// import 'dart:convert';

enum QuestionType {
  SingleChoice,
  MultiChoice,
  FillBlank,
  Brief,
}

const List<String> QuestionStrTypes = ['单选题', '多选题', '填空题', '简答题'];

class Question {
  Question(Map<String, dynamic> json)
      : assert(json['qid'] is int || json['questionId'] is int),
        // todo: 暂时撤离保护
        // assert(json['chapter'] is String),
        // assert(json['chapterId'] is int),
        assert(json['content'] is String),
        assert(json['choices'] == null ||
            json['choices']?.cast<String>() is List<String>),
        assert(json['correctChoices'] == null ||
            json['correctChoices']?.cast<int>() is List<int>),
        assert(json['correctBlank'] == null || json['correctBlank'] is String),
        assert(json['analysis'] == null || json['analysis'] is String),
        qid = json['qid'] ?? json['questionId'],
        chapter = json['chapter'] ?? '无',
        chapterId = json['chapterId'] ?? -1,
        content = json['content'],
        choices = json['choices']?.cast<String>() ?? [],
        correctChoices = json['correctChoices']?.cast<int>() ?? [],
        correctBlank = json['correctBlank'] ?? '',
        analysis = json['analysis'],
        userChoices = json['userChoices']?.cast<int>() ?? [],
        userBlank = json['userBlank'] ?? '' {
    // 题目类型识别
    switch (json['type']) {
      case 0:
        type = QuestionType.SingleChoice;
        break;
      case 1:
        type = QuestionType.MultiChoice;
        break;
      case 2:
        type = QuestionType.FillBlank;
        break;
      case 3:
        type = QuestionType.Brief;
        break;
      default:
        throw ArgumentError("json[type] should be non-null");
    }
  }

  Question.fromJson(Map<String, dynamic> json) : this(json);

  /// 题目id
  final int qid;

  /// 题型
  QuestionType type;

  /// 所属章节/核心考点
  final String chapter;

  final int chapterId;

  /// 题目内容
  final String content;

  /// 题目选项（兼容单选多选）
  final List<String> choices;

  /// 正确选项
  final List<int> correctChoices;

  /// 正确填空
  final String correctBlank;

  /// 题目解释
  final String analysis;

  /// 用户选项
  List<int> userChoices;

  /// 错误填空
  String userBlank;

  bool get isFill {
    switch (type) {
      case QuestionType.SingleChoice:
      case QuestionType.MultiChoice:
        return userChoices.isNotEmpty;
      case QuestionType.FillBlank:
      case QuestionType.Brief:
        return userBlank.isNotEmpty;
      default:
        return false;
    }
  }

  bool get isCorrect {
    switch (type) {
      case QuestionType.SingleChoice:
      case QuestionType.MultiChoice:
        return userChoices.length == correctChoices.length &&
            userChoices.toSet().containsAll(correctChoices);
      case QuestionType.FillBlank:
      case QuestionType.Brief:
        return true;
      default:
        return false;
    }
  }

  bool get isChoiceQuestion =>
      (type == QuestionType.SingleChoice || type == QuestionType.MultiChoice);

  bool get isSingleChoice => type == QuestionType.SingleChoice;

  bool get isMultiChoice => type == QuestionType.MultiChoice;

  bool containChoice(int choice) => userChoices.contains(choice);

  void addChoice(int choice) {
    if (isChoiceQuestion && !containChoice(choice)) {
      userChoices.add(choice);
    }
  }

  void removeChoice(int choice) {
    if (isChoiceQuestion && containChoice(choice)) {
      userChoices.remove(choice);
    }
  }

  void revertChoice(int choice) {
    if (!isChoiceQuestion) return;
    containChoice(choice) ? removeChoice(choice) : addChoice(choice);
  }

  void clearChoice() {
    userChoices.clear();
  }

  void setBlank(String blank) {
    if (type == QuestionType.FillBlank || type == QuestionType.Brief) {
      userBlank = blank;
    }
  }

  Map<String, dynamic> toJson() => {
        'qid': qid,
        'type': type.index,
        'chapter': chapter,
        'chapterId': chapterId,
        'content': content,
        'choices': choices,
        'correctChoices': correctChoices,
        'correctBlank': correctBlank,
        'userChoices': userChoices,
        'userBlank': userBlank,
        'analysis': analysis,
      };

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('\n==========>Question<==========\n');
    sb.write('"qid":$qid,\n');
    sb.write('"type":$type,\n');
    sb.write('"chapter":`$chapter`,\n');
    sb.write('"content":`$content`,\n');
    sb.write('"choices":$choices,\n');
    sb.write('"correctChoices":$correctChoices,\n');
    sb.write('"correctBlank":`$correctBlank`,\n');
    sb.write('"userChoices":$userChoices,\n');
    sb.write('"userBlank":`$userBlank`,\n');
    sb.write('"analysis":`$analysis`,\n');
    return sb.toString();
  }
}

// void main(List<String> args) {
//   Map<String, dynamic> json = {
//     'qid': 114514,
//     'type': 1,
//     'chapter': '物质世界和实践——哲学概述',
//     'chapterId': 233,
//     'content': '在维可的回忆中，伊尔缪伊一共使用了多少个“欲望的摇篮”？',
//     'choices': ['两个', '三个', '四个', '五个'],
//     'correctChoices': [0, 1],
//     'analysis': '无解析',
//   };

//   Question q = Question(json);
//   q.addChoice(1);
//   q.addChoice(0);
//   print(q.isCorrect);
//   print(q.isFill);
//   print(Question.fromJson(jsonDecode(jsonEncode(q))));
// }
