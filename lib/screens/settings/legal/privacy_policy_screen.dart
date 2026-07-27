import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/custom_back_appbar.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  static const routeName = '/PrivacyPolicy';
  const PrivacyPolicyScreen({super.key});

  static const _sections = [
    (
      'Information We Collect',
      'We collect your name, email, delivery address, and order history to provide and improve our food delivery service.',
    ),
    (
      'How We Use Your Data',
      'Your data is used to process orders, send delivery updates, and personalize recommendations. We never sell your data to third parties.',
    ),
    (
      'Your Rights',
      'You may request access to, correction of, or deletion of your personal data at any time via Help & Support.',
    ),
    (
      'Contact',
      'Questions about this policy? Reach us via the Help & Support screen.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: customBackAppBar(context, 'Privacy Policy', ''),
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
