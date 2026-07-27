import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_corner_express/utils/colors.dart';

class SettingCard extends StatelessWidget {
  const SettingCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.borderColor, width: 0.5),
        boxShadow: context.shadows,
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(color: context.cardColor, child: child),
    );
  }
}
