import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:solar_icons/solar_icons.dart';

class NotificationBell extends StatelessWidget {
  final bool? isWhite;
  const NotificationBell({super.key, this.isWhite = false});

  @override
  Widget build(BuildContext context) {
    final unread = 0;
    return GestureDetector(
      onTap: () {},
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Icon(
              SolarIconsOutline.bell,
              size: 22.sp,
              color: isWhite! ? textLight : context.textColor,
            ),
          ),
          if (unread > 0)
            Positioned(
              top: 4.h,
              right: 4.w,
              child: Container(
                constraints: BoxConstraints(minWidth: 16.w, minHeight: 16.w),
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                decoration: BoxDecoration(
                  color: danger,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    unread > 9 ? '9+' : '$unread',
                    style: TextStyle(
                      fontSize: 8.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
