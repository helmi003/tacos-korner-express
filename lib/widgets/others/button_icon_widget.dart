import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_corner_express/utils/colors.dart';

class ButtonIconWidget extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final double? size;
  final VoidCallback onTap;

  const ButtonIconWidget({
    super.key,
    required this.icon,
    this.color = textLight,
    this.size = 13,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = size ?? 13;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all((iconSize * 0.6).w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: context.isDark
              ? textLight.withValues(alpha: 0.2)
              : textMain.withValues(alpha: 0.35),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: iconSize.sp, color: color),
      ),
    );
  }
}
