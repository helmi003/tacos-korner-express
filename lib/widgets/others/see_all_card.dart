import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_corner_express/utils/colors.dart';

class SeeAllCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onSeeAll;
  final Widget? widget;
  const SeeAllCard({
    super.key,
    required this.title,
    this.icon,
    this.iconColor,
    this.onSeeAll,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16.sp, color: iconColor ?? context.textColor),
              SizedBox(width: 6.w),
            ],
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: context.textColor,
              ),
            ),
          ],
        ),
        Spacer(),
        if (widget != null) ...[
          widget!,
        ] else ...[
          onSeeAll != null
              ? GestureDetector(
                  onTap: onSeeAll,
                  child: Text(
                    'See all',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ],
    );
  }
}
