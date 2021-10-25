import 'package:flutter/material.dart';

class TextPrice extends StatelessWidget {
  const TextPrice(
    this.value, {
    this.style = const TextStyle(),
  }) : super();

  final num value;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: 1,
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: value.toString(),
            style: style,
          ),
          TextSpan(
            text: ' ₽',
            style: TextStyle(
              fontFamily: DefaultTextStyle.of(context).style.fontFamily,
              fontSize: style.fontSize,
              fontWeight: style.fontWeight,
              color: style.color,
            ),
          ),
        ],
      ),
    );
  }
}
