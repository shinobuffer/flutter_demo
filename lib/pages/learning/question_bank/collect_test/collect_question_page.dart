import 'package:flutter/material.dart';
import 'package:flutter_demo/component/loading_first_screen.dart';
import 'package:flutter_demo/model/collect_item.dart';
import 'package:flutter_demo/model/question.dart';
import 'package:flutter_demo/pages/learning/question_bank/component/question_page_view.dart';
import 'package:flutter_demo/service/api_service.dart';
import 'package:flutter_demo/utils/style_util.dart';
import 'package:flutter_demo/utils/toast_util.dart';

class CollectQuestionPage extends StatefulWidget {
  CollectQuestionPage({
    Key key,
    @required this.collectItem,
  }) : super(key: key);

  final CollectItem collectItem;

  @override
  _CollectQuestionPageState createState() => _CollectQuestionPageState();
}

class _CollectQuestionPageState extends State<CollectQuestionPage> {
  static const ShapeBorder _bottomBtnShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
  );

  CollectItem get collectItem => widget.collectItem;

  List<Question> questions = [];

  /// 移出收藏夹的题目id
  final List<int> removedQuestionIds = [];

  final PageController _pageController = PageController(initialPage: 0);

  int _curIndex = 0;

  int get _curPage => _curIndex + 1;
  int get _pageNum => collectItem.questionIds.length;
  bool get _isEndPage => _curPage == _pageNum;

  Future<void> initFuture;

  /// 首屏数据初始化，通过collectItem中的qids拉取收藏questions
  Future<void> initData() async {
    // 收藏夹跳转而来，拉取questions
    print('[COLLECT QUESTIONS FROM COLLECT<tid:${collectItem.tid}>]');
    var resp = await ApiService.getQuestionsByQids(collectItem.questionIds);
    List<Map<String, dynamic>> questionsJson = resp.data;
    List<Question> qs = questionsJson.map((e) => Question.fromJson(e)).toList();
    // 对问题排序，选择题优先
    qs.sort((a, b) => a.type.index.compareTo(b.type.index));
    setState(() {
      questions = qs;
    });
  }

  /// 收藏状态反转，发送请求
  void toggleCollect(Question curQuestion) {
    if (curQuestion.isCollected) {
      // 移除收藏
      ApiService.removeCollectedQuestion(
        curQuestion.qid,
      ).then((resp) {
        ToastUtil.showText(text: resp.msg);
        if (resp.isSucc) {
          setState(() {
            curQuestion.toggleCollect();
            removedQuestionIds.add(curQuestion.qid);
          });
        }
      });
    } else {
      // 添加收藏
      ApiService.addCollectedQuestion(
        tid: collectItem.tid,
        subjectId: collectItem.subjectId,
        qid: curQuestion.qid,
      ).then((resp) {
        ToastUtil.showText(text: resp.msg);
        if (resp.isSucc) {
          setState(() {
            curQuestion.toggleCollect();
            removedQuestionIds.remove(curQuestion.qid);
          });
        }
      });
    }
  }

  /// 下一题目
  void doNext() {
    if (!_isEndPage) {
      _pageController.animateToPage(
        _curIndex + 1,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  /// 渲染顶部标题
  Widget _getTitle() {
    return Container(
      height: 45,
      padding: EdgeInsets.symmetric(horizontal: 25),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
          )
        ],
      ),
      child: Text(
        '${collectItem.name}',
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyleM.G1,
      ),
    );
  }

  /// 渲染底部菜单
  Widget _getBottomBar() {
    Question curQuestion = questions[_curIndex];
    return Container(
      height: 40,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RaisedButton(
            color: Colors.white,
            elevation: 5,
            shape: _bottomBtnShape,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  curQuestion.isCollected
                      ? Icons.delete_outline_rounded
                      : Icons.redo_rounded,
                ),
                Text(
                  curQuestion.isCollected ? '取消收藏' : '恢复收藏',
                ),
              ],
            ),
            onPressed: () => toggleCollect(curQuestion),
          ),
          SizedBox(width: 15),
          Expanded(
            child: RaisedButton(
              color: Colors.white,
              disabledColor: ColorM.C2,
              elevation: 5,
              shape: _bottomBtnShape,
              child: Text('下一题'),
              onPressed: _isEndPage ? null : doNext,
            ),
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, removedQuestionIds.isNotEmpty);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('收藏夹'),
          centerTitle: true,
          actions: [
            Container(
              padding: EdgeInsets.only(right: 20),
              alignment: Alignment.center,
              child: Text('$_curPage/$_pageNum'),
            )
          ],
          elevation: 0,
        ),
        body: LoadingFirstScreen(
          future: initFuture,
          body: Container(
            height: double.maxFinite,
            width: double.maxFinite,
            child: Column(
              children: [
                _getTitle(),
                // 题目区域
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    children: questions
                        .map(
                          (q) => QuestionPageView(
                            pageType: QuestionPageViewTypes.collection,
                            question: q,
                          ),
                        )
                        .toList(),
                    onPageChanged: (index) {
                      setState(() {
                        _curIndex = index;
                      });
                    },
                  ),
                ),
                // 当还未初始化时，不渲染菜单
                if (questions.isNotEmpty) _getBottomBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
