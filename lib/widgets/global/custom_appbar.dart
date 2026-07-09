import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/others/notification_bell.dart';

PreferredSizeWidget customAppBar(BuildContext context) {
  return AppBar(
    leadingWidth: 0,
    titleSpacing: 0,
    toolbarHeight: 60.h,
    automaticallyImplyLeading: false,
    backgroundColor: context.cardColor,
    title: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "assets/images/logo/logo_foreground.png",
            height: 40.h,
            width: 40.w,
          ),
          SizedBox(width: 8.w),
          Text(
            "Takos Korner",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: context.textColor,
            ),
          ),
          Spacer(),
          Row(children: [const NotificationBell()]),
        ],
      ),
    ),
    elevation: 0,
  );
}
