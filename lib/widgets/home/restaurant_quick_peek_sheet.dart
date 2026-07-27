import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/data/home_data.dart';
import 'package:takos_corner_express/helpers/link_helper.dart';
import 'package:takos_corner_express/screens/restaurants/restaurant_details_screen.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/button_widget.dart';
import 'package:takos_corner_express/widgets/global/custom_cashed_image.dart';
import 'package:takos_corner_express/widgets/global/restaurant_action_button.dart';

Future<void> showRestaurantQuickPeekSheet(
  BuildContext context,
  RestaurantModel restaurant,
) {
  return showModalBottomSheet(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => RestaurantQuickPeekSheet(restaurant: restaurant),
  );
}

class RestaurantQuickPeekSheet extends StatelessWidget {
  final RestaurantModel restaurant;
  const RestaurantQuickPeekSheet({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20.w,
        20.h,
        20.w,
        20.h + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        boxShadow: context.shadows,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              height: 4.h,
              width: 40.w,
              decoration: BoxDecoration(
                color: context.borderColor,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: CustomCashedImage(
                  restaurant.image,
                  height: 50.h,
                  width: 50.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            restaurant.name,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                              color: context.textColor,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: restaurant.isOpen
                                ? context.accentGreen
                                : textMain.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            restaurant.isOpen ? 'Open' : 'Closed',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Icon(
                          SolarIconsBold.mapPoint,
                          size: 13.sp,
                          color: textMuted,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            restaurant.address,
                            style: TextStyle(fontSize: 12.sp, color: textMuted),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              Icon(SolarIconsBold.start1, size: 13.sp, color: context.accentAmber),
              SizedBox(width: 4.w),
              Text(
                '${restaurant.rating} (${restaurant.reviews})',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: context.textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: RestaurantActionButton(
                  label: 'Directions',
                  image: "assets/images/google-maps.png",
                  onTap: () =>
                      openMaps(context, restaurant.lat, restaurant.lng),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: RestaurantActionButton(
                  label: 'Call',
                  icon: SolarIconsOutline.phoneCalling,
                  onTap: () => openPhone(context, restaurant.phone),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: RestaurantActionButton(
                  label: 'Share',
                  icon: SolarIconsOutline.share,
                  onTap: () => shareURL(context, restaurant),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ButtonWidget('View more', () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RestaurantDetailsScreen(restaurant: restaurant),
              ),
            );
          }),
        ],
      ),
    );
  }
}
