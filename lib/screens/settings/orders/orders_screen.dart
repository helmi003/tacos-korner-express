import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/data/orders_data.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/utils/enums.dart';
import 'package:takos_corner_express/widgets/global/custom_back_appbar.dart';
import 'package:takos_corner_express/widgets/global/custom_cashed_image.dart';
import 'package:takos_corner_express/widgets/global/custom_not_found_text.dart';
import 'package:takos_corner_express/widgets/orders/orders_view_toggle.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/OrdersScreen';
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  OrdersView _view = OrdersView.active;

  @override
  Widget build(BuildContext context) {
    final showActive = _view == OrdersView.active;
    final list = orders.where((o) => o.isActive == showActive).toList();

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: customBackAppBar(context, 'My Orders', ''),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: context.cardGrayColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: OrdersViewToggle(
                value: _view,
                onChanged: (v) => setState(() => _view = v),
              ),
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? const Center(child: CustomNotFoundText('No orders here yet.'))
                : ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: list.length,
                    separatorBuilder: (_, _) => SizedBox(height: 12.h),
                    itemBuilder: (_, i) => _OrderTile(order: list[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  final OrderModel order;
  const _OrderTile({required this.order});

  ({String label, Color color}) _statusInfo(BuildContext context) =>
      switch (order.status) {
        OrderStatus.preparing => (
          label: 'Preparing',
          color: context.accentAmber,
        ),
        OrderStatus.onTheWay => (label: 'On the way', color: context.tertiary),
        OrderStatus.delivered => (
          label: 'Delivered',
          color: context.accentGreen,
        ),
        OrderStatus.cancelled => (label: 'Cancelled', color: danger),
      };

  @override
  Widget build(BuildContext context) {
    final status = _statusInfo(context);
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.borderColor, width: 0.5),
        boxShadow: context.shadows,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (order.items.length == 1)
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: CustomCashedImage(
                order.items.first.imageUrl,
                width: 56.w,
                height: 56.w,
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(SolarIconsBold.bag2, color: primaryColor, size: 24.sp),
            ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        order.restaurantName,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: context.textColor,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: status.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        status.label,
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w700,
                          color: status.color,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  order.itemsSummary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11.sp, color: textMuted),
                ),
                SizedBox(height: 6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          SolarIconsOutline.clockCircle,
                          size: 11.sp,
                          color: textMuted,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          order.date,
                          style: TextStyle(fontSize: 10.sp, color: textMuted),
                        ),
                      ],
                    ),
                    Text(
                      '\$${order.total.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                        color: primaryColor,
                      ),
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
