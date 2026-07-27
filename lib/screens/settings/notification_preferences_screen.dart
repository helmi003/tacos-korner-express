import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/custom_back_appbar.dart';
import 'package:takos_corner_express/widgets/global/custom_switch_button.dart';
import 'package:takos_corner_express/widgets/settings/setting_card.dart';
import 'package:takos_corner_express/widgets/settings/setting_title.dart';

class NotificationPreferencesScreen extends StatefulWidget {
  static const routeName = '/NotificationPreferencesScreen';
  const NotificationPreferencesScreen({super.key});

  @override
  State<NotificationPreferencesScreen> createState() =>
      _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState
    extends State<NotificationPreferencesScreen> {
  bool _orderUpdates = true;
  bool _promotions = true;
  bool _reviewReminders = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: customBackAppBar(context, 'Notification Preferences', ''),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SettingCard(
          child: Column(
            children: [
              SettingsTile(
                icon: SolarIconsBold.bell,
                label: 'Order Updates',
                sub: 'Status changes & delivery',
                trailing: CustomSwitchButton(
                  value: _orderUpdates,
                  onChanged: (v) => setState(() => _orderUpdates = v),
                ),
              ),
              SettingsTile(
                icon: SolarIconsBold.gift,
                label: 'Promotions',
                sub: 'Deals & special offers',
                trailing: CustomSwitchButton(
                  value: _promotions,
                  onChanged: (v) => setState(() => _promotions = v),
                ),
              ),
              SettingsTile(
                icon: SolarIconsBold.start1,
                label: 'Review Reminders',
                sub: 'Rate your recent orders',
                trailing: CustomSwitchButton(
                  value: _reviewReminders,
                  onChanged: (v) => setState(() => _reviewReminders = v),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
