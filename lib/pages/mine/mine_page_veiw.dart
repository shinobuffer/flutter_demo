import 'package:flutter/material.dart';
import 'package:flutter_demo/model/user_info.dart';
import 'package:flutter_demo/provide/global_provide.dart';
import 'package:flutter_demo/utils/screen_util.dart';
import 'package:flutter_demo/utils/style_util.dart';
import 'package:provider/provider.dart';

class MinePageView extends StatefulWidget {
  MinePageView({Key key}) : super(key: key);

  @override
  _MinePageViewState createState() => _MinePageViewState();
}

class _MinePageViewState extends State<MinePageView> {
  /// 渲染Header
  Widget _getHeader() {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.fromLTRB(
        15,
        ScreenUtil.getStatusBarH(context),
        15,
        5,
      ),
      child: Selector<GlobalProvide, UserInfo>(
        selector: (context, provide) => provide.userInfo,
        builder: (context, userInfo, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            child,
            DefaultTextStyle(
              style: TextStyleM.D0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/passerby.png'),
                            alignment: Alignment.topCenter,
                            fit: BoxFit.fitWidth,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          border: Border.all(color: Colors.white60, width: 2),
                        ),
                      ),
                      Text(
                        userInfo.nickName,
                        style: TextStyleM.D0_16_B,
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
              width: 180,
              height: 25,
              alignment: Alignment.center,
              child: Text(
                userInfo.introduction,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyleM.G3,
              ),
            ),
          ],
        ),
        child: Container(
          width: double.maxFinite,
          alignment: Alignment.topRight,
          child: SizedBox(
            height: 40,
            width: 40,
            child: FlatButton(
              onPressed: () {
                Navigator.pushNamed(context, '/mine/setting');
              },
              textColor: Colors.white,
              padding: EdgeInsets.zero,
              shape: CircleBorder(),
              child: Icon(Icons.settings_rounded),
            ),
          ),
        ),
      ),
    );
  }

  /// 渲染统计信息
  Widget _getStatistics() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: ColorM.C1)),
      ),
      child: DefaultTextStyle(
        style: TextStyleM.D5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: '23', style: TextStyleM.O1_24),
                      TextSpan(
                        text: '题',
                        style: TextStyleM.O1,
                      ),
                    ],
                  ),
                ),
                Text('已做题'),
              ],
            ),
            Column(
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: '23', style: TextStyleM.G0_24),
                      TextSpan(
                        text: '小时',
                        style: TextStyleM.G0,
                      ),
                    ],
                  ),
                ),
                Text('做题时间'),
              ],
            ),
            Column(
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: '23', style: TextStyleM.G2_24),
                      TextSpan(
                        text: '%',
                        style: TextStyleM.G2,
                      ),
                    ],
                  ),
                ),
                Text('正确率'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getSection({
    String title,
    Widget content,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                )
              ],
            ),
            child: content,
          )
        ],
      ),
    );
  }

  Widget _getAssetItem({
    Widget icon,
    String label,
    VoidCallback onPressed,
  }) {
    return Column(
      children: [
        Container(
          height: 40,
          width: 40,
          margin: EdgeInsets.only(bottom: 5),
          child: FlatButton(
            padding: EdgeInsets.zero,
            color: ColorM.C1,
            onPressed: onPressed,
            child: icon,
            shape: CircleBorder(),
          ),
        ),
        Text(label)
      ],
    );
  }

  /// 渲染主体内容
  /// todo: 跳转逻辑
  Widget _getMainContent() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          _getStatistics(),
          // 渲染资产栏
          _getSection(
            title: '资产',
            content: Wrap(
              spacing: 20,
              children: [
                _getAssetItem(
                  icon: Image.asset(
                    'assets/images/bcoin.png',
                    height: 24,
                  ),
                  label: 'B币',
                  onPressed: () {
                    Navigator.pushNamed(context, '/mine/bcoin');
                  },
                ),
                _getAssetItem(
                  icon: Image.asset(
                    'assets/images/gseed.png',
                    height: 24,
                  ),
                  label: '金瓜子',
                  onPressed: () {
                    Navigator.pushNamed(context, '/mine/gseed');
                  },
                ),
              ],
            ),
          ),
          // 渲染更多栏目
          _getSection(
            title: '更多',
            content: Wrap(
              spacing: 20,
              children: [
                _getAssetItem(
                  icon: Icon(Icons.notifications_outlined),
                  label: '消息',
                  onPressed: () {},
                ),
                _getAssetItem(
                  icon: Icon(Icons.local_atm_rounded),
                  label: '订单',
                  onPressed: () {},
                ),
                _getAssetItem(
                  icon: Icon(Icons.help_center_outlined),
                  label: '帮助',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // todo: 拉取用户基本信息，资产信息，（总做题数，学习时长，正确率）
    super.initState();
    getGlobalProvide(context).updateUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ColorM.G2,
        child: Column(
          children: [
            _getHeader(),
            Expanded(
              child: _getMainContent(),
            ),
          ],
        ),
      ),
    );
  }
}
