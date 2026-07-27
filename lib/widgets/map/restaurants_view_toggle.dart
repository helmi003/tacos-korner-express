import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/utils/enums.dart';
import 'package:takos_corner_express/widgets/map/view_toggle_map.dart';

class RestaurantsViewToggle extends StatelessWidget {
  final RestaurantsView value;
  final ValueChanged<RestaurantsView> onChanged;

  const RestaurantsViewToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ViewToggleMap(
          label: 'Cards',
          icon: SolarIconsOutline.list,
          active: value == RestaurantsView.cards,
          onTap: () => onChanged(RestaurantsView.cards),
        ),
        ViewToggleMap(
          label: 'Map',
          icon: SolarIconsOutline.map,
          active: value == RestaurantsView.map,
          onTap: () => onChanged(RestaurantsView.map),
        ),
      ],
    );
  }
}
