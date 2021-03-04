import 'package:flutter/material.dart';

class IconLabelButton extends StatelessWidget {
  final IconData icon;
  final bool isHorizontal;
  final double iconSize;
  final String label;
  final double labelSize;
  final double lineHeight;
  final Color color;
  final Function onTap;

  const IconLabelButton(
    this.icon,
    this.label, {
    Key key,
    this.isHorizontal,
    this.iconSize,
    this.labelSize,
    this.lineHeight,
    this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);

    Color _color = color ?? iconTheme.color;
    double _iconSize = iconSize ?? iconTheme.size;
    TextStyle _style = defaultTextStyle.style.merge(TextStyle(
      fontSize: labelSize,
      color: _color,
      height: lineHeight ?? 1,
    ));
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: _iconSize,
            color: _color,
          ),
          Text(
            label,
            style: _style,
          ),
        ],
      ),
    );
  }
}
