import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../perlengkapan/colors.dart';

class AnimatedBar extends StatelessWidget {
  const AnimatedBar({
    Key? key,
    required this.isActive,
  }) : super(key: key);

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: const EdgeInsets.only(bottom: 2),
      duration: const Duration(milliseconds: 200),
      height: 4.h,
      width: isActive ? 20 : 0,
      decoration: BoxDecoration(
          color: AppColors.primaryElement.withOpacity(0.5),
          borderRadius: BorderRadius.all(
            Radius.circular(12.r),
          )),
    );
  }
}
