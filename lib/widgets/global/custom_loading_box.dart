import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_corner_express/utils/colors.dart';

class CustomLoadingBox extends StatelessWidget {
  final double w;
  final double h;
  final double borderRadius;
  const CustomLoadingBox(this.w, this.h, {super.key, this.borderRadius = 6});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: context.textColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(borderRadius.r),
      ),
    );
  }
}
