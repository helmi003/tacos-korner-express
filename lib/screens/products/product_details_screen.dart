import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/data/home_data.dart';
import 'package:takos_corner_express/screens/products/product_customizer_screen.dart';
import 'package:takos_corner_express/screens/restaurants/restaurant_details_screen.dart';
import 'package:takos_corner_express/services/cart_provider.dart';
import 'package:takos_corner_express/services/favorites_provider.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/custom_cashed_image.dart';
import 'package:takos_corner_express/widgets/global/custom_snackbar.dart';
import 'package:takos_corner_express/widgets/products/product_hero_widget.dart';
import 'package:takos_corner_express/widgets/products/qty_stepper.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const routeName = '/ProductDetailsScreen';
  final ProductModel product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _qty = 1;

  void _addToCart() {
    final product = widget.product;
    for (var i = 0; i < _qty; i++) {
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
    }
    CustomSnackbar.show(
      context,
      message: '${widget.product.name} added to cart',
      type: SnackbarType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final restaurant = restaurantOf(product);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductHeroWidget(
                    product: product,
                    isFav: context.watch<FavoritesProvider>().isProductFavorite(
                      product.name,
                    ),
                    onFavToggle: () => context
                        .read<FavoritesProvider>()
                        .toggleProduct(product.name),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (product.isNew) ...[
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 3.h,
                                ),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(99),
                                ),
                                child: Text(
                                  'NEW',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(width: 6.w),
                            ],
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 3.h,
                              ),
                              decoration: BoxDecoration(
                                color: context.cardGrayColor,
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Text(
                                product.category,
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w700,
                                  color: context.textBodyColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w800,
                            color: context.textColor,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w800,
                                color: primaryColor,
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Icon(
                              SolarIconsBold.start1,
                              size: 14.sp,
                              color: context.accentAmber,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '${product.rating} (${product.reviews})',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: context.textColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 14.h),
                        Text(
                          product.description,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: textMuted,
                            height: 1.6,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          'AVAILABLE AT',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: textMuted,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => RestaurantDetailsScreen(
                                restaurant: restaurant,
                              ),
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: context.cardColor,
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(
                                color: context.borderColor,
                                width: 0.5,
                              ),
                              boxShadow: context.shadows,
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: CustomCashedImage(
                                    restaurant.image,
                                    width: 48.w,
                                    height: 48.w,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        restaurant.name,
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w700,
                                          color: context.textColor,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4.h),
                                      Row(
                                        children: [
                                          Icon(
                                            SolarIconsBold.mapPoint,
                                            size: 11.sp,
                                            color: context.textMutedColor,
                                          ),
                                          SizedBox(width: 3.w),
                                          Expanded(
                                            child: Text(
                                              restaurant.zone,
                                              style: TextStyle(
                                                fontSize: 11.sp,
                                                color: context.textMutedColor,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          Icon(
                                            SolarIconsBold.start1,
                                            size: 11.sp,
                                            color: context.accentAmber,
                                          ),
                                          SizedBox(width: 3.w),
                                          Text(
                                            '${restaurant.rating}',
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w600,
                                              color: context.textColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Icon(
                                  SolarIconsOutline.altArrowRight,
                                  size: 16.sp,
                                  color: context.textMutedColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
              16.w,
              12.h,
              16.w,
              MediaQuery.of(context).padding.bottom + 12.h,
            ),
            decoration: BoxDecoration(
              color: context.cardColor,
              border: Border(
                top: BorderSide(color: context.borderColor, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                if (!product.isCustomizable) ...[
                  QtyStepper(
                    qty: _qty,
                    onDecrement: () {
                      if (_qty > 1) setState(() => _qty--);
                    },
                    onIncrement: () => setState(() => _qty++),
                    iconSize: 20,
                    useIconButton: true,
                  ),
                  SizedBox(width: 12.w),
                ],
                Expanded(
                  child: GestureDetector(
                    onTap: product.isCustomizable
                        ? () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductCustomizerScreen(product: product),
                            ),
                          )
                        : _addToCart,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 13.h),
                      decoration: BoxDecoration(
                        gradient: primaryGradient,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            product.isCustomizable
                                ? SolarIconsBold.tuning_2
                                : SolarIconsBold.cartLarge2,
                            size: 17.sp,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            product.isCustomizable
                                ? 'Customise & Order'
                                : 'Add to Cart',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
