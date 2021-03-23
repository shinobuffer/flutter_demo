import 'package:flutter/material.dart';
import 'package:flutter_demo/utils/style_util.dart';

Future<T> showCancelOkDialog<T>({
  @required BuildContext context,
  String title,
  String content,
  String cancelText = '取消',
  String okText = '确定',
  Color okColor,
  bool dismissible = false,
  Function onCancel,
  Function onOk,
}) async {
  return await showDialog<T>(
    barrierDismissible: dismissible,
    context: context,
    builder: (context) => AlertDialog(
      title: Text('$title'),
      titlePadding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      content: Text('$content'),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      actions: [
        RaisedButton(
          onPressed: onCancel ?? () => Navigator.pop(context, false),
          child: Text('$cancelText'),
        ),
        RaisedButton(
          color: okColor ?? Theme.of(context).primaryColor,
          onPressed: onOk ?? () => Navigator.pop(context, true),
          child: Text(
            '$okText',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}

Future<T> showConfirmDialog<T>({
  @required BuildContext context,
  @required Widget content,
  String title,
  String confirmText = '确定',
  Color confirmColor,
  bool allowReturn = true,
  bool dismissible = false,
  Function onConfirm,
}) async {
  return await showDialog<T>(
    barrierDismissible: dismissible,
    context: context,
    builder: (context) => WillPopScope(
      child: AlertDialog(
        title: Text(
          '$title',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        titlePadding: EdgeInsets.fromLTRB(20, 15, 20, 0),
        content: content,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        actions: [
          Container(
            width: double.maxFinite,
            child: RaisedButton(
              color: confirmColor ?? Theme.of(context).primaryColor,
              child: Text(
                '$confirmText',
                style: TextStyleM.D0,
              ),
              onPressed: onConfirm ?? () => Navigator.pop(context),
            ),
          )
        ],
      ),
      onWillPop: () async => allowReturn,
    ),
  );
}

Future<T> showBottomModal<T>({
  @required BuildContext context,
  @required Widget body,
  ShapeBorder shape,
  Color backgroundColor = Colors.white,
  bool dismissible = true,
  bool dragable = true,
}) async {
  return await showModalBottomSheet<T>(
    context: context,
    builder: (BuildContext context) => body,
    backgroundColor: backgroundColor,
    shape: shape ??
        RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15),
          ),
        ),
    isScrollControlled: true,
    isDismissible: dismissible,
    enableDrag: dragable,
  );
}
