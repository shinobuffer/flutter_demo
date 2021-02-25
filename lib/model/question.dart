enum QuestionType {
  SingleChoice,
  MultiChoice,
  FillBlank,
}

class Question {
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

  Question(Map question)
      : assert(question['qid'] is int),
        assert(question['content'] is String),
        assert(question['choices'] is List<String>),
        assert(question['correctChoices'] == null || question['correctChoices'] is List<int>),
        assert(question['correctBlank'] == null || question['correctBlank'] is String),
        qid = question['qid'],
        content = question['content'],
        choices = question['choices'],
        correctChoices = question['correctChoices'] ?? [],
        correctBlank = question['correctBlank'] ?? '' {
    switch (question['type']) {
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
        throw ArgumentError("question[type] should be non-null");
    }
  }

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
        return userChoices.isNotEmpty && userChoices.toSet().containsAll(correctChoices);
      case QuestionType.FillBlank:
        return true;
      default:
        return false;
    }
  }

  void setChoices(List<int> choices) {
    userChoices = choices;
  }

  void setBlank(String blank) {
    userBlank = blank;
  }

  Map<String, dynamic> toJson() => {};
}

// void main(List<String> args) {
//   Map question = {
//     'qid': 114514,
//     'type': 1,
//     'content': '在维可的回忆中，伊尔缪伊一共使用了多少个“欲望的摇篮”？',
//     'choices': ['两个', '三个', '四个', '五个'],
//     'correctChoices': [0, 1],
//     'correctBlank': '我的世界',
//   };

//   Question q = Question(question);
//   print(q.isCorrect);
//   print(q.isFill);
//   q.setChoices([1, 0]);
//   print(q.isCorrect);
//   print(q.isFill);
// }
