import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/learning/question_bank/collect_test/collect_test_page.dart';
import 'package:flutter_demo/pages/learning/question_bank/question_bank_page.dart';
import 'package:flutter_demo/pages/learning/question_bank/real_test/real_test_page.dart';
import 'package:flutter_demo/pages/learning/question_bank/record_test/record_test_page.dart';
import 'package:flutter_demo/pages/learning/question_bank/simulation_test/simulation_test_page.dart';
import 'package:flutter_demo/pages/learning/question_bank/wrong_test/wrong_test_page.dart';
import 'package:flutter_demo/pages/learning/task/task_page.dart';
import 'package:flutter_demo/pages/login_page.dart';
import 'package:flutter_demo/pages/mine/setting/setting_page.dart';
import 'package:flutter_demo/pages/profile_page.dart';
import 'package:flutter_demo/pages/register_page.dart';

typedef PageBuilder = Widget Function(BuildContext context,
    {dynamic arguments});

final Map<String, PageBuilder> _routes = {
  '/question_bank': (context, {arguments}) => QuestionBankPage(),
  '/task': (context, {arguments}) => TaskPage(),
  '/question_bank/real_test': (context, {arguments}) =>
      RealTestPage(arguments: arguments),
  '/question_bank/simulation_test': (context, {arguments}) =>
      SimulationTestPage(arguments: arguments),
  '/question_bank/wrong_test': (context, {arguments}) =>
      WrongTestPage(arguments: arguments),
  '/question_bank/collect_test': (context, {arguments}) =>
      CollectTestPage(arguments: arguments),
  '/question_bank/record_test': (context, {arguments}) =>
      RecordTestPage(arguments: arguments),
  '/mine/setting': (context, {arguments}) => SettingPage(),
  '/login': (context, {arguments}) => LoginPage(),
  '/register': (context, {arguments}) => RegisterPage(),
  '/profile': (context, {arguments}) => ProfilePage(),
};

final RouteFactory onGenerateRoute = (RouteSettings settings) {
  final String routeName = settings.name;
  print('[JUMP TO] $routeName');
  final PageBuilder pageBuilder = _routes[routeName];
  if (pageBuilder != null) {
    return MaterialPageRoute(
      builder: (context) =>
          pageBuilder(context, arguments: settings.arguments ?? {}),
    );
  }
  return MaterialPageRoute(builder: (context) => _NotFindPage());
};

class _NotFindPage extends StatelessWidget {
  const _NotFindPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('404'),
        centerTitle: true,
      ),
      body: Container(child: Text('you are not supposed to be here')),
    );
  }
}
