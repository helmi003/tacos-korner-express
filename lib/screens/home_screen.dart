import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/custom_search_textfield.dart';
import 'package:takos_corner_express/widgets/others/notification_bell.dart';

// ─── Mock Data ────────────────────────────────────────────────────────────────
class _Category {
  final String emoji;
  final String label;
  const _Category(this.emoji, this.label);
}

class _Restaurant {
  final String name;
  final String cuisine;
  final double rating;
  final String deliveryTime;
  final double deliveryFee;
  final Color accent;
  final String emoji;
  const _Restaurant({
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.accent,
    required this.emoji,
  });
}

class _Product {
  final String name;
  final String restaurant;
  final double price;
  final double rating;
  final String emoji;
  const _Product({
    required this.name,
    required this.restaurant,
    required this.price,
    required this.rating,
    required this.emoji,
  });
}

const _categories = [
  _Category('🌮', 'Tacos'),
  _Category('🍔', 'Burgers'),
  _Category('🍕', 'Pizza'),
  _Category('🍣', 'Sushi'),
  _Category('🥗', 'Salads'),
  _Category('🍜', 'Noodles'),
  _Category('🥤', 'Drinks'),
  _Category('🍦', 'Desserts'),
];

const _restaurants = [
  _Restaurant(
    name: 'El Rancho Tacos',
    cuisine: 'Mexican • Tacos • Burritos',
    rating: 4.8,
    deliveryTime: '20–30 min',
    deliveryFee: 1.50,
    accent: primaryColor,
    emoji: '🌮',
  ),
  _Restaurant(
    name: 'Burger Craft',
    cuisine: 'American • Burgers • Fries',
    rating: 4.6,
    deliveryTime: '25–35 min',
    deliveryFee: 2.00,
    accent: accentAmber,
    emoji: '🍔',
  ),
  _Restaurant(
    name: 'Sakura Sushi',
    cuisine: 'Japanese • Sushi • Ramen',
    rating: 4.9,
    deliveryTime: '30–45 min',
    deliveryFee: 2.50,
    accent: accentBlue,
    emoji: '🍣',
  ),
  _Restaurant(
    name: 'La Bella Pizza',
    cuisine: 'Italian • Pizza • Pasta',
    rating: 4.5,
    deliveryTime: '20–30 min',
    deliveryFee: 1.00,
    accent: accentGreen,
    emoji: '🍕',
  ),
];

const _products = [
  _Product(name: 'Crispy Chicken Taco',  restaurant: 'El Rancho',   price: 6.50,  rating: 4.9, emoji: '🌮'),
  _Product(name: 'Double Smash Burger',  restaurant: 'Burger Craft', price: 9.90,  rating: 4.8, emoji: '🍔'),
  _Product(name: 'Spicy Tuna Roll',      restaurant: 'Sakura',       price: 12.00, rating: 4.7, emoji: '🍣'),
  _Product(name: 'Margherita Pizza',     restaurant: 'La Bella',     price: 11.50, rating: 4.6, emoji: '🍕'),
  _Product(name: 'Loaded Nachos',        restaurant: 'El Rancho',    price: 7.80,  rating: 4.5, emoji: '🧀'),
  _Product(name: 'Açaí Bowl',           restaurant: 'Fresh Bar',    price: 8.90,  rating: 4.9, emoji: '🫐'),
];

const _promos = [
  {'title': '30% OFF',       'sub': 'Your first order',       'color': primaryColor,   'emoji': '🎉'},
  {'title': 'Free Delivery', 'sub': 'Orders above \$20',      'color': secondaryColor, 'emoji': '🚀'},
  {'title': 'Combo Deal',    'sub': 'Burger + Fries + Drink', 'color': accentAmber,    'emoji': '🍔'},
];

// ─── HomeScreen ───────────────────────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  static const routeName = '/HomeScreen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchCtrl = TextEditingController();
  final _promoCtrl  = PageController();
  int _promo        = 0;
  int _categoryIdx  = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final next = (_promo + 1) % _promos.length;
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(isDark),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearch(),
                _buildPromoCarousel(isDark),
                _buildCategories(isDark),
                _buildSectionHeader('Restaurants Near You', onSeeAll: () {}),
                _buildRestaurants(isDark),
                _buildSectionHeader('Popular Items', onSeeAll: () {}),
                _buildPopularItems(isDark),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(bool isDark) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: isDark ? uiCardDark : uiCardLight,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Text('🌮', style: TextStyle(fontSize: 22.sp)),
          SizedBox(width: 6.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tako's Korner",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: context.textColor,
                ),
              ),
              Row(
                children: [
                  Icon(SolarIconsBold.mapPoint, size: 10.sp, color: primaryColor),
                  SizedBox(width: 3.w),
                  Text('Algiers, DZ',
                      style: TextStyle(fontSize: 10.sp, color: textMuted)),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        const NotificationBell(),
        SizedBox(width: 14.w),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(0.5.h),
        child: Divider(
          height: 0.5.h,
          thickness: 0.5,
          color: isDark ? uiBorderDark : uiBorderLight,
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
      child: CustomSearchTextfield(
        'Search restaurants, dishes…',
        searchController: _searchCtrl,
        clearSearch: () => setState(() => _searchCtrl.clear()),
        handleSearchChanged: (_) => setState(() {}),
        widthBG: true,
      ),
    );
  }

  Widget _buildPromoCarousel(bool isDark) {
    return Column(
      children: [
        SizedBox(
          height: 140.h,
          child: Padding(
            padding: EdgeInsets.only(top: 14.h),
            child: PageView.builder(
              controller: _promoCtrl,
              onPageChanged: (i) => setState(() => _promo = i),
              itemCount: _promos.length,
              itemBuilder: (_, i) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: _PromoCard(promo: _promos[i]),
              ),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_promos.length, (i) {
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

  Widget _buildCategories(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 10.h),
          child: Text(
            'Categories',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: context.textColor,
            ),
          ),
        ),
        SizedBox(
          height: 80.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            itemCount: _categories.length,
            itemBuilder: (_, i) {
              final active = _categoryIdx == i;
              return GestureDetector(
                onTap: () => setState(() => _categoryIdx = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: active
                        ? primaryColor
                        : (isDark ? uiCardDark : uiCardLight),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: active
                          ? primaryColor
                          : (isDark ? uiBorderDark : uiBorderLight),
                      width: 1,
                    ),
                    boxShadow:
                        active ? [] : (isDark ? darkShadows : lightShadows),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_categories[i].emoji,
                          style: TextStyle(fontSize: 22.sp)),
                      SizedBox(height: 4.h),
                      Text(
                        _categories[i].label,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: active
                              ? Colors.white
                              : (isDark ? textMuted : textBody),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title,
      {required VoidCallback onSeeAll}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: context.textColor,
            ),
          ),
          GestureDetector(
            onTap: onSeeAll,
            child: Text(
              'See all',
              style: TextStyle(
                fontSize: 13.sp,
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurants(bool isDark) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: _restaurants.length,
      itemBuilder: (_, i) =>
          _RestaurantCard(restaurant: _restaurants[i], isDark: isDark),
    );
  }

  Widget _buildPopularItems(bool isDark) {
    return SizedBox(
      height: 210.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        itemCount: _products.length,
        itemBuilder: (_, i) =>
            _ProductCard(product: _products[i], isDark: isDark),
      ),
    );
  }
}

// ─── Promo Card ───────────────────────────────────────────────────────────────
class _PromoCard extends StatelessWidget {
  final Map<String, dynamic> promo;
  const _PromoCard({required this.promo});

  @override
  Widget build(BuildContext context) {
    final color = promo['color'] as Color;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18.r),
      ),
      padding: EdgeInsets.all(20.w),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    'LIMITED OFFER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  promo['title'] as String,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  promo['sub'] as String,
                  style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                ),
              ],
            ),
          ),
          Text(promo['emoji'] as String, style: TextStyle(fontSize: 52.sp)),
        ],
      ),
    );
  }
}

// ─── Restaurant Card ──────────────────────────────────────────────────────────
class _RestaurantCard extends StatelessWidget {
  final _Restaurant restaurant;
  final bool isDark;
  const _RestaurantCard({required this.restaurant, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark ? uiCardDark : uiCardLight,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? uiBorderDark : uiBorderLight,
          width: 0.5,
        ),
        boxShadow: isDark ? darkShadows : lightShadows,
      ),
      child: Row(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: restaurant.accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Center(
              child: Text(restaurant.emoji,
                  style: TextStyle(fontSize: 28.sp)),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: isDark ? textLight : textMain,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(restaurant.cuisine,
                    style: TextStyle(fontSize: 11.sp, color: textMuted)),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(SolarIconsBold.star,
                        size: 12.sp, color: accentAmber),
                    SizedBox(width: 3.w),
                    Text(
                      restaurant.rating.toString(),
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? textLight : textMain,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Icon(SolarIconsOutline.clockCircle,
                        size: 11.sp, color: textMuted),
                    SizedBox(width: 3.w),
                    Text(restaurant.deliveryTime,
                        style: TextStyle(fontSize: 11.sp, color: textMuted)),
                    SizedBox(width: 10.w),
                    Icon(SolarIconsOutline.delivery,
                        size: 11.sp, color: textMuted),
                    SizedBox(width: 3.w),
                    Text(
                      '\$${restaurant.deliveryFee.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 11.sp, color: textMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(SolarIconsOutline.altArrowRight,
              size: 16.sp, color: textMuted),
        ],
      ),
    );
  }
}

// ─── Product Card ─────────────────────────────────────────────────────────────
class _ProductCard extends StatelessWidget {
  final _Product product;
  final bool isDark;
  const _ProductCard({required this.product, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.w,
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
        color: isDark ? uiCardDark : uiCardLight,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? uiBorderDark : uiBorderLight,
          width: 0.5,
        ),
        boxShadow: isDark ? darkShadows : lightShadows,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 110.h,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Center(
              child: Text(product.emoji,
                  style: TextStyle(fontSize: 44.sp)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? textLight : textMain,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 3.h),
                Text(product.restaurant,
                    style: TextStyle(fontSize: 10.sp, color: textMuted)),
                SizedBox(height: 6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(SolarIconsBold.star,
                            size: 10.sp, color: accentAmber),
                        SizedBox(width: 2.w),
                        Text(
                          product.rating.toString(),
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark ? textLight : textMain,
                          ),
                        ),
                      ],
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
