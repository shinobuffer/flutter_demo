import 'package:flutter/material.dart';
import 'package:flutter_demo/component/loading_first_screen.dart';
import 'package:flutter_demo/model/user_info.dart';
import 'package:flutter_demo/service/api_service.dart';
import 'package:flutter_demo/utils/screen_util.dart';
import 'package:flutter_demo/utils/style_util.dart';
import 'package:flutter_demo/utils/toast_util.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const List<String> _sexList = [
    '保密',
    '男生',
    '女生',
  ];
  static const List<String> _professionList = ['软件工程', '网络工程', '电子工程'];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nickNameController = TextEditingController();
  final TextEditingController _introController = TextEditingController();

  /// 性别 0、1、2分别为未知、男、女
  int sex = 0;

  /// 考研年份
  String peeYear;

  /// 考研专业ID
  int peeProfession;

  String get nickName => _nickNameController.text;
  String get intro => _introController.text;

  set nickName(String value) => _nickNameController.text = value;
  set intro(String value) => _introController.text = value;

  List<int> get selectablePeeYears =>
      List.generate(4, (index) => DateTime.now().year + index);

  Future<void> initFuture;

  /// 首屏数据初始化
  Future<void> initData() async {
    var resp = await ApiService.getUserInfo();
    if (resp.code != 0) ToastUtil.showText(text: resp.msg);
    UserInfo userInfo = UserInfo.fromJson(resp.data ?? {});
    setState(() {
      nickName = userInfo.nickName;
      intro = userInfo.introduction;
      sex = userInfo.sex;
      peeYear = userInfo.peeYear;
      peeProfession = userInfo.peeProfession;
    });
  }

  /// 更新用户信息
  void updateUserInfo() {
    ApiService.updateUserInfo(
      nickname: nickName,
      introduction: intro,
      sex: sex,
      peeYear: peeYear,
      peeProfession: peeProfession,
    ).then((resp) => ToastUtil.showText(text: resp.msg));
  }

  /// 渲染头像区域
  Widget _getAvatar() {
    return Column(
      children: [
        Container(
          height: 70,
          width: 70,
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: ColorM.C1, shape: BoxShape.circle),
          child: Icon(
            Icons.sentiment_very_dissatisfied_rounded,
            color: ColorM.C3,
            size: 50,
          ),
        ),
        Text(
          '上传头像暂不支持',
          style: TextStyleM.D4,
        ),
      ],
    );
  }

  /// 渲染性别选择
  Widget _getSexSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        _sexList.length,
        (index) => Row(
          children: [
            Radio(
              value: index,
              groupValue: sex,
              onChanged: (value) {
                setState(() {
                  sex = value;
                });
              },
            ),
            Text(_sexList[index]),
          ],
        ),
      ),
    );
  }

  /// 渲染表单
  Widget _getForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: '昵称',
              contentPadding: EdgeInsets.only(right: 10),
            ),
            validator: (value) =>
                RegExp(r'^\s*$').hasMatch(value) ? '昵称非空' : null,
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
            controller: _nickNameController,
          ),
          SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              labelText: '个人介绍',
              contentPadding: EdgeInsets.only(right: 10),
            ),
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
            controller: _introController,
          ),
          SizedBox(height: 10),
          DropdownButtonFormField<String>(
            hint: Text('选择考研年份'),
            value: peeYear,
            items: selectablePeeYears
                .map(
                  (year) => DropdownMenuItem(
                    child: Text('$year'),
                    value: '$year',
                  ),
                )
                .toList(),
            onChanged: (String value) {
              setState(() {
                peeYear = value;
              });
            },
          ),
          SizedBox(height: 10),
          DropdownButtonFormField<String>(
            hint: Text('选择考研专业'),
            value:
                peeProfession == null ? null : _professionList[peeProfession],
            items: _professionList
                .map(
                  (profession) => DropdownMenuItem(
                    child: Text(profession),
                    value: profession,
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                peeProfession = _professionList.indexOf(value);
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initFuture = initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LoadingFirstScreen(
        future: initFuture,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.fromLTRB(
                40, ScreenUtil.getStatusBarH(context), 40, 0),
            child: Column(
              children: [
                Container(
                  height: 80,
                  width: double.maxFinite,
                ),
                Text(
                  '填写基本信息',
                  style: TextStyleM.D7_24_B,
                ),
                _getAvatar(),
                _getSexSelector(),
                Divider(height: 20, thickness: 1),
                _getForm(),
                Container(
                  height: 34,
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  margin: EdgeInsets.symmetric(vertical: 30),
                  child: FlatButton(
                    color: Colors.teal,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(17),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        print('wwww');
                        updateUserInfo();
                      }
                    },
                    child: Text('保存'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
