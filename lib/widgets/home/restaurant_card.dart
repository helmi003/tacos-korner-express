import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/data/home_data.dart';
import 'package:takos_corner_express/services/favorites_provider.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/custom_cashed_image.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantModel restaurant;
  final VoidCallback? onTap;
  const RestaurantCard({super.key, required this.restaurant, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isFav = context.watch<FavoritesProvider>().isRestaurantFavorite(
      restaurant.id,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: context.borderColor, width: 0.5),
          boxShadow: context.shadows,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CustomCashedImage(
                  restaurant.image,
                  width: double.infinity,
                  height: 132.h,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 10.h,
                  left: 10.w,
                  child: GestureDetector(
                    onTap: () => context
                        .read<FavoritesProvider>()
                        .toggleRestaurant(restaurant.id),
                    child: Container(
                      width: 28.w,
                      height: 28.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        SolarIconsBold.heart,
                        size: 16.sp,
                        color: isFav ? danger : Colors.white,
                      ),
                    ),
                  ),
                ),
                if (!restaurant.isOpen)
                  Positioned(
                    top: 10.h,
                    right: 10.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 3.h,
                      ),
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
            Padding(
              padding: EdgeInsets.fromLTRB(13.w, 11.h, 13.w, 13.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      color: context.textColor,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    restaurant.cuisine,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: context.textMutedColor,
                    ),
                  ),
                  SizedBox(height: 9.h),
                  Wrap(
                    spacing: 10.w,
                    runSpacing: 4.h,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            SolarIconsBold.start1,
                            size: 12.sp,
                            color: context.accentAmber,
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            '${restaurant.rating} (${restaurant.reviews})',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: context.textColor,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            SolarIconsOutline.clockCircle,
                            size: 11.sp,
                            color: context.textMutedColor,
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            restaurant.deliveryTime,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: context.textMutedColor,
                            ),
                          ),
                        ],
                      ),
                      restaurant.deliveryFee == 0
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: context.accentGreen.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Text(
                                'Free delivery',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w700,
                                  color: context.accentGreen,
                                ),
                              ),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  SolarIconsOutline.delivery,
                                  size: 11.sp,
                                  color: context.textMutedColor,
                                ),
                                SizedBox(width: 3.w),
                                Text(
                                  '\$${restaurant.deliveryFee.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: context.textMutedColor,
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        SolarIconsBold.mapPoint,
                        size: 11.sp,
                        color: textMuted,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        restaurant.zone,
                        style: TextStyle(fontSize: 10.sp, color: textMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
