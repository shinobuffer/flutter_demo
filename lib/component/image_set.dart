import 'package:flutter/material.dart';

class ImageSets {
  ImageSets._();
  static const String bcoin = 'assets/images/bcoin.png';
  static const String gold_seed = 'assets/images/gseed.png';
  static const String no_data = 'assets/images/nodata.png';
}

class ImageSet extends StatelessWidget {
  /// 本地图片复用
  const ImageSet(
    this.name, {
    Key key,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
  }) : super(key: key);

  final String name;
  final double height;
  final double width;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      name,
      height: height,
      width: width,
      fit: fit,
    );
  }
}
