import 'package:flutter/material.dart';
import 'package:flutter_demo/component/base/progress_bar.dart';
import 'package:flutter_demo/component/image_set.dart';
import 'package:flutter_demo/utils/style_util.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({Key key}) : super(key: key);
  // todo: 待完善
  // final String title;
  // final String description;
  // final int gseed;

  // final double progress;
  // final String progressText;
  // final VoidCallback onCompleted;
  // final VoidCallback onGoComplete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('每日做题'),
          Text(
            '完成十道考研题目（科目不限）',
            style: TextStyleM.D1_12,
          ),
          Row(
            children: [
              ProgressBar(
                width: 200,
                margin: EdgeInsets.fromLTRB(0, 8, 15, 8),
                progress: .5,
                backgroundColor: ColorM.C2,
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [ColorM.O1, ColorM.O2],
                ),
              ),
              Text(
                '进度 5/10',
                style: TextStyleM.D5_12,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ImageSet(ImageSets.gold_seed, height: 20, width: 20),
                  Text(
                    '×5',
                    style: TextStyleM.O1_B,
                  ),
                ],
              ),
              SizedBox(
                height: 28,
                width: 70,
                child: FlatButton(
                  padding: EdgeInsets.zero,
                  textColor: Colors.white,
                  color: ColorM.G3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    // todo: 领取奖励
                  },
                  child: Text('领奖励'),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
