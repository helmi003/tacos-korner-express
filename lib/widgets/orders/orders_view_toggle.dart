import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/utils/enums.dart';
import 'package:takos_corner_express/widgets/map/view_toggle_map.dart';

class OrdersViewToggle extends StatelessWidget {
  final OrdersView value;
  final ValueChanged<OrdersView> onChanged;

  const OrdersViewToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: context.shadows,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ViewToggleMap(
            label: 'Active',
            icon: SolarIconsOutline.clockCircle,
            active: value == OrdersView.active,
            onTap: () => onChanged(OrdersView.active),
          ),
          ViewToggleMap(
            label: 'Past',
            icon: SolarIconsOutline.checkCircle,
            active: value == OrdersView.past,
            onTap: () => onChanged(OrdersView.past),
          ),
        ],
      ),
    );
  }
}
