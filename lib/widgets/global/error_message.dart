import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/l10n/app_localizations.dart';
import 'package:takos_corner_express/utils/colors.dart';

class ErrorMessage extends StatelessWidget {
  final String errorMsg;
  final VoidCallback? onPressed;
  const ErrorMessage(this.errorMsg, {super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DottedBorder(
            options: RoundedRectDottedBorderOptions(
              borderPadding: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              strokeWidth: 2.w,
              color: danger.withValues(alpha: 0.7),
              radius: Radius.circular(20.r),
              dashPattern: [6, 6],
            ),
            child: Container(
              height: 80.w,
              width: 80.w,
              decoration: BoxDecoration(
                color: danger.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Icon(
                SolarIconsBold.closeCircle,
                color: danger,
                size: 50.w,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            AppLocalizations.of(context)!.unknown_error,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
            child: Text(
              errorMsg,
              style: TextStyle(fontSize: 14.sp, color: danger),
              textAlign: TextAlign.center,
            ),
          ),
          if (onPressed != null)
            Container(
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(999),
                boxShadow: context.shadows,
                border: context.border,
              ),
              child: TextButton(
                onPressed: onPressed,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    Colors.transparent,
                  ),
                  padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(horizontal: 14.w),
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: WidgetStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      SolarIconsOutline.restart,
                      color: context.textColor,
                      size: 12.sp,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      "Retry",
                      style: TextStyle(
                        color: context.textColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
