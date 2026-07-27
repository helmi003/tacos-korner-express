import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/data/home_data.dart';
import 'package:takos_corner_express/screens/restaurants/restaurant_details_screen.dart';
import 'package:takos_corner_express/services/favorites_provider.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/custom_back_appbar.dart';
import 'package:takos_corner_express/widgets/home/product_card.dart';
import 'package:takos_corner_express/widgets/home/restaurant_card.dart';
import 'package:takos_corner_express/widgets/others/empty_card.dart';

class FavouritesScreen extends StatelessWidget {
  static const routeName = '/FavouritesScreen';
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();
    final favoriteProducts = products
        .where((p) => favorites.isProductFavorite(p.name))
        .toList();
    final favoriteRestaurants = restaurants
        .where((r) => favorites.isRestaurantFavorite(r.id))
        .toList();

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: customBackAppBar(context, 'Favourites', ''),
      body: favoriteProducts.isEmpty && favoriteRestaurants.isEmpty
          ? Padding(
              padding: EdgeInsets.all(16.w),
              child: const EmptyCard(
                icon: SolarIconsOutline.heart,
                message: 'No favourites yet.',
                caption:
                    'Tap the heart on a dish or restaurant to save it here.',
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (favoriteProducts.isNotEmpty) ...[
                    _sectionTitle('DISHES'),
                    SizedBox(height: 10.h),
                    Wrap(
                      spacing: 10.w,
                      runSpacing: 10.h,
                      children: favoriteProducts
                          .map((p) => ProductCard(product: p))
                          .toList(),
                    ),
                    SizedBox(height: 20.h),
                  ],
                  if (favoriteRestaurants.isNotEmpty) ...[
                    _sectionTitle('RESTAURANTS'),
                    SizedBox(height: 10.h),
                    ...favoriteRestaurants.map(
                      (r) => RestaurantCard(
                        restaurant: r,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                RestaurantDetailsScreen(restaurant: r),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
        color: textMuted,
        letterSpacing: 0.5,
      ),
    );
  }
}
