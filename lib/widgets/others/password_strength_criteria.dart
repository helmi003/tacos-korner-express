import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_corner_express/helpers/password_helper.dart';
import 'package:takos_corner_express/utils/colors.dart';

class StrengthCriteria extends StatelessWidget {
  final String password;

  const StrengthCriteria({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    final checks = [
      hasMinLength(password),
      hasUppercase(password),
      hasLowercase(password),
      hasDigitChar(password),
      hasSpecialChar(password),
    ];
    const items = [
      'Au moins 8 caractères',
      'Une lettre majuscule',
      'Une lettre minuscule',
      'Un chiffre',
      'Un caractère spécial',
    ];
    return Wrap(
      spacing: 12.w,
      runSpacing: 6.h,
      children: List.generate(items.length, (i) {
        final met = checks[i];
        return SizedBox(
          width: (MediaQuery.of(context).size.width - 52.w) / 2,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                met
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                size: 14.sp,
                color: met ? success : textMuted,
              ),
              SizedBox(width: 5.w),
              Flexible(
                child: Text(
                  items[i],
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: met ? success : textMuted,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
