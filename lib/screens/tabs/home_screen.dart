import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/data/home_data.dart';
import 'package:takos_corner_express/screens/search_screen.dart';
import 'package:takos_corner_express/screens/see_all_screen.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/utils/enums.dart';
import 'package:takos_corner_express/widgets/global/custom_appbar.dart';
import 'package:takos_corner_express/widgets/global/custom_search_textfield.dart';
import 'package:takos_corner_express/widgets/home/product_card.dart';
import 'package:takos_corner_express/widgets/home/promo_card.dart';
import 'package:takos_corner_express/widgets/home/promo_mini_card.dart';
import 'package:takos_corner_express/widgets/home/restaurant_card.dart';
import 'package:takos_corner_express/widgets/home/restaurant_quick_peek_sheet.dart';
import 'package:takos_corner_express/widgets/home/see_all_restaurants_button.dart';
import 'package:takos_corner_express/widgets/map/restaurants_map_view.dart';
import 'package:takos_corner_express/widgets/map/restaurants_view_toggle.dart';
import 'package:takos_corner_express/widgets/others/empty_card.dart';
import 'package:takos_corner_express/widgets/others/see_all_card.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/HomeScreen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchCtrl = TextEditingController();
  final _promoCtrl = PageController();
  int _promo = 0;
  RestaurantsView _restView = RestaurantsView.cards;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final next = (_promo + 1) % promos.length;
      _promoCtrl.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _promoCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newArrivals = products.where((p) => p.isNew).take(5).toList();
    final popular = products.where((p) => p.isFeatured).take(5).toList();
    final filteredRestaurants = restaurants;
    final visibleRestaurants = filteredRestaurants.take(5).toList();

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: customAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SearchScreen())),
              child: AbsorbPointer(
                child: CustomSearchTextfield(
                  'Search restaurants, dishes…',
                  searchController: _searchCtrl,
                  clearSearch: () => setState(() => _searchCtrl.clear()),
                  handleSearchChanged: (_) => setState(() {}),
                  widthBG: true,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            _buildPromoCarousel(),
            SizedBox(height: 10.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHorizontalProductSection(
                  title: 'New Arrivals',
                  icon: SolarIconsBold.courseUp,
                  iconColor: context.accentBlue,
                  items: newArrivals,
                  allItems: products.where((p) => p.isNew).toList(),
                ),
                SizedBox(height: 20.h),
                _buildHorizontalProductSection(
                  title: 'Popular Near You',
                  icon: SolarIconsBold.start1,
                  iconColor: context.accentAmber,
                  items: popular,
                  allItems: products.where((p) => p.isFeatured).toList(),
                ),
                SizedBox(height: 20.h),
                SeeAllCard(
                  title: 'Other Promotions',
                  icon: SolarIconsBold.gift,
                  iconColor: context.accentPurple,
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  height: 94.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: promos.length,
                    itemBuilder: (_, i) => PromoMiniCard(promo: promos[i]),
                  ),
                ),
                SizedBox(height: 20.h),
                _buildRestaurantsHeader(),
                SizedBox(height: 10.h),
                _restView == RestaurantsView.cards
                    ? Column(
                        children: [
                          visibleRestaurants.isEmpty
                              ? EmptyCard(
                                  message: "No restaurants found",
                                  caption:
                                      "Try adjusting your filters or search again",
                                  icon: SolarIconsBold.shop,
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: visibleRestaurants.length,
                                  itemBuilder: (_, i) => RestaurantCard(
                                    restaurant: visibleRestaurants[i],
                                    onTap: () => showRestaurantQuickPeekSheet(
                                      context,
                                      visibleRestaurants[i],
                                    ),
                                  ),
                                ),
                          if (filteredRestaurants.length > 5) ...[
                            SizedBox(height: 12.h),
                            const SeeAllRestaurantsButton(),
                          ],
                        ],
                      )
                    : RestaurantsMapView(restaurants: filteredRestaurants),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalProductSection({
    required String title,
    required List<ProductModel> items,
    required List<ProductModel> allItems,
    IconData? icon,
    Color? iconColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SeeAllCard(
          title: title,
          icon: icon,
          iconColor: iconColor,
          onSeeAll: items.isEmpty
              ? null
              : () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        SeeAllScreen.list(title: title, items: allItems),
                  ),
                ),
        ),
        SizedBox(height: 10.h),
        if (items.isEmpty)
          EmptyCard(
            message: "No dishes found",
            caption: "Try adjusting your filters or search again",
            icon: SolarIconsBold.bottle,
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                items.length,
                (index) => Padding(
                  padding: EdgeInsets.only(
                    right: index == items.length - 1 ? 0 : 10.w,
                  ),
                  child: ProductCard(product: items[index]),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRestaurantsHeader() {
    return SeeAllCard(
      title: "All Restaurants",
      icon: SolarIconsBold.shop,
      iconColor: primaryColor,
      widget: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: RestaurantsViewToggle(
          value: _restView,
          onChanged: (v) => setState(() => _restView = v),
        ),
      ),
    );
  }

  Widget _buildPromoCarousel() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: SizedBox(
        height: 160.h,
        child: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              controller: _promoCtrl,
              onPageChanged: (i) => setState(() => _promo = i),
              itemCount: promos.length,
              itemBuilder: (_, i) => PromoCard(promo: promos[i]),
            ),
            Positioned(
              bottom: 12.h,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(promos.length, (i) {
                  final active = _promo == i;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: EdgeInsets.symmetric(horizontal: 3.w),
                    width: active ? 20.w : 6.w,
                    height: 5.w,
                    decoration: BoxDecoration(
                      color: active
                          ? textLight
                          : Colors.white.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
