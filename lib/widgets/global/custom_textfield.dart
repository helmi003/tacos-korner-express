import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:solar_icons/solar_icons.dart';

class CustomTextfield extends StatelessWidget {
  final String label;
  final String placeholder;
  final TextInputType type;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;
  final int maxLines;
  final bool? isRequired;
  final bool? widthBG;
  final IconData? labelIcon;
  final IconData? prefixIcon;
  final bool? obscure;
  final VoidCallback? setObscure;
  final TextAlign? textAlign;
  final int? maxLength;
  final TextStyle? textStyle;
  final bool isAutofilled;

  const CustomTextfield(
    this.label,
    this.placeholder,
    this.type,
    this.controller,
    this.validator,
    this.autovalidateMode, {
    this.maxLines = 1,
    this.isRequired,
    this.widthBG,
    this.labelIcon,
    this.prefixIcon,
    this.obscure,
    this.setObscure,
    this.textAlign,
    this.maxLength,
    this.textStyle,
    this.isAutofilled = false,
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
        TextFormField(
          autovalidateMode: autovalidateMode,
          keyboardType: type,
          controller: controller,
          validator: validator,
          obscureText: obscure ?? false,
          maxLines: maxLines,
          textAlign: textAlign ?? TextAlign.start,
          maxLength: maxLength,
          style: textStyle ?? TextStyle(fontSize: 14.sp),
          decoration: InputDecoration(
            counterText: maxLength != null ? '' : null,
            filled: true,
            fillColor: isAutofilled
                ? (Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF1565C0).withValues(alpha: 0.25)
                      : const Color(0xFF1E88E5).withValues(alpha: 0.10))
                : (widthBG == true
                      ? context.backgroundColor
                      : context.cardColor),
            border: InputBorder.none,
            errorStyle: TextStyle(fontSize: 10.sp),
            errorMaxLines: 2,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 10.h,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: context.borderColor, width: 0.5.w),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: context.borderColor, width: 0.5.w),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: danger),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: danger),
            ),
            hintText: placeholder,
            hintStyle: TextStyle(color: textMuted, fontSize: 12.sp),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 16.sp, color: textMuted)
                : null,
            suffixIcon: obscure != null && setObscure != null
                ? IconButton(
                    splashRadius: 18,
                    onPressed: setObscure,
                    icon: Icon(
                      obscure!
                          ? SolarIconsOutline.eyeClosed
                          : SolarIconsOutline.eye,
                      size: 18.sp,
                      color: textMuted,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
