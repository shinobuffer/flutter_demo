import 'package:flutter/material.dart';
import 'package:flutter_demo/model/user_info.dart';
import 'package:flutter_demo/service/api_service.dart';
import 'package:flutter_demo/utils/toast_util.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';

class GlobalProvide with ChangeNotifier {
  /// 全局用户token
  String _token;

  /// 全局登录状态
  bool _isLogin = false;

  /// 全局用户信息
  UserInfo _userInfo = UserInfo.fromJson({});

  String get token => _token ?? '';

  bool get isLogin => _isLogin;

  UserInfo get userInfo => _userInfo;

  /// 自动登录，初始化用户状态，应用初始化时调用
  void tryAutoLogin() {
    String accessToken = SpUtil.getString('access_token');
    String refreshToken = SpUtil.getString('refresh_token');
    if (accessToken.isNotEmpty && refreshToken.isNotEmpty) {
      print('[AUTO LOGIN SUCC]');
      _token = accessToken;
      _isLogin = true;
      updateUserInfo();
    }
  }

  /// 登录账号，初始化用户状态
  void login({
    String accessToken,
    String refreshToken,
    Map<String, dynamic> userInfo,
  }) async {
    print('[LOGIN SUCC]');
    print('[Write accessToken] $accessToken');
    print('[Write refreshToken] $refreshToken');
    await SpUtil.putString('access_token', accessToken);
    await SpUtil.putString('refresh_token', refreshToken);
    _token = accessToken;
    _isLogin = true;
    _userInfo = UserInfo.fromJson(userInfo ?? {});
    notifyListeners();
  }

  /// 退出登录，删除用户态状态
  void logout() {
    SpUtil.remove('access_token');
    SpUtil.remove('refresh_token');
    _token = '';
    _isLogin = false;
    _userInfo = UserInfo.fromJson({});
    ToastUtil.showText(text: '账号退出成功');
    notifyListeners();
  }

  /// 更新用户信息
  void updateUserInfo() async {
    // 没有登录，无法更新
    if (!isLogin) return;
    var resp = await ApiService.getUserInfo();
    // 更新错误弹窗提示，终止更新
    if (!resp.isSucc) {
      ToastUtil.showText(text: resp.msg);
      return;
    }
    _userInfo = UserInfo.fromJson(resp.data ?? {});
    notifyListeners();
  }
}

GlobalProvide getGlobalProvide(BuildContext context, {bool listen = false}) =>
    Provider.of<GlobalProvide>(context, listen: listen);
