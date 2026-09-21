import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/data/home_data.dart';
import 'package:takos_corner_express/models/search_filters_model.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/utils/enums.dart';
import 'package:takos_corner_express/utils/search_filter_utils.dart';
import 'package:takos_corner_express/widgets/others/selectable_chip.dart';

Future<SearchFilters?> showSearchFiltersSheet(
  BuildContext context, {
  required SearchFilters current,
  required List<String> zones,
  required double maxPrice,
}) {
  return showModalBottomSheet<SearchFilters>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) =>
        _SearchFiltersSheet(current: current, zones: zones, maxPrice: maxPrice),
  );
}

const _priceSortLabels = {
  PriceSort.any: 'Any',
  PriceSort.lowToHigh: 'Low → High',
  PriceSort.highToLow: 'High → Low',
};

const _nameSortLabels = {
  NameSort.any: 'Any',
  NameSort.aToZ: 'A → Z',
  NameSort.zToA: 'Z → A',
};

const Map<String, IconData> _allergenIcons = {
  'Gluten': Icons.bakery_dining,
  'Dairy': SolarIconsBold.bottle,
  'Nuts': Icons.eco,
  'Peanuts': Icons.grass,
  'Shellfish': Icons.anchor,
  'Fish': Icons.set_meal,
  'Egg': Icons.egg_alt,
  'Soy': Icons.grain,
};

class _SearchFiltersSheet extends StatefulWidget {
  final SearchFilters current;
  final List<String> zones;
  final double maxPrice;
  const _SearchFiltersSheet({
    required this.current,
    required this.zones,
    required this.maxPrice,
  });

  @override
  State<_SearchFiltersSheet> createState() => _SearchFiltersSheetState();
}

class _SearchFiltersSheetState extends State<_SearchFiltersSheet> {
  String? _zone;
  double? _nearMeLat;
  double? _nearMeLng;
  bool _locatingNearMe = false;
  late PriceSort _priceSort;
  late NameSort _nameSort;
  late RangeValues _priceRange;
  late Set<String> _excludedAllergens;

  @override
  void initState() {
    super.initState();
    _zone = widget.current.zone;
    _nearMeLat = widget.current.nearMeLat;
    _nearMeLng = widget.current.nearMeLng;
    _priceSort = widget.current.priceSort;
    _nameSort = widget.current.nameSort;
    _priceRange = widget.current.priceRange ?? RangeValues(0, widget.maxPrice);
    _excludedAllergens = {...widget.current.excludedAllergens};
  }

  void _reset() {
    setState(() {
      _zone = null;
      _nearMeLat = null;
      _nearMeLng = null;
      _priceSort = PriceSort.any;
      _nameSort = NameSort.any;
      _priceRange = RangeValues(0, widget.maxPrice);
      _excludedAllergens = {};
    });
  }

  void _selectZone(String? zone) {
    setState(() {
      _zone = zone;
      _nearMeLat = null;
      _nearMeLng = null;
    });
  }

  Future<void> _selectNearMe() async {
    if (_locatingNearMe) return;
    setState(() => _locatingNearMe = true);
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enable location services')),
          );
        }
        return;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied')),
          );
        }
        return;
      }
      final pos = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      setState(() {
        _zone = null;
        _nearMeLat = pos.latitude;
        _nearMeLng = pos.longitude;
      });
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not get your location')),
        );
      }
    } finally {
      if (mounted) setState(() => _locatingNearMe = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 60.h),
        decoration: BoxDecoration(
          color: context.backgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: context.borderColor,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filters',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800,
                            color: context.textColor,
                          ),
                        ),
                        TextButton(
                          onPressed: _reset,
                          child: Text(
                            'Reset',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    _sectionTitle('ZONE'),
                    SizedBox(height: 10.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        SelectableChip(
                          label: 'Any',
                          active: _zone == null && _nearMeLat == null,
                          onTap: () => _selectZone(null),
                        ),
                        SelectableChip(
                          label:
                              'Near Me (${nearMeRadiusKm.toStringAsFixed(0)}km)',
                          active: _nearMeLat != null,
                          loading: _locatingNearMe,
                          leadingIcon: SolarIconsOutline.gps,
                          onTap: _selectNearMe,
                        ),
                        ...widget.zones.map(
                          (z) => SelectableChip(
                            label: z,
                            active: _zone == z,
                            onTap: () => _selectZone(z),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    _sectionTitle('SORT BY PRICE'),
                    SizedBox(height: 10.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: PriceSort.values.map((option) {
                        return SelectableChip(
                          label: _priceSortLabels[option]!,
                          active: _priceSort == option,
                          onTap: () => setState(() => _priceSort = option),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20.h),
                    _sectionTitle('SORT BY NAME'),
                    SizedBox(height: 10.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: NameSort.values.map((option) {
                        return SelectableChip(
                          label: _nameSortLabels[option]!,
                          active: _nameSort == option,
                          onTap: () => setState(() => _nameSort = option),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20.h),
                    _sectionTitle('PRICE RANGE'),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${_priceRange.start.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: context.textBodyColor,
                          ),
                        ),
                        Text(
                          '\$${_priceRange.end.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: context.textBodyColor,
                          ),
                        ),
                      ],
                    ),
                    RangeSlider(
                      values: _priceRange,
                      min: 0,
                      max: widget.maxPrice,
                      activeColor: primaryColor,
                      inactiveColor: context.borderColor,
                      labels: RangeLabels(
                        '\$${_priceRange.start.toStringAsFixed(2)}',
                        '\$${_priceRange.end.toStringAsFixed(2)}',
                      ),
                      onChanged: (value) => setState(() => _priceRange = value),
                    ),
                    SizedBox(height: 12.h),
                    _sectionTitle('EXCLUDE ALLERGIES'),
                    SizedBox(height: 10.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: allergensList.map((allergen) {
                        final active = _excludedAllergens.contains(allergen);
                        return SelectableChip(
                          label: allergen,
                          active: active,
                          activeColor: danger,
                          leadingIcon: _allergenIcons[allergen],
                          onTap: () => setState(() {
                            if (active) {
                              _excludedAllergens.remove(allergen);
                            } else {
                              _excludedAllergens.add(allergen);
                            }
                          }),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 24.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final isFullRange =
                              _priceRange.start <= 0 &&
                              _priceRange.end >= widget.maxPrice;
                          Navigator.of(context).pop(
                            SearchFilters(
                              zone: _zone,
                              nearMeLat: _nearMeLat,
                              nearMeLng: _nearMeLng,
                              priceSort: _priceSort,
                              nameSort: _nameSort,
                              priceRange: isFullRange ? null : _priceRange,
                              excludedAllergens: _excludedAllergens,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        child: Text(
                          'Apply Filters',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
