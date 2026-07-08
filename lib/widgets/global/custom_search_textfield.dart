import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/utils/colors.dart';

class CustomSearchTextfield extends StatelessWidget {
  final String hintTitle;
  final TextEditingController searchController;
  final VoidCallback clearSearch;
  final ValueChanged<String> handleSearchChanged;
  final bool? widthBG;
  final bool isDropdown;
  final FocusNode? focusNode;

  const CustomSearchTextfield(
    this.hintTitle, {
    super.key,
    required this.searchController,
    required this.clearSearch,
    required this.handleSearchChanged,
    this.widthBG,
    this.isDropdown = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      focusNode: focusNode,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        filled: true,
        fillColor: widthBG == true
            ? context.cardColor
            : context.backgroundColor,
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: isDropdown ? 10.h : 6.h,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: context.borderColor, width: 0.5.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: context.borderColor, width: 0.5.w),
        ),
        prefixIcon: Icon(
          Icons.search,
          size: 14.sp,
          color: textMutedLight,
        ),
        suffixIcon: searchController.text.isNotEmpty
            ? IconButton(
                icon: Icon(
                  SolarIconsOutline.closeCircle,
                  size: 14.sp,
                  color: textMuted,
                ),
                onPressed: clearSearch,
              )
            : null,
        hintText: hintTitle,
        hintStyle: TextStyle(color: textMutedLight, fontSize: 12.sp),
      ),
      onChanged: handleSearchChanged,
    );
  }
}
