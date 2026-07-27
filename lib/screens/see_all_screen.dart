import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/data/home_data.dart';
import 'package:takos_corner_express/models/search_filters_model.dart';
import 'package:takos_corner_express/screens/restaurants/restaurant_details_screen.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/utils/enums.dart';
import 'package:takos_corner_express/utils/search_filter_utils.dart';
import 'package:takos_corner_express/widgets/global/custom_back_appbar.dart';
import 'package:takos_corner_express/widgets/home/product_card.dart';
import 'package:takos_corner_express/widgets/home/restaurant_card.dart';
import 'package:takos_corner_express/widgets/map/restaurants_map_view.dart';
import 'package:takos_corner_express/widgets/map/restaurants_view_toggle.dart';
import 'package:takos_corner_express/widgets/others/empty_card.dart';
import 'package:takos_corner_express/widgets/search/category_chips_row.dart';
import 'package:takos_corner_express/widgets/search/search_action_bar.dart';
import 'package:takos_corner_express/widgets/search/search_filters_sheet.dart';

class SeeAllScreen extends StatefulWidget {
  static const routeName = '/SeeAllScreen';
  final String? title;
  final List<ProductModel>? items;
  final SearchScope? type;
  final String initialQuery;
  final String? initialCategory;
  final SearchFilters initialFilters;

  const SeeAllScreen.list({
    super.key,
    required String this.title,
    required List<ProductModel> this.items,
  }) : type = null,
       initialQuery = '',
       initialCategory = null,
       initialFilters = const SearchFilters();

  const SeeAllScreen.search({
    super.key,
    required SearchScope type,
    this.initialQuery = '',
    this.initialCategory,
    this.initialFilters = const SearchFilters(),
  }) : assert(
         type != SearchScope.all,
         'SeeAllScreen.search requires .products or .restaurants',
       ),
       title = null,
       items = null,
       type = type;

  @override
  State<SeeAllScreen> createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends State<SeeAllScreen> {
  late final _searchCtrl = TextEditingController(text: widget.initialQuery);
  final _focusNode = FocusNode();

  late String _query = widget.initialQuery.trim().toLowerCase();
  late String? _selectedCategory = widget.initialCategory;
  late SearchFilters _filters = widget.initialFilters;
  RestaurantsView _restView = RestaurantsView.cards;

  @override
  void dispose() {
    _searchCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
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

  void _submitSearch(String text) {
    _focusNode.unfocus();
    setState(() => _query = text.trim().toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == null) {
      return _buildListMode(context);
    }
    return _buildSearchMode(context);
  }

  Widget _buildListMode(BuildContext context) {
    final items = widget.items!;
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: customBackAppBar(context, widget.title!, ''),
      body: items.isEmpty
          ? const EmptyCard(
              icon: SolarIconsOutline.cardSearch,
              message: 'Nothing here yet.',
            )
          : GridView.builder(
              padding: EdgeInsets.all(20.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 10.w,
                mainAxisExtent: 200.h,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) =>
                  ProductCard(product: items[index]),
            ),
    );
  }

  Widget _buildSearchMode(BuildContext context) {
    final isProducts = widget.type == SearchScope.products;
    final title = isProducts ? 'Dishes' : 'Restaurants';

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: customBackAppBar(context, title, ''),
        floatingActionButton: isProducts
            ? null
            : Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: context.shadows,
                ),
                child: RestaurantsViewToggle(
                  value: _restView,
                  onChanged: (v) => setState(() => _restView = v),
                ),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                onSearchTap: () => _submitSearch(_searchCtrl.text),
                onFilterTap: _openFilters,
              ),
              SizedBox(height: 20.h),
              CategoryChipsRow(
                selectedCategory: _selectedCategory,
                onSelect: (c) => setState(() => _selectedCategory = c),
              ),
              SizedBox(height: 20.h),
              if (isProducts)
                _buildProducts(context)
              else if (_restView == RestaurantsView.cards)
                _buildRestaurants(context)
              else
                RestaurantsMapView(
                  restaurants: filterAndSortRestaurants(
                    source: restaurants,
                    query: _query,
                    category: _selectedCategory,
                    filters: _filters,
                  ),
                ),
              SizedBox(height: 80.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProducts(BuildContext context) {
    final results = filterAndSortProducts(
      source: products,
      query: _query,
      category: _selectedCategory,
      filters: _filters,
    );
    if (results.isEmpty) {
      return const EmptyCard(
        icon: SolarIconsOutline.cardSearch,
        message: "No results found.",
        caption: "We couldn't find any results for your search.",
      );
    }
    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: results.map((p) => ProductCard(product: p)).toList(),
    );
  }

  Widget _buildRestaurants(BuildContext context) {
    final results = filterAndSortRestaurants(
      source: restaurants,
      query: _query,
      category: _selectedCategory,
      filters: _filters,
    );
    if (results.isEmpty) {
      return const EmptyCard(
        icon: SolarIconsOutline.cardSearch,
        message: "No results found.",
        caption: "We couldn't find any results for your search.",
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: results
          .map(
            (r) => RestaurantCard(
              restaurant: r,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RestaurantDetailsScreen(restaurant: r),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
