import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/data/home_data.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/custom_cashed_image.dart';

class ProductHeroWidget extends StatelessWidget {
  final ProductModel product;
  final bool isFav;
  final VoidCallback onFavToggle;

  const ProductHeroWidget({
    super.key,
    required this.product,
    required this.isFav,
    required this.onFavToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260.h,
      child: Stack(
        children: [
          CustomCashedImage(
            product.image,
            width: double.infinity,
            height: 260.h,
            fit: BoxFit.cover,
            radius: 0,
          ),
          Positioned(
            top: 48.h,
            left: 16.w,
            right: 16.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _HeroIconBtn(
                  icon: SolarIconsOutline.altArrowLeft,
                  onTap: () => Navigator.of(context).pop(),
                ),
                Row(
                  children: [
                    _HeroIconBtn(
                      icon: isFav
                          ? SolarIconsBold.heart
                          : SolarIconsOutline.heart,
                      onTap: onFavToggle,
                      color: isFav ? danger : null,
                    ),
                    SizedBox(width: 8.w),
                    _HeroIconBtn(
                      icon: SolarIconsOutline.share,
                      onTap: () => SharePlus.instance.share(
                        ShareParams(
                          text:
                              'Check out ${product.name} on Takos Korner Express!',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  const _HeroIconBtn({required this.icon, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.w,
        height: 36.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18.sp, color: color ?? textMain),
      ),
    );
  }
}
