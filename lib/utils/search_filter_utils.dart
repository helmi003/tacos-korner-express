import 'package:geolocator/geolocator.dart';
import 'package:takos_corner_express/data/home_data.dart';
import 'package:takos_corner_express/models/search_filters_model.dart';
import 'package:takos_corner_express/utils/enums.dart';

const nearMeRadiusKm = 5.0;

List<RestaurantModel> filterAndSortRestaurants({
  required List<RestaurantModel> source,
  required String query,
  String? category,
  required SearchFilters filters,
}) {
  final q = query.trim().toLowerCase();
  var results = source;

  if (category != null) {
    results = results
        .where((r) => r.cuisine.toLowerCase().contains(category.toLowerCase()))
        .toList();
  }
  if (q.isNotEmpty) {
    results = results
        .where(
          (r) =>
              r.name.toLowerCase().contains(q) ||
              r.cuisine.toLowerCase().contains(q),
        )
        .toList();
  }
  if (filters.zone != null) {
    results = results.where((r) => r.zone == filters.zone).toList();
  }
  if (filters.nearMeLat != null && filters.nearMeLng != null) {
    results = results
        .where(
          (r) =>
              Geolocator.distanceBetween(
                filters.nearMeLat!,
                filters.nearMeLng!,
                r.lat,
                r.lng,
              ) <=
              nearMeRadiusKm * 1000,
        )
        .toList();
  }
  if (filters.nameSort != NameSort.any) {
    results = [...results]
      ..sort(
        (a, b) => filters.nameSort == NameSort.aToZ
            ? a.name.compareTo(b.name)
            : b.name.compareTo(a.name),
      );
  }
  return results;
}

List<ProductModel> filterAndSortProducts({
  required List<ProductModel> source,
  required String query,
  String? category,
  required SearchFilters filters,
}) {
  final q = query.trim().toLowerCase();
  var results = source;

  if (category != null) {
    results = results.where((p) => p.category == category).toList();
  }
  if (q.isNotEmpty) {
    results = results
        .where(
          (p) =>
              p.name.toLowerCase().contains(q) ||
              p.category.toLowerCase().contains(q),
        )
        .toList();
  }
  if (filters.excludedAllergens.isNotEmpty) {
    results = results
        .where((p) => !p.allergens.any(filters.excludedAllergens.contains))
        .toList();
  }
  if (filters.priceRange != null) {
    final range = filters.priceRange!;
    results = results
        .where((p) => p.price >= range.start && p.price <= range.end)
        .toList();
  }
  if (filters.priceSort != PriceSort.any || filters.nameSort != NameSort.any) {
    results = [...results]..sort((a, b) => _compareProducts(a, b, filters));
  }
  return results;
}

int _compareProducts(ProductModel a, ProductModel b, SearchFilters filters) {
  if (filters.priceSort != PriceSort.any) {
    final priceCmp = filters.priceSort == PriceSort.lowToHigh
        ? a.price.compareTo(b.price)
        : b.price.compareTo(a.price);
    if (priceCmp != 0) return priceCmp;
  }
  if (filters.nameSort != NameSort.any) {
    return filters.nameSort == NameSort.aToZ
        ? a.name.compareTo(b.name)
        : b.name.compareTo(a.name);
  }
  return 0;
}
