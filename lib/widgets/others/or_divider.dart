import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_corner_express/utils/colors.dart';

class OrDivider extends StatelessWidget {
  final String text;
  final Widget? child;
  final VoidCallback? onTap;

  const OrDivider({
    super.key,
    this.text = 'OU CONTINUER AVEC',
    this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final row = Row(
      children: [
        Expanded(child: Divider(color: context.borderColor, thickness: 0.8)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child:
              child ??
              Text(
                text,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: textMuted,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
        ),
        Expanded(child: Divider(color: context.borderColor, thickness: 0.8)),
      ],
    );
    return onTap != null ? GestureDetector(onTap: onTap, child: row) : row;
  }
}
