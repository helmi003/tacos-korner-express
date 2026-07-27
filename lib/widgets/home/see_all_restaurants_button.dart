import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/screens/see_all_screen.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/utils/enums.dart';

class SeeAllRestaurantsButton extends StatelessWidget {
  const SeeAllRestaurantsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SeeAllScreen.search(type: SearchScope.restaurants),
        ),
      ),
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
                SolarIconsBold.shop,
                size: 16.sp,
                color: context.textMutedColor,
              ),
              SizedBox(width: 8.w),
              Text(
                'See all restaurants',
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
    );
  }
}
