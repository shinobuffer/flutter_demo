import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/pages/user_password_mixin.dart';
import 'package:flutter_demo/service/api_service.dart';
import 'package:flutter_demo/utils/screen_util.dart';
import 'package:flutter_demo/utils/style_util.dart';
import 'package:flutter_demo/utils/toast_util.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with UserPasswordMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _vCodeController = TextEditingController();

  /// 注册请求结束前，禁止再次注册
  bool isRegistering = false;
  Timer timer;

  /// 当倒计时不为0，不允许请求验证码
  int countDown = 0;

  String get vCode => _vCodeController.text;
  bool get countDownIsOver => countDown <= 0;

  @override
  void onToggleVisibility() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  /// 申请验证码并开始倒计时
  void applyForCode() async {
    // 账号（手机）不合法，返回
    if (!userKey.currentState.validate()) return;
    // 正在倒计时中，禁止重复申请，返回
    if (!countDownIsOver) return;
    // 申请验证码，设置倒计时
    var resp = await ApiService.applyVerificationCode(user);
    if (resp.code != 0) {
      // 申请异常
      ToastUtil.showText(text: resp.msg);
    } else {
      // 申请成功
      ToastUtil.showText(
          text: '验证码：${resp.data}', duration: Duration(seconds: 10));
    }

    setState(() {
      countDown = 30;
    });
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      // 倒计时完成，自动停止
      if (countDownIsOver) {
        timer?.cancel();
        return;
      }
      setState(() {
        countDown--;
      });
    });
  }

  /// 注册
  void doRegister() {
    if (_formKey.currentState.validate()) {
      setState(() {
        isRegistering = true;
      });
      ApiService.register(
        phone: user,
        password: password,
        verificationCode: vCode,
      ).then((resp) {
        ToastUtil.showText(text: resp.msg);
        if (resp.code == 0) {
          Navigator.pop(context);
        }
        setState(() {
          isRegistering = false;
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
          width: double.maxFinite,
          padding:
              EdgeInsets.fromLTRB(30, ScreenUtil.getStatusBarH(context), 30, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 80,
                width: double.maxFinite,
                alignment: Alignment.centerRight,
              ),
              Text(
                '账号注册',
                style: TextStyleM.D7_24_B,
              ),
              SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    getUserTextField(context),
                    SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                        LengthLimitingTextInputFormatter(6),
                      ],
                      decoration: InputDecoration(
                        labelText: '验证码',
                        contentPadding: EdgeInsets.only(right: 10),
                        suffix: SizedBox(
                          height: 20,
                          width: 60,
                          child: FlatButton(
                            padding: EdgeInsets.zero,
                            onPressed: countDownIsOver ? applyForCode : null,
                            child: Text(
                              countDownIsOver ? '获取验证码' : '还剩${countDown}s',
                              style: TextStyleM.D4_12,
                            ),
                          ),
                        ),
                      ),
                      validator: (value) => RegExp(r'^\d{6}$').hasMatch(value)
                          ? null
                          : '请输入6位验证码',
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                      controller: _vCodeController,
                    ),
                    SizedBox(height: 20),
                    getPasswordTextField(),
                  ],
                ),
              ),
              Container(
                height: 34,
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 20),
                margin: EdgeInsets.symmetric(vertical: 30),
                child: FlatButton(
                  color: Colors.teal,
                  disabledColor: ColorM.C3,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(17),
                    ),
                  ),
                  onPressed: isRegistering ? null : doRegister,
                  child: Text('注册'),
                ),
              ),
              SizedBox(
                height: 20,
                width: 60,
                child: FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.zero,
                  textColor: ColorM.C5,
                  child: Text(
                    '账号登录',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
