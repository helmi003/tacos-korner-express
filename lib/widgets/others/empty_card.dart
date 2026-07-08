import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_corner_express/utils/colors.dart';

class EmptyCard extends StatelessWidget {
  final IconData? icon;
  final String? message;
  final String? caption;
  final VoidCallback? onPressed;
  final String? buttonText;
  final bool? withBG;
  const EmptyCard({
    super.key,
    this.icon,
    this.message,
    this.caption,
    this.onPressed,
    this.buttonText,
    this.withBG = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: withBG! ? context.cardColor : Colors.transparent,
        borderRadius: withBG! ? BorderRadius.circular(16.r) : null,
        border: withBG! ? context.border : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 36.sp, color: textMuted.withValues(alpha: 0.35)),
            SizedBox(height: 10.h),
          ],
          if (message != null) ...[
            Text(
              message!,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10.h),
          ],
          if (caption != null) ...[
            Text(
              caption!,
              style: TextStyle(
                fontSize: 12.sp,
                color: textMuted.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
          ],
          if (onPressed != null && buttonText != null) ...[
            TextButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 16.sp, color: primaryColor),
              label: Text(
                buttonText!,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
