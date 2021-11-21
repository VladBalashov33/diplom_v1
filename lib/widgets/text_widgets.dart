import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  const CustomTitle(
    this.title, {
    Key? key,
  }) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.bodyText1!.copyWith(height: 1.8),
    );
  }
}

class CustomText extends StatelessWidget {
  const CustomText(
    this.text, {
    Key? key,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.right,
      style: Theme.of(context).textTheme.bodyText2!.copyWith(height: 1.8),
    );
  }
}
