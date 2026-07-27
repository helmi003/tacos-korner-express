import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_corner_express/data/home_data.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/custom_back_appbar.dart';
import 'package:takos_corner_express/widgets/settings/setting_card.dart';

class DeliveryZoneScreen extends StatefulWidget {
  static const routeName = '/DeliveryZoneScreen';
  const DeliveryZoneScreen({super.key});

  @override
  State<DeliveryZoneScreen> createState() => _DeliveryZoneScreenState();
}

class _DeliveryZoneScreenState extends State<DeliveryZoneScreen> {
  String _zone = restaurants.first.zone;

  @override
  Widget build(BuildContext context) {
    final zones = restaurants.map((r) => r.zone).toSet().toList();

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: customBackAppBar(context, 'Delivery Zone', ''),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SettingCard(
          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: zones.map((z) {
                final active = z == _zone;
                return GestureDetector(
                  onTap: () => setState(() => _zone = z),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 7.h,
                    ),
                    decoration: BoxDecoration(
                      color: active ? primaryColor : context.cardGrayColor,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      z,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: active ? Colors.white : context.textBodyColor,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
