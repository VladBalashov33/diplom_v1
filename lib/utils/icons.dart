import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// class AppImages {
//   const AppImages._();
// }

class AppIcons {
  const AppIcons._();

  static Widget facebook() {
    return SvgPicture.asset(
      'assets/icons/facebook.png',
      fit: BoxFit.contain,
    );
  }
}
