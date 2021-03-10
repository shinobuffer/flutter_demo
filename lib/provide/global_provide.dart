import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GlobalProvide with ChangeNotifier {
  /// 用户全局token
  String _token;

  String get token => _token ?? '';

  void setToken(String token) {
    _token = token;
    notifyListeners();
  }
}

GlobalProvide getGlobalProvide(BuildContext context, {bool listen = false}) =>
    Provider.of<GlobalProvide>(context, listen: listen);
