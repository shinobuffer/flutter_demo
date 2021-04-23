import 'dart:convert';

import 'package:flutter_demo/model/record_item.dart';
import 'package:flutter_demo/utils/dio_util.dart';

// 实现将 [0,1,2] 转化为 A,B,C（顺便升序排序）
_choiceIndexes2choiceString(List<int> choices) {
  List<String> alterChoices =
      choices.map((index) => String.fromCharCodes([65 + index])).toList();
  alterChoices.sort((a, b) => a.compareTo(b));
  return alterChoices.join(',');
}

_choiceString2choiceIndexes(String choices) {
  return choices.replaceAll(',', '').codeUnits.map((e) => e - 65).toList();
}

class ApiService {
  static DioUtil dio;

  /// 初始化必须调用
  ApiService.initialize() {
    DioUtil.setBaseOptions(DioUtil.getBaseOptions().merge(
      baseUrl: 'http://103.145.60.199:9527/finaldesign',
      sendTimeout: 10000,
      receiveTimeout: 10000,
    ));
    DioUtil.enableDebug();
    dio = DioUtil();
  }

  /// 自动刷新token
  static Future<Resp<Map<String, dynamic>>> refresh({
    String accessToken,
    String refreshToken,
  }) async {
    print('[accessToken] $accessToken');
    print('[refreshToken] $refreshToken');
    if (accessToken.isNotEmpty && refreshToken.isNotEmpty) {
      Resp<Map<String, dynamic>> resp = await dio.post(
        '/user/refresh',
        queryParameters: {'refresh_token': refreshToken},
      );
      return resp;
    }
  }

  /// 登录接口
  static Future<Resp<Map<String, dynamic>>> login({
    String phone,
    String password,
  }) async {
    Resp<Map<String, dynamic>> resp = await dio.post(
      '/user/login/phone',
      data: {'phone': phone, 'password': password},
    );
    return resp;
  }

  /// 请求验证码接口
  static Future<Resp<String>> applyVerificationCode(String phone) async {
    Resp<String> resp = await dio.fetch(
      '/user/sms',
      queryParameters: {'phone': phone},
    );
    return resp;
  }

  /// 注册接口
  static Future<Resp<Null>> register({
    String phone,
    String password,
    String verificationCode,
  }) async {
    Resp<Null> resp = await dio.post(
      '/user/register/phone/$verificationCode',
      data: {'phone': phone, 'password': password},
    );
    return resp;
  }

  /// 查询用户信息（用户态）
  static Future<Resp<Map<String, dynamic>>> getUserInfo() async {
    Resp<Map<String, dynamic>> resp = await dio.fetch('/user/info');
    return resp;
  }

  /// 更新用户信息（用户态）
  static Future<Resp<Null>> updateUserInfo({
    String nickname,
    String introduction,
    String peeYear,
    int peeProfession,
    int sex,
  }) async {
    Resp<Null> resp = await dio.put('/user/update', data: {
      'nickname': nickname,
      'introduction': introduction,
      'peeYear': peeYear,
      'peeProfession': peeProfession,
      'sex': sex
    });
    return resp;
  }

  /// b币充值（用户态）
  static Future<Resp<Null>> recharge(int value) async {
    Resp<Null> resp = await dio.put('/pay/recharge/$value');
    return resp;
  }

  /// 瓜子兑换（用户态）
  static Future<Resp<Null>> exchange(int bcoin) async {
    Resp<Null> resp = await dio.put('/pay/exchange/$bcoin');
    return resp;
  }

  /// b币记录（用户态）
  static Future<Resp<List<Map<String, dynamic>>>> getBCoinHistory() async {
    Resp resp = await dio.fetch('/user/bCoinList');
    resp.data = jsonDecode(resp.data ?? '[]');
    // 因为后台网关的破坏
    return Resp(
      resp.status,
      resp.code,
      resp.msg,
      resp.data?.cast<Map<String, dynamic>>(),
    );
  }

  /// 瓜子记录（用户态）
  static Future<Resp<List<Map<String, dynamic>>>> getGoldSeedHistory() async {
    Resp resp = await dio.fetch('/user/goldenMelonSeedList');
    resp.data = jsonDecode(resp.data ?? '[]');
    return Resp(
      resp.status,
      resp.code,
      resp.msg,
      resp.data?.cast<Map<String, dynamic>>(),
    );
  }

  /// 购买模拟卷
  static Future<Resp<Null>> purchaseSimTest(int tid) async {
    Resp<Null> resp = await dio.post('/pay/purchase/$tid');
    return resp;
  }

  /// 获取真题/模拟试卷列表
  static Future<Resp<List<Map<String, dynamic>>>> getTestInfosBySubjectId(
      {int subjectId, bool isFree, bool isRealTest}) async {
    Map<String, dynamic> queries = {
      'subjectId': subjectId,
    };
    if (isRealTest != null) {
      queries.putIfAbsent('isRealTest', () => isRealTest.toString());
    }
    if (isFree != null) {
      queries.putIfAbsent('isFree', () => isFree.toString());
    }
    Resp resp = await dio.fetch(
      '/sheet/sheetList',
      queryParameters: queries,
    );
    resp.data = jsonDecode(resp.data ?? '[]');
    return Resp(
      resp.status,
      resp.code,
      resp.msg,
      resp.data?.cast<Map<String, dynamic>>(),
    );
  }

  /// 获取试卷的题目
  static Future<Resp<List<Map<String, dynamic>>>> getQuestionsOfTest(
    int tid,
  ) async {
    Resp resp = await dio.fetch(
      '/sheet/questionList',
      queryParameters: {'sheetId': tid},
    );
    resp.data = jsonDecode(resp.data ?? '[]');
    return Resp(
      resp.status,
      resp.code,
      resp.msg,
      resp.data?.cast<Map<String, dynamic>>(),
    );
  }

  /// 批量获取题目
  static Future<Resp<List<Map<String, dynamic>>>> getQuestionsByQids(
    List<int> qids,
  ) async {
    Resp resp = await dio.fetch(
      '/sheet/questionList',
      queryParameters: {'questionIds': qids.join(',')},
    );
    resp.data = jsonDecode(resp.data ?? '[]');
    return Resp(
      resp.status,
      resp.code,
      resp.msg,
      resp.data?.cast<Map<String, dynamic>>(),
    );
  }

  /// 获取错题列表
  static Future<Resp<List<Map<String, dynamic>>>> getWrongItemsBySubjectId(
    int subjectId,
  ) async {
    Resp resp = await dio.fetch(
      '/sheet/mistake',
      queryParameters: {'subjectId': subjectId},
    );
    resp.data = jsonDecode(resp.data ?? '[]');
    return Resp(
      resp.status,
      resp.code,
      resp.msg,
      resp.data?.cast<Map<String, dynamic>>(),
    );
  }

  /// 批量增加错题
  static Future<Resp<Null>> addWrongQuestions({
    int tid,
    int subjectId,
    Map<int, List<int>> answerMap,
  }) async {
    Resp<Null> resp = await dio.post(
      '/sheet/mistake',
      data: {
        'sheetId': tid,
        'subjectId': subjectId,
        'mistakeMap': answerMap.map(
          (key, value) => MapEntry(
            key.toString(),
            _choiceIndexes2choiceString(value),
          ),
        ),
      },
    );
    return resp;
  }

  /// 删除单条错题
  static Future<Resp<Null>> removeWrongQuestion(int qid) async {
    Resp<Null> resp = await dio.delete(
      '/sheet/mistake/$qid',
    );
    return resp;
  }

  /// 获取收藏列表
  static Future<Resp<List<Map<String, dynamic>>>> getCollectItemsBySubjectId(
    int subjectId,
  ) async {
    Resp resp = await dio.fetch(
      '/sheet/collection',
      queryParameters: {'subjectId': subjectId},
    );
    resp.data = jsonDecode(resp.data ?? '[]');
    return Resp(
      resp.status,
      resp.code,
      resp.msg,
      resp.data?.cast<Map<String, dynamic>>(),
    );
  }

  /// 收藏单条题目
  static Future<Resp<Null>> addCollectedQuestion({
    int tid,
    int subjectId,
    int qid,
  }) async {
    Resp<Null> resp = await dio.post(
      '/sheet/collection',
      data: {
        'sheetId': tid,
        'subjectId': subjectId,
        'questionId': qid,
      },
    );
    return resp;
  }

  /// 删除单条收藏
  static Future<Resp<Null>> removeCollectedQuestion(int qid) async {
    Resp<Null> resp = await dio.delete(
      '/sheet/collection/$qid',
    );
    return resp;
  }

  /// 新增或更新记录
  static Future<Resp<Null>> postRecord({
    RecordItem recordItem,
    Map<int, List<int>> answerMap,
  }) async {
    Map<String, dynamic> data = recordItem.toJson();
    data.putIfAbsent(
      'choiceMap',
      () => answerMap.map(
        (key, value) => MapEntry(
          key.toString(),
          _choiceIndexes2choiceString(value),
        ),
      ),
    );
    Resp<Null> resp;
    if (recordItem.rid == null) {
      print('创建Record');
      resp = await dio.post(
        '/sheet/record',
        data: data,
      );
    } else {
      print('更新Record');
      resp = await dio.put(
        '/sheet/record',
        data: data,
      );
    }
    return resp;
  }

  /// 获取记录列表
  static Future<Resp<List<Map<String, dynamic>>>> getRecordItemsBySubjectId(
    int subjectId,
  ) async {
    Resp resp = await dio.fetch(
      '/sheet/record',
      queryParameters: {'subjectId': subjectId},
    );
    resp.data = jsonDecode(resp.data ?? '[]');
    return Resp(
      resp.status,
      resp.code,
      resp.msg,
      resp.data?.cast<Map<String, dynamic>>(),
    );
  }

  /// 删除单条记录
  static Future<Resp<Null>> removeRecord(int rid) async {
    Resp<Null> resp = await dio.delete(
      '/sheet/record/$rid',
    );
    return resp;
  }

  /// 获取记录answerMap
  static Future<Resp<Map<int, List<int>>>> getAnswerMapOfRecord(int rid) async {
    Resp<Map<String, dynamic>> resp = await dio.fetch(
      '/sheet/record/answer',
      queryParameters: {'recordId': rid},
    );
    resp.data ??= {};
    return Resp(
      resp.status,
      resp.code,
      resp.msg,
      resp.data.map(
        (key, value) => MapEntry(
          int.tryParse(key) ?? -1,
          _choiceString2choiceIndexes(value),
        ),
      ),
    );
  }

  /// 获取记录统计数据
  static Future<Resp<Map<String, dynamic>>> getStatisticsBySubjectId(
      [int subjectId = 0]) async {
    Resp<Map<String, dynamic>> resp = await dio.fetch(
      '/sheet/record/total',
      queryParameters: {'subjectId': subjectId},
    );
    return resp;
  }
}
