import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/utils/colors.dart';

class SelectableChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  final Color? activeColor;
  final IconData? leadingIcon;
  final bool loading;

  const SelectableChip({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
    this.activeColor,
    this.leadingIcon,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = activeColor ?? primaryColor;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: active ? color.withValues(alpha: 0.12) : context.cardColor,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: active ? color : context.borderColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (loading) ...[
              SizedBox(
                width: 13.sp,
                height: 13.sp,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: active ? color : context.textMutedColor,
                ),
              ),
              SizedBox(width: 5.w),
            ] else if (leadingIcon != null) ...[
              Icon(
                leadingIcon,
                size: 13.sp,
                color: active ? color : context.textMutedColor,
              ),
              SizedBox(width: 5.w),
            ] else if (active) ...[
              Icon(SolarIconsBold.checkCircle, size: 13.sp, color: color),
              SizedBox(width: 5.w),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: active ? color : context.textBodyColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
