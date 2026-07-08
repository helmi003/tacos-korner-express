import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_corner_express/data/language_data.dart';
import 'package:takos_corner_express/services/language_provider.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:provider/provider.dart';

class LanguageSelector extends StatelessWidget {
  final bool isDark;
  const LanguageSelector({super.key, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LanguageProvider>();
    final current = provider.selectedLanguage.languageCode;

    return PopupMenuButton<String>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      color: isDark ? uiCardDark : context.cardColor,
      offset: const Offset(0, 40),
      onSelected: (code) {
        provider.setLanguage(Locale(code));
      },
      itemBuilder: (_) => languages.map((lang) {
        final langCode = lang.code.languageCode;
        return PopupMenuItem<String>(
          value: langCode,
          child: Row(
            children: [
              Image.asset(
                "assets/images/flags/${langCode.toLowerCase()}.png",
                width: 20.w,
                height: 14.h,
              ),
              SizedBox(width: 8.w),
              Text(
                lang.title,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: isDark ? textLight : context.textColor,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isDark ? uiCardDark : context.cardColor,
          borderRadius: BorderRadius.circular(20.r),
          border: isDark ? borderDark : context.border,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/flags/${current.toLowerCase()}.png",
              width: 20.w,
              height: 14.h,
            ),
            SizedBox(width: 4.w),
            Text(
              provider.getCurrentLanguageTitle(),
              style: TextStyle(
                fontSize: 13.sp,
                color: isDark ? textLight : context.textColor,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16.sp,
              color: isDark ? textLight : textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
