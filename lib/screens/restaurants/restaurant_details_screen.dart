import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/data/home_data.dart';
import 'package:takos_corner_express/services/favorites_provider.dart';
import 'package:takos_corner_express/services/reviews_provider.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/custom_not_found_text.dart';
import 'package:takos_corner_express/widgets/global/custom_search_textfield.dart';
import 'package:takos_corner_express/widgets/home/category_card.dart';
import 'package:takos_corner_express/widgets/home/product_card.dart';
import 'package:takos_corner_express/widgets/map/restaurants_map_view.dart';
import 'package:takos_corner_express/widgets/others/review_stat.dart';
import 'package:takos_corner_express/widgets/others/see_all_card.dart';
import 'package:takos_corner_express/widgets/restaurants/restaurant_hero_widget.dart';
import 'package:takos_corner_express/widgets/restaurants/see_all_reviews_button.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  static const routeName = '/RestaurantDetailsScreen';
  final RestaurantModel restaurant;
  const RestaurantDetailsScreen({super.key, required this.restaurant});

  @override
  State<RestaurantDetailsScreen> createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  final _searchCtrl = TextEditingController();
  int _categoryIdx = 0;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = widget.restaurant;
    final query = _searchCtrl.text.trim().toLowerCase();
    final selectedCategory = categories[_categoryIdx].label;
    final filteredProducts = products.where((p) {
      final matchesRestaurant = p.restaurantId == restaurant.id;
      final matchesCategory =
          selectedCategory == 'All' || p.category == selectedCategory;
      final matchesQuery =
          query.isEmpty || p.name.toLowerCase().contains(query);
      return matchesRestaurant && matchesCategory && matchesQuery;
    }).toList();

    final isFav = context.watch<FavoritesProvider>().isRestaurantFavorite(
      restaurant.id,
    );
    final providerCount = context.watch<ReviewsProvider>().countFor(
      restaurant.id,
    );
    final displayRating = providerCount > 0
        ? context.watch<ReviewsProvider>().averageFor(restaurant.id)
        : restaurant.rating;
    final displayCount = providerCount > 0 ? providerCount : restaurant.reviews;
    final breakdown = context.watch<ReviewsProvider>().breakdownFor(
      restaurant.id,
    );
    final maxBucket = breakdown.isEmpty
        ? 0
        : breakdown.reduce((a, b) => a > b ? a : b);

    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RestaurantHeroWidget(
              restaurant: restaurant,
              isFav: isFav,
              onFavToggle: () => context
                  .read<FavoritesProvider>()
                  .toggleRestaurant(restaurant.id),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                      color: context.textColor,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    restaurant.cuisine,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: context.textMutedColor,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    restaurant.description,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: context.textBodyColor,
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _buildDetailsCard(
                    context,
                    restaurant,
                    displayRating: displayRating,
                    displayCount: displayCount,
                    breakdown: breakdown,
                    maxBucket: maxBucket,
                  ),
                  SizedBox(height: 12.h),
                  SeeAllReviewsButton(restaurant: restaurant),
                  SizedBox(height: 24.h),
                  CustomSearchTextfield(
                    'Search dishes…',
                    searchController: _searchCtrl,
                    clearSearch: () => setState(() => _searchCtrl.clear()),
                    handleSearchChanged: (_) => setState(() {}),
                    widthBG: true,
                  ),
                  SizedBox(height: 20.h),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(categories.length, (index) {
                        final active = _categoryIdx == index;
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index == categories.length - 1 ? 0 : 10.w,
                          ),
                          child: CategoryCard(
                            category: categories[index],
                            active: active,
                            onTap: () => setState(() => _categoryIdx = index),
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  filteredProducts.isEmpty
                      ? CustomNotFoundText(
                          selectedCategory == 'All'
                              ? 'No dishes yet.'
                              : 'No $selectedCategory dishes yet.',
                        )
                      : Wrap(
                          spacing: 10.w,
                          runSpacing: 10.h,
                          children: filteredProducts
                              .map((p) => ProductCard(product: p))
                              .toList(),
                        ),
                  SizedBox(height: 24.h),
                  SeeAllCard(
                    icon: SolarIconsBold.mapPointWave,
                    iconColor: primaryColor,
                    title: 'View on map',
                  ),
                  SizedBox(height: 10.h),
                  RestaurantsMapView(
                    restaurants: [restaurant],
                    displayModal: false,
                    showItinerary: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(
    BuildContext context,
    RestaurantModel restaurant, {
    required double displayRating,
    required int displayCount,
    required List<int> breakdown,
    required int maxBucket,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.borderColor, width: 0.5),
        boxShadow: context.shadows,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _detailRow(context, SolarIconsBold.mapPoint, restaurant.address),
          SizedBox(height: 10.h),
          _detailRow(context, SolarIconsOutline.phone, restaurant.phone),
          SizedBox(height: 10.h),
          _buildHoursRow(context, restaurant),
          SizedBox(height: 10.h),
          ReviewStat(
            displayRating: displayRating,
            displayCount: displayCount,
            breakdown: breakdown,
            maxBucket: maxBucket,
            withDecoration: false,
          ),
        ],
      ),
    );
  }

  Widget _buildHoursRow(BuildContext context, RestaurantModel restaurant) {
    return Row(
      children: [
        Icon(
          SolarIconsOutline.clockCircle,
          size: 15.sp,
          color: context.textMutedColor,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            '${restaurant.openTime} – ${restaurant.closeTime}',
            style: TextStyle(fontSize: 13.sp, color: context.textBodyColor),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: restaurant.isOpen
                ? context.successBgColor
                : context.dangerBgColor,
            borderRadius: BorderRadius.circular(99),
          ),
          child: Text(
            restaurant.isOpen ? 'Open' : 'Closed',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: restaurant.isOpen ? success : danger,
            ),
          ),
        ),
      ],
    );
  }

  Widget _detailRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 15.sp, color: context.textMutedColor),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13.sp, color: context.textBodyColor),
          ),
        ),
      ],
    );
  }
}
