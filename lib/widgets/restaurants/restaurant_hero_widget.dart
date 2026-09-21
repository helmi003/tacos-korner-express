import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/data/home_data.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/custom_cashed_image.dart';
import 'package:takos_corner_express/widgets/others/button_icon_widget.dart';

class RestaurantHeroWidget extends StatelessWidget {
  final RestaurantModel restaurant;
  final bool isFav;
  final VoidCallback onFavToggle;

  const RestaurantHeroWidget({
    super.key,
    required this.restaurant,
    required this.isFav,
    required this.onFavToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260.h,
      child: Stack(
        children: [
          CustomCashedImage(
            restaurant.image,
            width: double.infinity,
            height: 260.h,
            fit: BoxFit.cover,
            radius: 0,
          ),
          Positioned(
            top: 48.h,
            left: 16.w,
            right: 16.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonIconWidget(
                  icon: SolarIconsOutline.altArrowLeft,
                  size: 18,
                  onTap: () => Navigator.of(context).pop(),
                ),
                Row(
                  children: [
                    ButtonIconWidget(
                      icon: SolarIconsBold.heart,
                      size: 18,
                      onTap: onFavToggle,
                      color: isFav ? danger : textLight,
                    ),
                    SizedBox(width: 8.w),
                    ButtonIconWidget(
                      icon: SolarIconsOutline.share,
                      size: 18,
                      onTap: () => SharePlus.instance.share(
                        ShareParams(
                          text:
                              'Check out ${restaurant.name} on Takos Korner Express!',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (!restaurant.isOpen)
            Positioned(
              bottom: 12.h,
              left: 16.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  'Closed',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
