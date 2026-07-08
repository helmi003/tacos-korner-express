import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:takos_corner_express/utils/colors.dart';

class ConfirmationDialog extends StatelessWidget {
  final String contentText;
  final String cancelText;
  final String confirmText;
  final Color color;
  final VoidCallback onPressed;
  final bool isLoading;

  const ConfirmationDialog(
    this.contentText,
    this.cancelText,
    this.confirmText,
    this.color,
    this.onPressed, {
    super.key,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.r)),
      ),
      content: Text(
        contentText,
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                side: BorderSide(color: context.textColor, width: 1.2.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              ),
              child: Text(
                cancelText,
                style: TextStyle(fontSize: 14.sp, color: context.textColor),
              ),
            ),
            SizedBox(width: 10.w),
            TextButton(
              onPressed: isLoading ? null : onPressed,
              style: TextButton.styleFrom(
                backgroundColor: isLoading
                    ? textMuted.withValues(alpha: 0.5)
                    : color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              ),
              child: isLoading
                  ? LoadingAnimationWidget.staggeredDotsWave(
                      color: textLight,
                      size: 20.sp,
                    )
                  : Text(
                      confirmText,
                      style: TextStyle(fontSize: 14.sp, color: textLight),
                    ),
            ),
          ],
        ),
      ],
    );
  }

  void displayDialog(BuildContext context) {
    showDialog(context: context, builder: (BuildContext context) => this);
  }
}
