import 'package:diplom/utils/utils.dart';
import 'package:flutter/material.dart';

class CustomTable extends StatelessWidget {
  const CustomTable({
    required this.children,
    this.flexFirst = 8,
    Key? key,
  }) : super(key: key);

  final List<TableRow> children;
  final double flexFirst;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: 370,
        child: Table(
          border: TableBorder(
            horizontalInside: BorderSide(
              color: AppColors.primary.withOpacity(0.8),
              width: 0.8,
              style: BorderStyle.solid,
            ),
            bottom: BorderSide(
              color: AppColors.primary.withOpacity(0.8),
              width: 0.8,
              style: BorderStyle.solid,
            ),
          ),
          columnWidths: {
            0: FlexColumnWidth(flexFirst),
            1: const FlexColumnWidth(2),
          },
          children: children,
        ),
      ),
    );
  }
}
