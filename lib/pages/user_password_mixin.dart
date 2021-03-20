import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

mixin UserPasswordMixin {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool passwordVisible = false;

  String get user => userController.text;
  String get password => passwordController.text;

  /// 需要实现passwordVisible反转逻辑
  void onToggleVisibility();

  Widget getUserTextField(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        LengthLimitingTextInputFormatter(11),
      ],
      decoration: InputDecoration(
        labelText: '手机号',
        contentPadding: EdgeInsets.only(right: 10),
        suffix: GestureDetector(
          onTap: () => userController.text = '',
          child: Icon(Icons.close_rounded),
        ),
      ),
      validator: (value) =>
          RegExp(r'^\d{11}$').hasMatch(value) ? null : '请输入正确的手机号码',
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
      controller: userController,
    );
  }

  Widget getPasswordTextField() {
    return TextFormField(
      obscureText: !passwordVisible,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9A-Za-z]')),
      ],
      decoration: InputDecoration(
        labelText: '密码',
        contentPadding: EdgeInsets.only(right: 10),
        suffix: GestureDetector(
          onTap: onToggleVisibility,
          child: Icon(
            passwordVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
        ),
      ),
      validator: (value) => value.isNotEmpty ? null : '请输入密码',
      controller: passwordController,
    );
  }
}
