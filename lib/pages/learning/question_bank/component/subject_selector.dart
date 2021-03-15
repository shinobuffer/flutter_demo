import 'package:flutter/material.dart';
import 'package:flutter_demo/utils/screen_util.dart';
import 'package:flutter_demo/utils/style_util.dart';
import 'package:flutter_demo/utils/toast_util.dart';

class SubjectSelector extends StatefulWidget {
  SubjectSelector({Key key}) : super(key: key);

  @override
  _SubjectSelectorState createState() => _SubjectSelectorState();
}

class _SubjectSelectorState extends State<SubjectSelector> {
  // todo: 拉取科目信息
  List<SubjectData> subjects = [
    SubjectData.fromJson({
      'type': '公共课',
      'typeId': 0,
      'items': [
        {
          'subject': '政治',
          'subjectId': 0,
        },
        {
          'subject': '数学一',
          'subjectId': 1,
        },
        {
          'subject': '数学二',
          'subjectId': 2,
        },
        {
          'subject': '数学三',
          'subjectId': 3,
        },
        {
          'subject': '英语一',
          'subjectId': 4,
        },
        {
          'subject': '英语二',
          'subjectId': 5,
        },
      ],
    }),
    SubjectData.fromJson({
      'type': '统考专业课',
      'typeId': 1,
      'items': [
        {
          'subject': '法硕',
          'subjectId': 10,
        },
        {
          'subject': '农学',
          'subjectId': 11,
        },
        {
          'subject': '教育学',
          'subjectId': 12,
        },
        {
          'subject': '历史学',
          'subjectId': 13,
        },
        {
          'subject': '心理学',
          'subjectId': 14,
        },
        {
          'subject': '计算机',
          'subjectId': 15,
        },
        {
          'subject': '西医综合',
          'subjectId': 16,
        },
      ],
    }),
  ];

  List<int> previousSubjectIds = [0];
  List<int> selectedSubjectIds = [];

  /// todo: 科目保存
  void onSave() async {
    if (selectedSubjectIds.isEmpty) {
      ToastUtil.showText(text: '请至少选择一个科目');
    } else if (previousSubjectIds.length == selectedSubjectIds.length &&
        previousSubjectIds.toSet().containsAll(selectedSubjectIds)) {
      // 没有变更
      Navigator.pop(context, false);
    } else {
      // 变更
      ToastUtil.showText(text: '修改成功');
      Navigator.pop(context, true);
    }
  }

  List<Widget> _getSubjectSections() {
    List<Widget> renderWidgets = [];
    subjects.forEach((subject) {
      renderWidgets.add(
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(subject.type),
              Wrap(
                spacing: 10,
                children: subject.items.map((item) {
                  int subjectId = item.subjectId;
                  bool isSelected = selectedSubjectIds.contains(subjectId);
                  return ChoiceChip(
                    label: Text(item.subject),
                    labelStyle: isSelected ? TextStyleM.D0 : TextStyleM.D5,
                    selected: isSelected,
                    selectedColor: ColorM.G3,
                    onSelected: (selected) {
                      setState(() {
                        selected
                            ? selectedSubjectIds.add(subjectId)
                            : selectedSubjectIds.remove(subjectId);
                      });
                    },
                  );
                }).toList(),
              )
            ],
          ),
        ),
      );
    });
    return renderWidgets;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil.getScreenH(context) - 100,
      child: Column(
        children: [
          Container(
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: ColorM.C2),
              ),
            ),
            child: Text(
              '修改科目',
              style: TextStyleM.D7_18_B,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: _getSubjectSections(),
              ),
            ),
          ),
          Container(
            height: 40,
            width: double.maxFinite,
            child: OutlinedButton(
              child: Text(
                '保存',
              ),
              onPressed: onSave,
            ),
          )
        ],
      ),
    );
  }
}

class SubjectData {
  /// 主类科目
  SubjectData(Map<String, dynamic> json)
      : type = json['type'],
        typeId = json['typeId'] {
    if (json['items'] is List) {
      List<Map<String, dynamic>> tmp =
          json['items']?.cast<Map<String, dynamic>>();
      _items = tmp.map((e) => SubjectItem.fromJson(e)).toList();
    } else {
      _items = [];
    }
  }

  SubjectData.fromJson(Map<String, dynamic> json) : this(json);

  final String type;
  final int typeId;
  List<SubjectItem> _items;
  List<SubjectItem> get items => _items;

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('\n==========>SubjectData<==========\n');
    sb.write('"type":`$type`,\n');
    sb.write('"typeId":$typeId,\n');
    sb.write('"items":$items,\n');
    return sb.toString();
  }
}

class SubjectItem {
  /// 具体科目
  SubjectItem(Map<String, dynamic> json)
      : subject = json['subject'],
        subjectId = json['subjectId'];

  SubjectItem.fromJson(Map<String, dynamic> json) : this(json);

  final String subject;
  final int subjectId;

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('\n==========>SubjectItem<==========\n');
    sb.write('"subject":`$subject`,\n');
    sb.write('"subjectId":$subjectId,\n');
    return sb.toString();
  }
}
