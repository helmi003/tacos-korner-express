import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/utils/colors.dart';

class ReviewStat extends StatelessWidget {
  final double displayRating;
  final int displayCount;
  final List<int> breakdown;
  final int maxBucket;
  final bool? withDecoration;

  const ReviewStat({
    super.key,
    required this.displayRating,
    required this.displayCount,
    required this.breakdown,
    required this.maxBucket,
    this.withDecoration = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: withDecoration == true ? EdgeInsets.all(16.w) : null,
      decoration: withDecoration == true
          ? BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: context.borderColor, width: 0.5),
              boxShadow: context.shadows,
            )
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                displayRating.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 36.sp,
                  fontWeight: FontWeight.w800,
                  color: context.textColor,
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (i) {
                  final filled = i < displayRating.round();
                  return Icon(
                    SolarIconsBold.start1,
                    size: 13.sp,
                    color: filled ? context.accentAmber : context.borderColor,
                  );
                }),
              ),
              SizedBox(height: 4.h),
              Text(
                '$displayCount reviews',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: context.textMutedColor,
                ),
              ),
            ],
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: Column(
              children: List.generate(5, (i) {
                final star = 5 - i;
                final count = breakdown[star - 1];
                final ratio = maxBucket == 0 ? 0.0 : count / maxBucket;
                return Padding(
                  padding: EdgeInsets.only(bottom: i == 4 ? 0 : 6.h),
                  child: Row(
                    children: [
                      Text(
                        '$star',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: context.textMutedColor,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              height: 6.h,
                              decoration: BoxDecoration(
                                color: context.cardGrayColor,
                                borderRadius: BorderRadius.circular(99),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: ratio,
                              child: Container(
                                height: 6.h,
                                decoration: BoxDecoration(
                                  color: context.accentAmber,
                                  borderRadius: BorderRadius.circular(99),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 6.w),
                      SizedBox(
                        width: 18.w,
                        child: Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: context.textMutedColor,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
