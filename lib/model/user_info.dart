class UserInfo {
  /// userInfo数据结构，数据源自后台

  UserInfo.fromJson(Map<String, dynamic> json)
      : nickName = json['nickname'] ?? '',
        introduction = json['introduction'] ?? '',
        sex = json['sex'] ?? 0,
        peeYear = json['peeYear'],
        peeProfession = json['peeProfession'],
        bCoin = json['bcoin'],
        gSeed = json['goldenMelonSeed'];

  /// 昵称
  String nickName;

  /// 介绍
  String introduction;

  /// 性别
  int sex;

  /// 考研年份
  String peeYear;

  /// 考研专业
  int peeProfession;

  /// b币
  double bCoin;

  /// 金瓜子
  int gSeed;

  /// 更新用户信息
  void update(Map<String, dynamic> json) {
    nickName = json['nickname'] ?? '';
    introduction = json['introduction'] ?? '';
    sex = json['sex'] ?? 0;
    peeYear = json['peeYear'];
    peeProfession = json['peeProfession'];
    bCoin = json['bcoin'];
    gSeed = json['goldenMelonSeed'];
  }

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('\n==========>UserInfo<==========\n');
    sb.write('"nickName":`$nickName`,\n');
    sb.write('"introduction":`$introduction`,\n');
    sb.write('"sex":$sex,\n');
    sb.write('"peeYaer":`$peeYear`,\n');
    sb.write('"peeProfession":$peeProfession,\n');
    sb.write('"bCoin":$bCoin,\n');
    sb.write('"gSeed":$gSeed,\n');
    return sb.toString();
  }
}

// void main(List<String> args) {
//   print(UserInfo.fromJson({
//     "bcoin": 4,
//     "peeYear": "2022",
//     "sex": 0,
//     "goldenMelonSeed": 409,
//     "updateTime": "2021-03-22 13:52:29",
//     "lastLoginTime": "2021-03-22 13:03:02",
//     "phone": "13823468874",
//     "createTime": "2021-03-21 00:49:54",
//     "loginIp": "211.66.119.134",
//     "nickname": "oshino",
//     "id": 10,
//     "introduction": "I'm oshino.",
//     "peeProfession": 1,
//     "status": 0
//   }));
// }
