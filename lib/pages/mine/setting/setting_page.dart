import 'package:flutter/material.dart';
import 'package:flutter_demo/component/image_set.dart';
import 'package:flutter_demo/provide/global_provide.dart';
import 'package:flutter_demo/utils/dialog_util.dart';
import 'package:flutter_demo/utils/style_util.dart';
import 'package:flutter_demo/utils/toast_util.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  /// 退出登录
  void doLogout() {
    showCancelOkDialog<bool>(
      context: context,
      title: '退出账号',
      content: '确定退出当前账号',
      dismissible: true,
    ).then((confirmed) {
      if (confirmed == true) {
        getGlobalProvide(context).logout();
      }
    });
  }

  /// 登录跳转
  void jump2Login() {
    Navigator.pushNamed(context, '/login');
  }

  /// 未登录提示登录，登录跳profile页
  void goProfile() {
    if (getGlobalProvide(context).isLogin) {
      Navigator.pushNamed(context, '/profile');
    } else {
      ToastUtil.showText(text: '请先登录');
    }
  }

  /// 未登录提示登录，登录跳b币页面
  void goAccount() {
    if (getGlobalProvide(context).isLogin) {
      Navigator.pushNamed(context, '/mine/bcoin');
    } else {
      ToastUtil.showText(text: '请先登录');
    }
  }

  /// 关于
  void popAbout() {
    showConfirmDialog(
      context: context,
      title: '关于',
      content: Text('关于内容'),
      dismissible: true,
    );
  }

  Widget _getMenuItem({String title, Widget trailing, VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: double.maxFinite,
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
        margin: EdgeInsets.only(bottom: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Row(
              children: [
                trailing ?? Container(),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 30,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 从provide中获取登录状态，并完成下面的跳转逻辑
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
        centerTitle: true,
      ),
      body: Container(
        color: ColorM.C0,
        child: Stack(
          children: [
            Consumer<GlobalProvide>(
              builder: (context, provide, child) {
                bool isLogin = provide.isLogin;
                var userInfo = provide.userInfo;
                return Column(
                  children: [
                    _getMenuItem(
                      title: '账号',
                      trailing: Text(isLogin ? userInfo.nickName : '请先登录'),
                      onTap: goProfile,
                    ),
                    _getMenuItem(
                      title: '账户',
                      trailing: isLogin
                          ? Row(
                              children: [
                                ImageSet(ImageSets.bcoin, height: 20),
                                Text(
                                  ' ${userInfo.bCoin}',
                                  style: TextStyleM.O1,
                                )
                              ],
                            )
                          : Container(),
                      onTap: goAccount,
                    ),
                    SizedBox(height: 30),
                    _getMenuItem(
                      title: '关于',
                      onTap: popAbout,
                    ),
                  ],
                );
              },
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Selector<GlobalProvide, bool>(
                selector: (context, provide) => provide.isLogin,
                builder: (context, isLogin, child) => Container(
                  height: 35,
                  child: RaisedButton(
                    onPressed: isLogin ? doLogout : jump2Login,
                    color: Colors.white,
                    textColor: isLogin ? ColorM.R2 : ColorM.G2,
                    child: Text(isLogin ? '退出登录' : '登录'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
