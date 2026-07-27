import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_corner_express/data/home_data.dart';
import 'package:takos_corner_express/widgets/global/custom_cashed_image.dart';

class PromoCard extends StatelessWidget {
  final PromoModel promo;
  const PromoCard({super.key, required this.promo});

  @override
  Widget build(BuildContext context) {
    return Container(
      // No margin — the parent ClipRRect owns the border radius
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Full-bleed background image ──────────────────────────────
          CustomCashedImage(
            promo.image,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            radius: 0,
          ),

          // ── Dark overlay — strong left, fades right ──────────────────
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.black.withValues(alpha: 0.88),
                  Colors.black.withValues(alpha: 0.55),
                  Colors.black.withValues(alpha: 0.10),
                ],
                stops: const [0.0, 0.55, 1.0],
              ),
            ),
          ),

          // ── Content ──────────────────────────────────────────────────
          Positioned(
            left: 20.w,
            top: 0,
            bottom: 0,
            right: 80.w, // leave right edge for image bleed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  promo.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                    height: 1.15,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 5.h),
                Text(
                  promo.sub,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 14.h),
                _CtaButton(label: promo.cta),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CtaButton extends StatelessWidget {
  final String label;
  const _CtaButton({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.black,
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
