import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_corner_express/data/home_data.dart';
import 'package:takos_corner_express/utils/colors.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final bool active;
  final VoidCallback onTap;
  const CategoryCard({
    super.key,
    required this.category,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(horizontal: 5.w),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: active ? primaryColor : context.cardColor,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: active ? primaryColor : context.borderColor,
            width: 1,
          ),
          boxShadow: context.shadows,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(category.emoji, style: TextStyle(fontSize: 22.sp)),
            SizedBox(height: 4.h),
            Text(
              category.label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: active ? textLight : context.textBodyColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
