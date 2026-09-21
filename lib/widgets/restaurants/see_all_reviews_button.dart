import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/data/home_data.dart';
import 'package:takos_corner_express/screens/restaurants/restaurant_reviews_screen.dart';
import 'package:takos_corner_express/services/reviews_provider.dart';
import 'package:takos_corner_express/utils/colors.dart';

class SeeAllReviewsButton extends StatefulWidget {
  final RestaurantModel restaurant;
  const SeeAllReviewsButton({super.key, required this.restaurant});

  @override
  State<SeeAllReviewsButton> createState() => _SeeAllReviewsButtonState();
}

class _SeeAllReviewsButtonState extends State<SeeAllReviewsButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final providerCount = context.watch<ReviewsProvider>().countFor(
      widget.restaurant.id,
    );
    final displayCount = providerCount > 0
        ? providerCount
        : widget.restaurant.reviews;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => RestaurantReviewsScreen(restaurant: widget.restaurant),
        ),
      ),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: DottedBorder(
          options: RoundedRectDottedBorderOptions(
            radius: Radius.circular(16.r),
            color: context.textMutedColor.withValues(alpha: 0.5),
            strokeWidth: 1.5,
            dashPattern: const [6, 4],
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 14.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: context.cardColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  SolarIconsBold.start1,
                  size: 16.sp,
                  color: context.textMutedColor,
                ),
                SizedBox(width: 8.w),
                Text(
                  'See all $displayCount reviews',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: context.textMutedColor,
                  ),
                ),
                SizedBox(width: 6.w),
                Icon(
                  SolarIconsOutline.altArrowRight,
                  size: 14.sp,
                  color: context.textMutedColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
