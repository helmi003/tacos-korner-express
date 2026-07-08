import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/others/notification_bell.dart';
import 'package:solar_icons/solar_icons.dart';

PreferredSizeWidget customAppBar(BuildContext context) {
  return AppBar(
    leadingWidth: 0,
    titleSpacing: 0,
    toolbarHeight: 60.h,
    automaticallyImplyLeading: false,
    backgroundColor: context.backgroundColor,
    title: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset("assets/images/logo/logo.png", height: 40.h, width: 40.w),
          Row(
            children: [
              const NotificationBell(),
              Builder(
                builder: (context) => IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: Icon(SolarIconsOutline.hamburgerMenu, size: 20.sp),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    elevation: 0,
  );
}
