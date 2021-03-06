import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    Key key,
    @required this.width,
    this.height = 6,
    this.progress,
    this.backgroundColor,
    this.foregroundColor,
    this.gradient,
  }) : super(key: key);

  final double height;
  final double width;
  final double progress;
  final Color backgroundColor;
  final Color foregroundColor;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(width)),
      ),
      child: Stack(
        children: [
          Container(
            height: height,
            width: progress * width,
            decoration: BoxDecoration(
              color: foregroundColor,
              borderRadius: BorderRadius.all(Radius.circular(width)),
              gradient: gradient,
            ),
          )
        ],
      ),
    );
  }
}
