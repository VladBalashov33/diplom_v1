import 'package:diplom/utils/utils.dart';
import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final Function()? onTap;
  final Color? color;
  final String text;
  final double? width;
  final double? height;
  final TextStyle? style;
  final bool isActive;
  final bool allowTapIfUnActive;

  const DefaultButton({
    required this.text,
    this.onTap,
    this.color,
    this.width,
    this.height,
    this.style,
    this.isActive = true,
    this.allowTapIfUnActive = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isActive || allowTapIfUnActive ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: height ?? 46,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: color ??
              (isActive
                  ? const Color(0xff607d8b)
                  : Colors.white.withOpacity(0.2)),
        ),
        child: Text(
          text,
          style: (style ?? AppTypography.font18).copyWith(
            color:
                isActive ? Colors.white : AppColors.redC61E15.withOpacity(0.6),
          ),
        ),
      ),
    );
  }
}
