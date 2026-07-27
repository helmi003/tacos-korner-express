import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/screens/settings/orders/orders_screen.dart';
import 'package:takos_corner_express/screens/tabs/tab_screen.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/button_widget.dart';

class OrderSuccessScreen extends StatelessWidget {
  static const routeName = '/OrderSuccessScreen';
  final String orderNumber;
  const OrderSuccessScreen({super.key, required this.orderNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90.w,
                height: 90.w,
                decoration: BoxDecoration(
                  color: context.accentGreen.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  SolarIconsBold.checkCircle,
                  size: 48.sp,
                  color: context.accentGreen,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Order Confirmed! 🎉',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: context.textColor,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Your order has been placed successfully. The restaurant is now preparing your food.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: textMuted,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 24.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: context.borderColor, width: 0.5),
                ),
                child: Column(
                  children: [
                    Text(
                      'ORDER NUMBER',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: textMuted,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '#$orderNumber',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: context.accentAmber.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Row(
                  children: [
                    Text('⏱️', style: TextStyle(fontSize: 22.sp)),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Estimated Delivery Time',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: context.textColor,
                          ),
                        ),
                        Text(
                          '30–40 minutes',
                          style: TextStyle(fontSize: 12.sp, color: textMuted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              ButtonWidget(
                'Track My Order',
                () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const OrdersScreen()),
                  (route) => route.settings.name == TabScreen.routeName,
                ),
                icon: SolarIconsBold.mapPointWave,
              ),
              SizedBox(height: 10.h),
              ButtonWidget(
                'Back to Home',
                () => Navigator.of(
                  context,
                ).popUntil((route) => route.settings.name == TabScreen.routeName),
                isTransparent: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
