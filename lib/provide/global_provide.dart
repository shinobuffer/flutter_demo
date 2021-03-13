import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GlobalProvide with ChangeNotifier {
  /// 全局用户token
  String _token;

  /// 全局登录状态
  bool _isLogin = false;

  String get token => _token ?? '';

  bool get isLogin => _isLogin;

  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  void setIsLogin(bool isLogin) {
    _isLogin = isLogin;
    notifyListeners();
  }
}

GlobalProvide getGlobalProvide(BuildContext context, {bool listen = false}) =>
    Provider.of<GlobalProvide>(context, listen: listen);
