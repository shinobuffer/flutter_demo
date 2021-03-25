import 'package:flutter/material.dart';

class TextStyleM {
  static const TextStyle D0 = TextStyle(color: Colors.white);
  static const TextStyle D0_12 = TextStyle(color: Colors.white, fontSize: 12);
  static const TextStyle D0_16 = TextStyle(color: Colors.white, fontSize: 16);
  static const TextStyle D0_16_B =
      TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);
  static const TextStyle D0_28_B =
      TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold);
  static const TextStyle D0_32_B =
      TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold);

  static const TextStyle D1_12 =
      TextStyle(color: Color(0xFFCECECE), fontSize: 12);
  static const TextStyle D1_14 =
      TextStyle(color: Color(0xFFCECECE), fontSize: 14);

  static const TextStyle D4 = TextStyle(color: Color(0xFFAAAAAA));
  static const TextStyle D4_12 =
      TextStyle(color: Color(0xFFAAAAAA), fontSize: 12);
  static const TextStyle D4_16 =
      TextStyle(color: Color(0xFFAAAAAA), fontSize: 16);

  static const TextStyle D5 = TextStyle(color: Color(0xFF7F7F7F));
  static const TextStyle D5_10 =
      TextStyle(color: Color(0xFF7F7F7F), fontSize: 10);
  static const TextStyle D5_12 =
      TextStyle(color: Color(0xFF7F7F7F), fontSize: 12);
  static const TextStyle D5_24 =
      TextStyle(color: Color(0xFF7F7F7F), fontSize: 24);

  static const TextStyle D7_B =
      TextStyle(color: Color(0xFF333333), fontWeight: FontWeight.bold);
  static const TextStyle D7_13 =
      TextStyle(color: Color(0xFF333333), fontSize: 13);
  static const TextStyle D7_14 =
      TextStyle(color: Color(0xFF333333), fontSize: 14);
  static const TextStyle D7_18_B = TextStyle(
      color: Color(0xFF333333), fontSize: 18, fontWeight: FontWeight.bold);
  static const TextStyle D7_24_B = TextStyle(
      color: Color(0xFF333333), fontSize: 24, fontWeight: FontWeight.bold);

  static const TextStyle G1 = TextStyle(color: Color(0xFF55B9B0));
  static const TextStyle G1_24 =
      TextStyle(color: Color(0xFF55B9B0), fontSize: 24);
  static const TextStyle G1_32 =
      TextStyle(color: Color(0xFF55B9B0), fontSize: 32);

  static const TextStyle G0 = TextStyle(color: Colors.teal);
  static const TextStyle G0_24 = TextStyle(color: Colors.teal, fontSize: 24);

  static const TextStyle G2 = TextStyle(color: Color(0xFF70B603));
  static const TextStyle G2_24 =
      TextStyle(color: Color(0xFF70B603), fontSize: 24);

  static const TextStyle G3 = TextStyle(color: Color(0xFF00796B));

  static const TextStyle R1_B =
      TextStyle(color: Color(0xFFED462F), fontWeight: FontWeight.bold);

  static const TextStyle O1 = TextStyle(color: Color(0xFFF1A716));
  static const TextStyle O1_B =
      TextStyle(color: Color(0xFFF1A716), fontWeight: FontWeight.bold);
  static const TextStyle O1_16 =
      TextStyle(color: Color(0xFFF1A716), fontSize: 15);
  static const TextStyle O1_18_B = TextStyle(
      color: Color(0xFFF1A716), fontSize: 18, fontWeight: FontWeight.bold);
  static const TextStyle O1_24 =
      TextStyle(color: Color(0xFFF1A716), fontSize: 24);
  static const TextStyle O1_32_B = TextStyle(
      color: Color(0xFFF1A716), fontSize: 32, fontWeight: FontWeight.bold);
}

class ColorM {
  //白->黑
  static const C0 = Color(0xFFF9F9F9);
  static const C1 = Color(0xFFF3F3F3);
  static const C2 = Color(0xFFE9E9E9);
  static const C3 = Color(0xFFD7D7D7);
  static const C4 = Color(0xFFAAAAAA);
  static const C5 = Color(0xFF7F7F7F);
  static const C7 = Color(0xFF333333);
  //绿
  static const G1 = Color(0xFF70B603);
  static const G2 = Color(0xFF55B9B0); // 52B6AD
  static const G3 = Color(0xFF7DCAC2);
  //红
  static const R1 = Color(0xFFEC808D);
  static const R2 = Color(0xFFFF7D7D);

  // 其他颜色
  static const O1 = Color(0xFFFACD91);
  static const O2 = Color(0xFFF1A716);
}

class NoSplashFactory extends InteractiveInkFeatureFactory {
  const NoSplashFactory();

  InteractiveInkFeature create({
    @required MaterialInkController controller,
    @required RenderBox referenceBox,
    @required Offset position,
    @required Color color,
    TextDirection textDirection,
    bool containedInkWell: false,
    RectCallback rectCallback,
    BorderRadius borderRadius,
    ShapeBorder customBorder,
    double radius,
    VoidCallback onRemoved,
  }) {
    return new NoSplash(
      controller: controller,
      referenceBox: referenceBox,
      color: color,
      onRemoved: onRemoved,
    );
  }
}

class NoSplash extends InteractiveInkFeature {
  NoSplash({
    @required MaterialInkController controller,
    @required RenderBox referenceBox,
    Color color,
    VoidCallback onRemoved,
  })  : assert(controller != null),
        assert(referenceBox != null),
        super(
            controller: controller,
            referenceBox: referenceBox,
            onRemoved: onRemoved) {
    controller.addInkFeature(this);
  }
  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {}
}

class NoSplashScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    if (getPlatform(context) == TargetPlatform.android ||
        getPlatform(context) == TargetPlatform.fuchsia) {
      return GlowingOverscrollIndicator(
        child: child,
        showLeading: false,
        showTrailing: false,
        axisDirection: axisDirection,
        color: Theme.of(context).accentColor,
      );
    } else {
      return child;
    }
  }
}
