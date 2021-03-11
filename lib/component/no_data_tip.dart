import 'package:flutter/material.dart';
import 'package:flutter_demo/component/image_set.dart';

class NoDataTip extends StatelessWidget {
  const NoDataTip({
    Key key,
    this.imgHeight,
    this.imgWidth,
    this.imgFit = BoxFit.contain,
    this.gap = 5,
    @required this.text,
    this.textStyle,
  }) : super(key: key);

  final double imgHeight;
  final double imgWidth;
  final BoxFit imgFit;
  final double gap;
  final String text;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: Column(
        children: [
          ImageSet(
            ImageSets.no_data,
            height: imgHeight,
            width: imgWidth,
            fit: imgFit,
          ),
          SizedBox(height: gap),
          Text('$text', style: textStyle),
        ],
      ),
    );
  }
}
