import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:takos_corner_express/services/language_provider.dart';
import 'package:takos_corner_express/utils/colors.dart';

class CustomShimmer extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double? borderRadius;

  const CustomShimmer({
    super.key,
    required this.child,
    this.color,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = context.read<LanguageProvider>().isArabic;
    final radius = BorderRadius.circular((borderRadius ?? 6).r);

    return ClipRRect(
      borderRadius: radius,
      child: Shimmer(
        duration: const Duration(seconds: 2),
        color: color ?? context.textColor,
        colorOpacity: 0.1,
        direction: isArabic
            ? ShimmerDirection.fromRTLB()
            : ShimmerDirection.fromLTRB(),
        child: child,
      ),
    );
  }
}
