import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/custom_search_textfield.dart';

class SearchActionBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  final VoidCallback clearSearch;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onSearchTap;
  final VoidCallback onFilterTap;

  const SearchActionBar({
    super.key,
    required this.controller,
    this.focusNode,
    this.hintText = 'Search restaurants, dishes…',
    required this.clearSearch,
    required this.onChanged,
    required this.onSubmitted,
    required this.onSearchTap,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: CustomSearchTextfield(
            hintText,
            searchController: controller,
            clearSearch: clearSearch,
            handleSearchChanged: onChanged,
            onSubmitted: onSubmitted,
            widthBG: true,
            isDropdown: true,
            focusNode: focusNode,
          ),
        ),
        SizedBox(width: 8.w),
        GestureDetector(
          onTap: onSearchTap,
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: context.shadows,
            ),
            child: Icon(Icons.search, size: 18.sp, color: textLight),
          ),
        ),
        SizedBox(width: 4.w),
        GestureDetector(
          onTap: onFilterTap,
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: secondaryLight,
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: context.shadows,
            ),
            child: Icon(SolarIconsBold.tuning_4, size: 18.sp, color: textLight),
          ),
        ),
      ],
    );
  }
}
