import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_corner_express/helpers/password_helper.dart';
import 'package:takos_corner_express/services/language_provider.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:provider/provider.dart';

class PasswordStrengthBar extends StatelessWidget {
  final String password;
  final List<String> labels;
  final Color midColor;

  const PasswordStrengthBar({
    super.key,
    required this.password,
    this.labels = const ['Weak', 'Fair', 'Good', 'Strong'],
    this.midColor = accentOrange,
  });

  bool get _hasMin => hasMinLength(password);

  int get _score => [
    hasMinLength(password),
    hasLowercase(password),
    hasUppercase(password),
    hasDigitChar(password),
    hasSpecialChar(password),
  ].where((c) => c).length;

  int get _bars {
    if (!_hasMin || _score <= 2) return 1;
    if (_score == 3) return 2;
    if (_score == 4) return 3;
    return 4;
  }

  String get _label {
    if (!_hasMin || _score <= 2) return labels[0];
    if (_score == 3) return labels[1];
    if (_score == 4) return labels[2];
    return labels[3];
  }

  Color get _color {
    if (!_hasMin || _score <= 1) return danger;
    if (_score == 2) return midColor;
    return success;
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.read<LanguageProvider>().isArabic;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (i) {
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 4.h,
                margin: EdgeInsets.only(
                  right: isArabic
                      ? 0
                      : i < 3
                      ? 4.w
                      : 0,
                  left: isArabic
                      ? i < 3
                            ? 4.w
                            : 0
                      : 0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.r),
                  color: i < _bars ? _color : context.borderColor,
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 4.h),
        Text(
          _label,
          style: TextStyle(
            fontSize: 11.sp,
            color: _color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
