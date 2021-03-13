import 'package:flutter/material.dart';
import 'package:flutter_demo/utils/style_util.dart';

mixin SearchBoxMixin {
  TextEditingController searchController = TextEditingController();

  /// 当前搜索关键字
  String curSearch = '';

  /// 取消搜索，恢复数据
  void onCancelSearch();

  /// 触发搜索，拉取数据
  void onSearch(String search);

  /// 渲染搜索框
  Widget getSearchBox() {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(vertical: 9),
      child: TextField(
        controller: searchController,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: '搜索试题',
          hintStyle: TextStyleM.D4,
          fillColor: ColorM.C2,
          filled: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide.none,
          ),
        ),
        onSubmitted: (content) => onSearch(content),
      ),
    );
  }

  /// 渲染搜索说明
  List<Widget> getSearchTitle() {
    return curSearch.isNotEmpty
        ? [
            Container(
              height: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '当前搜索：$curSearch',
                    style: TextStyleM.D4,
                  ),
                  SizedBox(
                    width: 50,
                    child: FlatButton(
                      padding: EdgeInsets.zero,
                      textColor: ColorM.G2,
                      onPressed: onCancelSearch,
                      child: Text('撤销'),
                    ),
                  ),
                ],
              ),
            )
          ]
        : [];
  }
}
