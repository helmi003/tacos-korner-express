import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:takos_corner_express/services/language_provider.dart';

PreferredSizeWidget customBackAppBar(
  BuildContext context,
  String title,
  String description, {
  VoidCallback? onBack,
  List<Widget>? actions,
}) {
  final isArabic = context.read<LanguageProvider>().isArabic;

  return AppBar(
    leadingWidth: 55.w,
    titleSpacing: 0,
    toolbarHeight: 60.h,
    backgroundColor: context.backgroundColor,
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
        description.isNotEmpty
            ? Text(description, style: TextStyle(fontSize: 12.sp))
            : SizedBox.shrink(),
      ],
    ),
    leading: Padding(
      padding: EdgeInsets.only(left: 10.w),
      child: IconButton(
        icon: Icon(
          isArabic
              ? SolarIconsOutline.altArrowRight
              : SolarIconsOutline.altArrowLeft,
          size: 24.sp,
        ),
        onPressed: () {
          if (onBack != null) {
            onBack();
          } else {
            Navigator.of(context).pop();
          }
        },
      ),
    ),
    actions: actions,
    elevation: 0,
  );
}
