import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/data/home_data.dart';
import 'package:takos_corner_express/screens/products/product_customizer_screen.dart';
import 'package:takos_corner_express/screens/products/product_details_screen.dart';
import 'package:takos_corner_express/screens/restaurants/restaurant_details_screen.dart';
import 'package:takos_corner_express/services/cart_provider.dart';
import 'package:takos_corner_express/services/favorites_provider.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/custom_cashed_image.dart';
import 'package:takos_corner_express/widgets/global/custom_snackbar.dart';
import 'package:takos_corner_express/widgets/others/button_icon_widget.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  const ProductCard({super.key, required this.product});

  void _quickAdd(BuildContext context) {
    context.read<CartProvider>().addItem(
      CartItem(
        id: product.name,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.image,
        restaurantName: '',
      ),
    );
    CustomSnackbar.show(
      context,
      message: '${product.name} added to cart',
      type: SnackbarType.success,
    );
  }

  void _openDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product)),
    );
  }

  void _openCustomizer(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductCustomizerScreen(product: product),
      ),
    );
  }

  void _openRestaurant(BuildContext context, RestaurantModel restaurant) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RestaurantDetailsScreen(restaurant: restaurant),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCustomizable = product.isCustomizable;
    final restaurant = restaurantOf(product);
    final isFav = context.watch<FavoritesProvider>().isProductFavorite(
      product.name,
    );

    return GestureDetector(
      onTap: () =>
          isCustomizable ? _openCustomizer(context) : _openDetails(context),
      child: Container(
        width: 146.w,
        margin: EdgeInsets.symmetric(horizontal: 5.w),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: context.borderColor, width: 0.5),
          boxShadow: context.shadows,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CustomCashedImage(
                  product.image,
                  width: double.infinity,
                  height: 80.h,
                  fit: BoxFit.cover,
                  radius: 0,
                ),
                Positioned(
                  top: 6.h,
                  right: 6.w,
                  child: ButtonIconWidget(
                    icon: SolarIconsBold.heart,
                    color: isFav ? danger : textLight,
                    onTap: () {
                      context.read<FavoritesProvider>().toggleProduct(
                        product.name,
                      );
                      CustomSnackbar.show(
                        context,
                        message: !isFav
                            ? '${product.name} added to favorites'
                            : '${product.name} removed from favorites',
                        type: SnackbarType.info,
                      );
                    },
                  ),
                ),
                if (product.isNew)
                  Positioned(
                    top: 6.h,
                    left: 6.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        'NEW',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 6.h,
                  left: 6.w,
                  right: 6.w,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => _openRestaurant(context, restaurant),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              SolarIconsBold.shop,
                              size: 8.sp,
                              color: Colors.white,
                            ),
                            SizedBox(width: 3.w),
                            Flexible(
                              child: Text(
                                restaurant.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 9.h, 10.w, 11.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30.h,
                    child: Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: context.textColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                          color: primaryColor,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => isCustomizable
                            ? _openCustomizer(context)
                            : _quickAdd(context),
                        child: isCustomizable
                            ? _CustomizeButton()
                            : _QuickAddButton(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAddButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 27.w,
      height: 27.w,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(SolarIconsBold.addCircle, size: 16.sp, color: Colors.white),
    );
  }
}

class _CustomizeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 27.w,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: context.accentOrange.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: context.accentOrange.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            SolarIconsBold.tuning_2,
            size: 11.sp,
            color: context.accentOrange,
          ),
          SizedBox(width: 3.w),
          Text(
            'Build',
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: context.accentOrange,
            ),
          ),
        ],
      ),
    );
  }
}
