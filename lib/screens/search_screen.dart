import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/data/home_data.dart';
import 'package:takos_corner_express/models/search_filters_model.dart';
import 'package:takos_corner_express/screens/restaurants/restaurant_details_screen.dart';
import 'package:takos_corner_express/screens/see_all_screen.dart';
import 'package:takos_corner_express/services/recent_searches_service.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/utils/enums.dart';
import 'package:takos_corner_express/utils/search_filter_utils.dart';
import 'package:takos_corner_express/widgets/global/custom_back_appbar.dart';
import 'package:takos_corner_express/widgets/home/product_card.dart';
import 'package:takos_corner_express/widgets/home/restaurant_card.dart';
import 'package:takos_corner_express/widgets/others/empty_card.dart';
import 'package:takos_corner_express/widgets/others/see_all_card.dart';
import 'package:takos_corner_express/widgets/search/category_chips_row.dart';
import 'package:takos_corner_express/widgets/search/search_action_bar.dart';
import 'package:takos_corner_express/widgets/search/search_filters_sheet.dart';
import 'package:takos_corner_express/widgets/search/search_scope_selector.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/SearchScreen';
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchCtrl = TextEditingController();
  final _focusNode = FocusNode();

  List<String> _recentSearches = [];
  SearchScope _scope = SearchScope.all;
  String? _selectedCategory;
  SearchFilters _filters = const SearchFilters();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() {}));
    _loadRecentSearches();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadRecentSearches() async {
    final list = await RecentSearchesService.getAll();
    if (!mounted) return;
    setState(() => _recentSearches = list);
  }

  void _setQuery(String q) => setState(() => _searchCtrl.text = q);

  Future<void> _submitSearch(String text) async {
    final trimmed = text.trim();
    setState(() => _query = trimmed.toLowerCase());
    if (trimmed.isEmpty) return;
    await RecentSearchesService.add(trimmed);
    await _loadRecentSearches();
  }

  void _selectRecentSearch(String term) {
    _setQuery(term);
    _focusNode.unfocus();
    _submitSearch(term);
  }

  Future<void> _removeRecentSearch(String term) async {
    setState(() => _recentSearches.remove(term));
    await RecentSearchesService.remove(term);
  }

  Future<void> _clearAllRecent() async {
    setState(() => _recentSearches = []);
    await RecentSearchesService.clear();
  }

  Future<void> _openFilters() async {
    _focusNode.unfocus();
    final zones = restaurants.map((r) => r.zone).toSet().toList()..sort();
    final result = await showSearchFiltersSheet(
      context,
      current: _filters,
      zones: zones,
      maxPrice: maxProductPrice,
    );
    if (result != null) setState(() => _filters = result);
  }

  @override
  Widget build(BuildContext context) {
    final fieldText = _searchCtrl.text.trim().toLowerCase();
    final query = _query;

    final showRestaurants = _scope != SearchScope.products;
    final showProducts = _scope != SearchScope.restaurants;

    final restaurantResults = showRestaurants
        ? filterAndSortRestaurants(
            source: restaurants,
            query: query,
            category: _selectedCategory,
            filters: _filters,
          )
        : <RestaurantModel>[];

    final productResults = showProducts
        ? filterAndSortProducts(
            source: products,
            query: query,
            category: _selectedCategory,
            filters: _filters,
          )
        : <ProductModel>[];

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: customBackAppBar(context, "Search", ""),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchActionBar(
                controller: _searchCtrl,
                focusNode: _focusNode,
                clearSearch: () => setState(() {
                  _searchCtrl.clear();
                  _query = '';
                }),
                onChanged: (_) => setState(() {}),
                onSubmitted: _submitSearch,
                onSearchTap: () {
                  _focusNode.unfocus();
                  _submitSearch(_searchCtrl.text);
                },
                onFilterTap: _openFilters,
              ),
              if (_focusNode.hasFocus &&
                  fieldText.isEmpty &&
                  _recentSearches.isNotEmpty)
                _buildRecentSearchesDropdown(context),
              SizedBox(height: 20.h),
              _buildScopeAndFilterRow(context),
              SizedBox(height: 20.h),
              CategoryChipsRow(
                selectedCategory: _selectedCategory,
                onSelect: (c) => setState(() => _selectedCategory = c),
              ),
              SizedBox(height: 20.h),
              _buildResults(context, restaurantResults, productResults),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentSearchesDropdown(BuildContext context) {
    final recent = _recentSearches.take(10).toList();
    return Padding(
      padding: EdgeInsets.only(top: 4.h),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 260.h),
        child: Container(
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(12.r),
            border: context.border,
            boxShadow: context.shadows,
          ),
          child: Material(
            type: MaterialType.transparency,
            borderRadius: BorderRadius.circular(12.r),
            clipBehavior: Clip.antiAlias,
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: 4.h),
              itemCount: recent.length + 1,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: uiBorderLight.withValues(alpha: 0.5),
              ),
              itemBuilder: (context, i) {
                if (i == 0) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'RECENT SEARCHES',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: context.textMutedColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                        GestureDetector(
                          onTap: _clearAllRecent,
                          child: Text(
                            'Clear all',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                final search = recent[i - 1];
                return ListTile(
                  dense: true,
                  leading: Icon(
                    SolarIconsOutline.history,
                    size: 16.sp,
                    color: context.textMutedColor,
                  ),
                  title: Text(
                    search,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: context.textBodyColor,
                    ),
                  ),
                  trailing: GestureDetector(
                    onTap: () => _removeRecentSearch(search),
                    child: Icon(
                      SolarIconsOutline.closeCircle,
                      size: 14.sp,
                      color: context.textMutedColor,
                    ),
                  ),
                  onTap: () => _selectRecentSearch(search),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScopeAndFilterRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SearchScopeSelector(
            value: _scope,
            onChanged: (scope) => setState(() => _scope = scope),
          ),
        ),
      ],
    );
  }

  Widget _buildResults(
    BuildContext context,
    List<RestaurantModel> restaurantResults,
    List<ProductModel> productResults,
  ) {
    if (restaurantResults.isEmpty && productResults.isEmpty) {
      return const EmptyCard(
        icon: SolarIconsOutline.cardSearch,
        message: "No results found.",
        caption: "We couldn't find any results for your search.",
      );
    }
    final products = productResults.take(5);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (productResults.isNotEmpty) ...[
          SeeAllCard(
            title: 'DISHES',
            icon: SolarIconsBold.rollingPin,
            iconColor: context.accentGreen,
            onSeeAll: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => SeeAllScreen.search(
                  type: SearchScope.products,
                  initialQuery: _query,
                  initialCategory: _selectedCategory,
                  initialFilters: _filters,
                ),
              ),
            ),
          ),
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
                  child: ProductCard(product: products.elementAt(index)),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
        ],
        if (restaurantResults.isNotEmpty) ...[
          SeeAllCard(
            title: 'RESTAURANTS',
            icon: SolarIconsBold.chefHat,
            iconColor: context.accentAmber,
            onSeeAll: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => SeeAllScreen.search(
                  type: SearchScope.restaurants,
                  initialQuery: _query,
                  initialCategory: _selectedCategory,
                  initialFilters: _filters,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          ...restaurantResults
              .take(5)
              .map(
                (r) => RestaurantCard(
                  restaurant: r,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RestaurantDetailsScreen(restaurant: r),
                    ),
                  ),
                ),
              ),
        ],
      ],
    );
  }
}
