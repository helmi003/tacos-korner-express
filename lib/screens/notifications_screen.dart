import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/custom_back_appbar.dart';

class NotificationsScreen extends StatelessWidget {
  static const routeName = '/Notifications';
  const NotificationsScreen({super.key});

  static const _items = [
    (
      '🛒',
      'Order Confirmed',
      'Your order has been placed and is being prepared.',
    ),
    ('🚗', 'Order On The Way', 'Your delivery rider is heading to you.'),
    ('🎉', '20% Off Pizza', 'Use code NEWUSER on your next order.'),
    ('⭐', 'Rate Your Last Order', 'Tell us how we did — it only takes a sec.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: customBackAppBar(context, 'Notifications', ''),
      body: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: _items.length,
        separatorBuilder: (_, _) => SizedBox(height: 10.h),
        itemBuilder: (_, i) {
          final item = _items[i];
          return Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: context.borderColor, width: 0.5),
              boxShadow: context.shadows,
            ),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(item.$1, style: TextStyle(fontSize: 18.sp)),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.$2,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: context.textColor,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        item.$3,
                        style: TextStyle(fontSize: 11.sp, color: textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
