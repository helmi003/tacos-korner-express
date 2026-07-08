import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SecondaryButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  const SecondaryButton(
    this.title,
    this.icon,
    this.color,
    this.onPressed, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color, width: 2),
      ),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: color, size: 14.sp),
        label: Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            color: color,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
