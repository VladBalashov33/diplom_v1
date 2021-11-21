import 'package:flutter/material.dart';

class CustomExpansionTile extends StatelessWidget {
  const CustomExpansionTile({
    required this.text,
    required this.children,
    this.isExpand = false,
    Key? key,
  }) : super(key: key);

  final String text;
  final List<Widget> children;
  final bool isExpand;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(text),
      tilePadding: EdgeInsets.zero,
      initiallyExpanded: isExpand,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
