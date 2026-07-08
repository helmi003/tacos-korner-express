import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:takos_corner_express/utils/colors.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isTransparent;
  final bool isDisabled;
  final Color? bgColor;
  final Color? color;
  final IconData? icon;
  final bool iconRight;
  final double? fontSize;
  final FontWeight? fontWeight;

  const ButtonWidget(
    this.title,
    this.onPressed, {
    super.key,
    this.isLoading = false,
    this.isTransparent = false,
    this.isDisabled = false,
    this.bgColor,
    this.color,
    this.icon,
    this.iconRight = false,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(12.r);
    final resolvedColor =
        color ?? (isTransparent ? context.primary : textLight);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDisabled
            ? context.primary.withValues(alpha: 0.5)
            : isLoading
            ? textMuted.withValues(alpha: 0.5)
            : isTransparent
            ? null
            : bgColor,
        gradient: isTransparent || isDisabled || isLoading || bgColor != null
            ? null
            : primaryGradient,
        borderRadius: borderRadius,
        border: isTransparent
            ? isLoading
                  ? null
                  : Border.all(color: color ?? context.primary, width: 1.5)
            : null,
        boxShadow: isTransparent ? [] : context.shadows,
      ),
      child: TextButton(
        onPressed: isLoading || isDisabled ? null : onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          ),
          minimumSize: WidgetStateProperty.all(Size.zero),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: WidgetStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: borderRadius),
          ),
        ),
        child: isLoading
            ? LoadingAnimationWidget.staggeredDotsWave(
                color: textLight,
                size: 20.h,
              )
            : icon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!iconRight) ...[
                    Icon(icon, size: 18.sp, color: resolvedColor),
                    SizedBox(width: 8.w),
                  ],
                  Flexible(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: resolvedColor,
                        fontSize: fontSize ?? 14.sp,
                        fontWeight: fontWeight ?? FontWeight.w700,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (iconRight) ...[
                    SizedBox(width: 8.w),
                    Icon(icon, size: 18.sp, color: resolvedColor),
                  ],
                ],
              )
            : Text(
                title,
                style: TextStyle(
                  color: resolvedColor,
                  fontSize: fontSize ?? 14.sp,
                  fontWeight: fontWeight ?? FontWeight.w700,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}
