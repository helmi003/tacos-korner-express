import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/data/home_data.dart';
import 'package:takos_corner_express/utils/colors.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantModel restaurant;
  const RestaurantCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.borderColor, width: 0.5),
        boxShadow: context.shadows,
      ),
      child: Row(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: restaurant.accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Center(
              child: Text(restaurant.emoji, style: TextStyle(fontSize: 28.sp)),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  restaurant.cuisine,
                  style: TextStyle(fontSize: 11.sp, color: textMuted),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(SolarIconsBold.star, size: 12.sp, color: accentAmber),
                    SizedBox(width: 3.w),
                    Text(
                      restaurant.rating.toString(),
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Icon(
                      SolarIconsOutline.clockCircle,
                      size: 11.sp,
                      color: textMuted,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      restaurant.deliveryTime,
                      style: TextStyle(fontSize: 11.sp, color: textMuted),
                    ),
                    SizedBox(width: 10.w),
                    Icon(
                      SolarIconsOutline.delivery,
                      size: 11.sp,
                      color: textMuted,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      '\$${restaurant.deliveryFee.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 11.sp, color: textMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(SolarIconsOutline.altArrowRight, size: 16.sp, color: textMuted),
        ],
      ),
    );
  }
}