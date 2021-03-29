class Statistics {
  Statistics.fromJson(Map<String, dynamic> json)
      : doneNum = json['doneNum'] ?? 0,
        costSeconds = json['costSeconds'] ?? 0,
        correctRate = json['correctRate'] ?? 0;

  final int doneNum;
  final int costSeconds;
  final int correctRate;

  String get doneNumStr {
    if (doneNum == 0) return '--';
    if (doneNum < 1000) {
      return doneNum.toString();
    }
    return (doneNum / 1000.0).toStringAsFixed(1) + 'k';
  }

  String get costTimeStr {
    if (costSeconds == 0) return '--';
    if (costSeconds < 3600) return '${costSeconds ~/ 60}';
    return (costSeconds / 3600.0).toStringAsFixed(1);
  }

  String get costTimeUnit {
    if (costSeconds == 0) return '';
    if (costSeconds < 3600) return '分钟';
    return '小时';
  }

  String get correctRateStr => correctRate == 0 ? '--' : correctRate.toString();
}
