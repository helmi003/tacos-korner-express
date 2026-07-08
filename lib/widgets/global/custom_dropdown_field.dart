import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_corner_express/helpers/device_helper.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:solar_icons/solar_icons.dart';

const _kClearSentinel = '__clear__';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final List<Map<String, dynamic>> items;
  final ValueChanged<String?> onChanged;
  final bool? isRequired;
  final bool? withBG;
  final IconData? labelIcon;
  final bool? nullable;
  final String? errorText;

  const CustomDropdownField({
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.isRequired,
    this.withBG,
    this.labelIcon,
    this.nullable = false,
    this.errorText,
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
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: DeviceHelper.isTablet ? 6.h : 0,
          ),
          decoration: BoxDecoration(
            color: withBG == true ? context.cardColor : context.backgroundColor,
            borderRadius: BorderRadius.circular(12.r),
            border: context.border,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(
                hint,
                style: TextStyle(fontSize: 14.sp, color: textMuted),
              ),
              isExpanded: true,
              menuMaxHeight: 300.h,
              borderRadius: BorderRadius.circular(10.r),
              icon: Icon(Icons.keyboard_arrow_down, color: textMuted),
              selectedItemBuilder: (context) => [
                if (nullable == true)
                  Text(
                    hint,
                    style: TextStyle(fontSize: 14.sp, color: textMuted),
                  ),
                ...items.map((item) {
                  final icon = item['icon'] as IconData?;
                  return Row(
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 13.sp, color: context.primary),
                        SizedBox(width: 8.w),
                      ],
                      Expanded(
                        child: Text(
                          item['label'] as String,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: context.textColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                }),
              ],
              items: [
                if (nullable == true)
                  DropdownMenuItem<String>(
                    value: _kClearSentinel,
                    child: Text(
                      hint,
                      style: TextStyle(fontSize: 14.sp, color: textMuted),
                    ),
                  ),
                ...items.map((item) {
                  final isSelected = item['value'] == value;
                  final icon = item['icon'] as IconData?;
                  return DropdownMenuItem<String>(
                    value: item['value'] as String,
                    child: Row(
                      children: [
                        if (icon != null) ...[
                          Icon(
                            icon,
                            size: 13.sp,
                            color: isSelected ? context.primary : textMuted,
                          ),
                          SizedBox(width: 8.w),
                        ],
                        Expanded(
                          child: Text(
                            item['label'] as String,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: isSelected
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                              color: isSelected
                                  ? context.primary
                                  : context.textColor,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            SolarIconsBold.checkCircle,
                            size: 16.sp,
                            color: context.primary,
                          ),
                      ],
                    ),
                  );
                }),
              ],
              onChanged: (val) =>
                  onChanged(val == _kClearSentinel ? null : val),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 5.h, left: 2.w),
            child: Text(
              errorText!,
              style: TextStyle(color: danger, fontSize: 10.sp),
            ),
          ),
      ],
    );
  }
}
