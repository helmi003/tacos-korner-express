import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_corner_express/utils/colors.dart';

class SocialButton extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback onTap;

  const SocialButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: context.backgroundColor,
          borderRadius: BorderRadius.circular(10.r),
          border: context.border,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, width: 20.w, height: 20.w),
            SizedBox(width: 10.w),
            Text(
              title,
              style: TextStyle(fontSize: 14.sp, color: context.textColor),
            ),
          ],
        ),
      ),
    );
  }
}
