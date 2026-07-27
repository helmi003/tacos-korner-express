import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/data/support_data.dart';
import 'package:takos_corner_express/helpers/link_helper.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/button_widget.dart';
import 'package:takos_corner_express/widgets/global/custom_back_appbar.dart';
import 'package:takos_corner_express/widgets/global/restaurant_action_button.dart';

class HelpScreen extends StatelessWidget {
  static const routeName = '/Help';
  const HelpScreen({super.key});

  static const _faqs = [
    (
      'Where is my order?',
      'Track it live from My Orders — tap the Live badge on Home.',
    ),
    (
      'How do I cancel an order?',
      'Contact support within 5 minutes of placing your order.',
    ),
    (
      'How do promo codes work?',
      'Enter a code at checkout — try TACO10 or WELCOME.',
    ),
    (
      'How do I change my delivery zone?',
      'Tap the location pill on Home to pick a new zone.',
    ),
    (
      'How does the price range filter work?',
      'Open Filters from Search and drag the slider to only show dishes '
          'within your budget.',
    ),
    (
      'What does "Near Me" do in the Zone filter?',
      'It uses your device location to only show restaurants within 5km '
          'of you — tap it in Filters and allow location access.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: customBackAppBar(context, 'Help & Support', ''),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'QUICK CONTACT',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: textMuted,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: RestaurantActionButton(
                    label: 'Call Us',
                    icon: SolarIconsBold.phoneCalling,
                    onTap: () => openPhone(context, supportPhone),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: RestaurantActionButton(
                    label: 'Email Us',
                    icon: SolarIconsBold.letter,
                    onTap: () => openEmail(
                      context,
                      supportEmail,
                      subject: 'Support Request',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Text(
              'FREQUENTLY ASKED QUESTIONS',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: textMuted,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: context.cardColor,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: context.borderColor,
                        width: 0.5,
                      ),
                      boxShadow: context.shadows,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Theme(
                      data: Theme.of(
                        context,
                      ).copyWith(dividerColor: Colors.transparent),
                      child: Column(
                        children: _faqs.asMap().entries.map((e) {
                          final isLast = e.key == _faqs.length - 1;
                          return Column(
                            children: [
                              ExpansionTile(
                                tilePadding: EdgeInsets.symmetric(
                                  horizontal: 14.w,
                                ),
                                childrenPadding: EdgeInsets.fromLTRB(
                                  14.w,
                                  0,
                                  14.w,
                                  14.h,
                                ),
                                expandedAlignment: Alignment.centerLeft,
                                iconColor: primaryColor,
                                collapsedIconColor: context.textMutedColor,
                                title: Text(
                                  e.value.$1,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                    color: context.textColor,
                                  ),
                                ),
                                children: [
                                  Text(
                                    e.value.$2,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: textMuted,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                              if (!isLast)
                                Divider(
                                  height: 0.5,
                                  thickness: 0.5,
                                  indent: 14.w,
                                  endIndent: 14.w,
                                  color: context.borderColor,
                                ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ButtonWidget(
                    'Contact Us',
                    () => openEmail(
                      context,
                      supportEmail,
                      subject: 'Support Request',
                    ),
                    icon: SolarIconsBold.chatRoundDots,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
