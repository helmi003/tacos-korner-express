import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/custom_back_appbar.dart';

class TermsScreen extends StatelessWidget {
  static const routeName = '/Terms';
  const TermsScreen({super.key});

  static const _sections = [
    (
      "Using Tako's Korner",
      "By creating an account, you agree to use Tako's Korner only for lawful ordering of food and beverages for personal use.",
    ),
    (
      'Orders & Payment',
      'All orders are subject to restaurant availability. Prices, delivery fees, and estimated times may vary and are shown before checkout.',
    ),
    (
      'Cancellations',
      'Orders may be cancelled shortly after placement by contacting support; once preparation begins, cancellation may not be possible.',
    ),
    (
      'Changes to These Terms',
      'We may update these terms from time to time. Continued use of the app after changes means you accept the updated terms.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: customBackAppBar(context, 'Terms of Service', ''),
      body: ListView(
        padding: EdgeInsets.all(20.w),
        children: _sections
            .map((s) => _LegalSection(title: s.$1, body: s.$2))
            .toList(),
      ),
    );
  }
}

class _LegalSection extends StatelessWidget {
  final String title;
  final String body;
  const _LegalSection({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
              color: context.textColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            body,
            style: TextStyle(fontSize: 13.sp, color: textMuted, height: 1.6),
          ),
        ],
      ),
    );
  }
}
