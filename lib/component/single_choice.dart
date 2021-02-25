import 'package:flutter/material.dart';

class SingleChoice extends StatefulWidget {
  SingleChoice({Key key}) : super(key: key);

  @override
  _SingleChoiceState createState() => _SingleChoiceState();
}

class _SingleChoiceState extends State<SingleChoice> {
  List<String> choices = ['2个', '3个', '4个', '5个'];

  List<int> userChoices = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(color: Color(0xff1c1c1c)),
      child: Container(
        height: double.maxFinite,
        color: Colors.black26,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(20),
              child: Text('  在维可的回忆中，伊尔缪伊一共使用了多少个“欲望的摇篮”？'),
            ),
            Expanded(
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(), //禁止滚动
                itemCount: this.choices.length,
                separatorBuilder: (BuildContext context, int index) => Divider(height: 1),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Text(
                      String.fromCharCodes([65 + index]),
                      style: TextStyle(fontSize: 18),
                    ),
                    title: Transform(
                      transform: Matrix4.translationValues(-20, 0, 0),
                      child: Text(
                        this.choices[index],
                        maxLines: 2,
                        style: TextStyle(height: 1),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    enabled: true,
                    selected: this.userChoices.contains(index),
                    selectedTileColor: Color(0x805abebc),
                    onTap: () => setState(() {
                      this.userChoices.contains(index) ? this.userChoices.remove(index) : this.userChoices.add(index);
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
