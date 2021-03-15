import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

class ToastUtil {
  /// 需先初始化后才能使用

  ToastUtil._();

  static CancelFunc showText({@required String text}) {
    return BotToast.showText(
      text: text,
      contentColor: Colors.black45,
      borderRadius: BorderRadius.all(
        Radius.circular(5),
      ),
    );
  }
}
