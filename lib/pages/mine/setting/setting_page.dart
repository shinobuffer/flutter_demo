import 'package:flutter/material.dart';
import 'package:flutter_demo/component/image_set.dart';
import 'package:flutter_demo/utils/style_util.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
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

  // todo 从provide中获取登录状态，并完成下面的跳转逻辑
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
            Column(
              children: [
                _getMenuItem(
                  title: '账号',
                  trailing: Text('Bersder'),
                  onTap: () {},
                ),
                _getMenuItem(
                  title: '账户',
                  trailing: Row(
                    children: [
                      ImageSet(ImageSets.bcoin, height: 20),
                      Text(
                        ' 23',
                        style: TextStyleM.O1,
                      )
                    ],
                  ),
                  onTap: () {},
                ),
                SizedBox(height: 30),
                _getMenuItem(
                  title: '关于',
                  onTap: () {},
                ),
              ],
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Container(
                height: 35,
                child: RaisedButton(
                  onPressed: () {},
                  color: Colors.white,
                  textColor: ColorM.R2,
                  child: Text('退出登录'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
