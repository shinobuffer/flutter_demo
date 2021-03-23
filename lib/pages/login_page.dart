import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/user_password_mixin.dart';
import 'package:flutter_demo/provide/global_provide.dart';
import 'package:flutter_demo/service/api_service.dart';
import 'package:flutter_demo/utils/screen_util.dart';
import 'package:flutter_demo/utils/style_util.dart';
import 'package:flutter_demo/utils/toast_util.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with UserPasswordMixin {
  final _formKey = GlobalKey<FormState>();

  /// 登录请求结束前，禁止再次登录
  bool isLoging = false;

  @override
  void onToggleVisibility() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  /// 登录
  void doLogin() {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoging = true;
      });
      ApiService.login(phone: user, password: password).then((resp) {
        ToastUtil.showText(text: resp.msg);
        if (resp.code == 0) {
          getGlobalProvide(context).login(
            accessToken: resp.data['jwt']['access_token'],
            refreshToken: resp.data['jwt']['refresh_token'],
          );
          Navigator.pop(context);
        }
        setState(() {
          isLoging = false;
        });
      });
    }
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
                // alignment: Alignment.centerRight,
                // child: GestureDetector(
                //   onTap: () {
                //     Navigator.pop(context);
                //   },
                //   child: Text(' 跳过 '),
                // ),
              ),
              Text(
                '登录享受更多服务',
                style: TextStyleM.D7_24_B,
              ),
              SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    getUserTextField(context),
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
                  onPressed: isLoging ? null : doLogin,
                  child: Text('登录'),
                ),
              ),
              SizedBox(
                height: 20,
                width: 100,
                child: FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  padding: EdgeInsets.zero,
                  textColor: ColorM.C5,
                  child: Text(
                    '注册/忘记密码',
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
