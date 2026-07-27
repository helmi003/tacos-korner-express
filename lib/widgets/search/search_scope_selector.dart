import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/utils/enums.dart';

class SearchScopeSelector extends StatelessWidget {
  final SearchScope value;
  final ValueChanged<SearchScope> onChanged;
  const SearchScopeSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final options = [
      (scope: SearchScope.all, label: 'All', icon: SolarIconsBold.widget_2),
      (
        scope: SearchScope.restaurants,
        label: 'Restaurants',
        icon: SolarIconsBold.shop,
      ),
      (
        scope: SearchScope.products,
        label: 'Dishes',
        icon: SolarIconsBold.bottle,
      ),
    ];

    return Row(
      children: options.map((option) {
        final active = value == option.scope;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: option.scope == SearchScope.products ? 0 : 8.w,
            ),
            child: GestureDetector(
              onTap: () => onChanged(option.scope),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 12.h),
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
                    Icon(
                      option.icon,
                      size: 18.sp,
                      color: active ? textLight : context.textBodyColor,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      option.label,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: active ? textLight : context.textBodyColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
