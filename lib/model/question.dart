enum QuestionType {
  SingleChoice,
  MultiChoice,
  FillBlank,
}

class Question {
  Question(Map<String, dynamic> json)
      : assert(json['qid'] is int),
        assert(json['content'] is String),
        assert(json['choices'] is List<String>),
        assert(json['correctChoices'] == null ||
            json['correctChoices'] is List<int>),
        assert(json['correctBlank'] == null || json['correctBlank'] is String),
        qid = json['qid'],
        content = json['content'],
        choices = json['choices'],
        correctChoices = json['correctChoices'] ?? [],
        correctBlank = json['correctBlank'] ?? '' {
    // 题目类型识别
    switch (json['type']) {
      case 1:
        type = QuestionType.SingleChoice;
        break;
      case 2:
        type = QuestionType.MultiChoice;
        break;
      case 3:
        type = QuestionType.FillBlank;
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

  /// 题目内容
  final String content;

  /// 题目选项（兼容单选多选）
  final List<String> choices;

  /// 正确选项
  final List<int> correctChoices;

  /// 正确填空
  final String correctBlank;

  /// 用户选项
  List<int> userChoices = [];

  /// 错误填空
  String userBlank = '';

  bool get isFill {
    switch (type) {
      case QuestionType.SingleChoice:
      case QuestionType.MultiChoice:
        return userChoices.isNotEmpty;
      case QuestionType.FillBlank:
        return userBlank.isNotEmpty;
      default:
        return false;
    }
  }

  bool get isCorrect {
    switch (type) {
      case QuestionType.SingleChoice:
      case QuestionType.MultiChoice:
        return userChoices.isNotEmpty &&
            userChoices.toSet().containsAll(correctChoices);
      case QuestionType.FillBlank:
        return true;
      default:
        return false;
    }
  }

  void setChoices(List<int> choices) {
    if (type == QuestionType.SingleChoice || type == QuestionType.MultiChoice) {
      userChoices = choices;
    }
  }

  void setBlank(String blank) {
    if (type == QuestionType.FillBlank) {
      userBlank = blank;
    }
  }

  Map<String, dynamic> toJson() => {
        'qid': qid,
        'type': type.index,
        'content': content,
        'choices': choices,
        'correctChoices': correctChoices,
        'correctBlank': correctBlank,
        'userChoices': userChoices,
        'userBlank': userBlank,
      };

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('\n==========>Question<==========\n');
    sb.write('"qid":$qid,\n');
    sb.write('"type":$type,\n');
    sb.write('"content":`$content`,\n');
    sb.write('"choices":$choices,\n');
    sb.write('"correctChoices":$correctChoices,\n');
    sb.write('"correctBlank":`$correctBlank`,\n');
    sb.write('"userChoices":$userChoices,\n');
    sb.write('"userBlank":`$userBlank`,\n');
    return sb.toString();
  }
}

// void main(List<String> args) {
//   Map<String, dynamic> json = {
//     'qid': 114514,
//     'type': 1,
//     'content': '在维可的回忆中，伊尔缪伊一共使用了多少个“欲望的摇篮”？',
//     'choices': ['两个', '三个', '四个', '五个'],
//     'correctChoices': [0, 1],
//     'correctBlank': '我的世界',
//   };

//   Question q = Question(json);
//   q.setChoices([1, 0]);
//   print(q.isCorrect);
//   print(q.isFill);
//   print(q);
// }
