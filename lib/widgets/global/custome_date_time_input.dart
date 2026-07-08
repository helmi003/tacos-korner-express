import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:solar_icons/solar_icons.dart';

class CustomeDateTimeInput extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final String hint;
  final String time;
  final IconData? icon;
  final bool? isRequired;
  final bool? widthBG;
  final IconData? labelIcon;
  final VoidCallback? onClear;

  const CustomeDateTimeInput(
    this.label,
    this.onTap,
    this.hint,
    this.time, {
    this.icon,
    this.isRequired,
    this.widthBG,
    this.labelIcon,
    this.onClear,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Row(
            children: [
              if (labelIcon != null) ...[
                Icon(labelIcon, size: 12.sp),
                SizedBox(width: 4.w),
              ],
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: context.textColor,
                  ),
                  children: [
                    TextSpan(text: label.toUpperCase()),
                    if (isRequired == true)
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: danger),
                      )
                    else if (isRequired == false)
                      TextSpan(
                        text: ' Optional',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: textMuted,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
        ],
        InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: widthBG == true
                  ? context.cardColor
                  : context.backgroundColor,
              borderRadius: BorderRadius.circular(8.r),
              border: context.border,
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20.sp),
                  SizedBox(width: 8.w),
                ],
                Text(
                  time.isNotEmpty ? time : hint,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: time.isNotEmpty ? context.textColor : textMuted,
                  ),
                ),
                Spacer(),
                if (time.isNotEmpty) ...[
                  GestureDetector(
                    onTap: onClear,
                    child: Padding(
                      padding: EdgeInsets.all(2.w),
                      child: Icon(SolarIconsOutline.closeCircle, size: 16.sp),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
