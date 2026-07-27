import 'package:flutter/material.dart';
import 'package:takos_corner_express/utils/enums.dart';

class SearchFilters {
  final String? zone;
  final double? nearMeLat;
  final double? nearMeLng;
  final PriceSort priceSort;
  final NameSort nameSort;
  final RangeValues? priceRange;
  final Set<String> excludedAllergens;

  const SearchFilters({
    this.zone,
    this.nearMeLat,
    this.nearMeLng,
    this.priceSort = PriceSort.any,
    this.nameSort = NameSort.any,
    this.priceRange,
    this.excludedAllergens = const {},
  });

  bool get isActive =>
      zone != null ||
      nearMeLat != null ||
      priceSort != PriceSort.any ||
      nameSort != NameSort.any ||
      priceRange != null ||
      excludedAllergens.isNotEmpty;

  SearchFilters copyWith({
    String? zone,
    bool clearZone = false,
    double? nearMeLat,
    double? nearMeLng,
    bool clearNearMe = false,
    PriceSort? priceSort,
    NameSort? nameSort,
    RangeValues? priceRange,
    bool clearPriceRange = false,
    Set<String>? excludedAllergens,
  }) {
    return SearchFilters(
      zone: clearZone ? null : (zone ?? this.zone),
      nearMeLat: clearNearMe ? null : (nearMeLat ?? this.nearMeLat),
      nearMeLng: clearNearMe ? null : (nearMeLng ?? this.nearMeLng),
      priceSort: priceSort ?? this.priceSort,
      nameSort: nameSort ?? this.nameSort,
      priceRange: clearPriceRange ? null : (priceRange ?? this.priceRange),
      excludedAllergens: excludedAllergens ?? this.excludedAllergens,
    );
  }
}
