import 'package:flutter/material.dart';
import 'package:flutter_demo/utils/style_util.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class CorrectionFeedback extends StatefulWidget {
  CorrectionFeedback({
    Key key,
    @required this.name,
    @required this.qid,
  }) : super(key: key);

  final String name;

  final int qid;

  @override
  _CorrectionFeedbackState createState() => _CorrectionFeedbackState();
}

class _CorrectionFeedbackState extends State<CorrectionFeedback> {
  TextEditingController _contentController;

  String get content => _contentController.text;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Container(
          height: 220,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(15),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 反馈标题
              Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${widget.name}',
                        style: TextStyleM.D4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      height: 20,
                      width: 20,
                      margin: EdgeInsets.only(left: 10),
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: ColorM.C4,
                        ),
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
              // 反馈输入区
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.top,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    expands: true,
                    style: TextStyleM.D7_14,
                    decoration: InputDecoration(
                      hintText: '反馈错误（题目、选项、答案）',
                      fillColor: ColorM.C1,
                      hintStyle: TextStyleM.D4,
                      filled: true,
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    controller: _contentController,
                  ),
                ),
              ),
              // 反馈按钮
              Container(
                height: 40,
                width: double.maxFinite,
                child: OutlinedButton(
                  child: Text('反馈'),
                  onPressed: () {
                    // todo: 反馈逻辑
                    print(content);
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
