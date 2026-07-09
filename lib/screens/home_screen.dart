import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_corner_express/data/home_data.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/custom_appbar.dart';
import 'package:takos_corner_express/widgets/global/custom_search_textfield.dart';
import 'package:takos_corner_express/widgets/home/category_card.dart';
import 'package:takos_corner_express/widgets/home/product_card.dart';
import 'package:takos_corner_express/widgets/home/promo_card.dart';
import 'package:takos_corner_express/widgets/home/restaurant_card.dart';
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
  int _categoryIdx = 0;
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
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: customAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSearchTextfield(
              'Search restaurants, dishes…',
              searchController: _searchCtrl,
              clearSearch: () => setState(() => _searchCtrl.clear()),
              handleSearchChanged: (_) => setState(() {}),
              widthBG: true,
            ),
            SizedBox(height: 20.h),
            _buildPromoCarousel(),
            SizedBox(height: 10.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SeeAllCard(title: 'Categories'),
                SizedBox(height: 10.h),
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
                SeeAllCard(title: 'Restaurants Near You', onSeeAll: () {}),
                SizedBox(height: 10.h),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: restaurants.length,
                  itemBuilder: (_, i) =>
                      RestaurantCard(restaurant: restaurants[i]),
                ),
                SeeAllCard(title: 'Popular Items', onSeeAll: () {}),
                SizedBox(height: 10.h),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      products.length,
                      (index) => Padding(
                        padding: EdgeInsets.only(
                          right: index == products.length - 1 ? 0 : 10.w,
                        ),
                        child: ProductCard(product: products[index]),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 140.h,
          child: PageView.builder(
            controller: _promoCtrl,
            onPageChanged: (i) => setState(() => _promo = i),
            itemCount: promos.length,
            itemBuilder: (_, i) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: PromoCard(promo: promos[i]),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(promos.length, (i) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: EdgeInsets.symmetric(horizontal: 3.w),
              width: _promo == i ? 18.w : 6.w,
              height: 6.w,
              decoration: BoxDecoration(
                color: _promo == i
                    ? primaryColor
                    : textMuted.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(99),
              ),
            );
          }),
        ),
      ],
    );
  }
}
