import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_corner_express/utils/colors.dart';

class SettingsTile extends StatelessWidget {
  final IconData? icon;
  final Color? iconBg;
  final String? leadingText;
  final String label;
  final String? sub;
  final Color? labelColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    this.icon,
    this.iconBg,
    this.leadingText,
    required this.label,
    this.sub,
    this.labelColor,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      onTap: onTap,
      leading: leadingText != null
          ? Text(leadingText!, style: TextStyle(fontSize: 18.sp))
          : Container(
              width: 34.w,
              height: 34.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: (iconBg ?? primaryColor).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: icon != null
                  ? Icon(icon, color: iconBg ?? primaryColor, size: 17.sp)
                  : null,
            ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: labelColor ?? context.textColor,
        ),
      ),
      subtitle: sub != null
          ? Text(
              sub!,
              style: TextStyle(fontSize: 11.sp, color: textMuted),
            )
          : null,
      trailing: trailing,
    );
  }
}
