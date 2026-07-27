import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_corner_express/data/home_data.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/home/category_card.dart';

class CategoryChipsRow extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onSelect;

  const CategoryChipsRow({
    super.key,
    required this.selectedCategory,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BROWSE BY CATEGORIES',
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: textMuted,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 10.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(categories.length, (index) {
              final c = categories[index];
              final active = c.label == 'All'
                  ? selectedCategory == null
                  : selectedCategory == c.label;
              return Padding(
                padding: EdgeInsets.only(
                  right: index == categories.length - 1 ? 0 : 10.w,
                ),
                child: CategoryCard(
                  category: c,
                  active: active,
                  onTap: () => onSelect(c.label == 'All' ? null : c.label),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
