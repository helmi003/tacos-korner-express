import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/button_widget.dart';
import 'package:takos_corner_express/widgets/global/custom_back_appbar.dart';

class ComingSoonScreen extends StatelessWidget {
  static const routeName = '/ComingSoon';
  final String title;
  final String description;
  const ComingSoonScreen({
    super.key,
    required this.title,
    this.description =
        'This feature is under development and will be available soon. Stay tuned!',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: customBackAppBar(context, title, ''),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(SolarIconsBold.rocket2, size: 64.sp, color: primaryColor),
              SizedBox(height: 18.h),
              Text(
                "We're Working on It!",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: context.textColor,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: textMuted,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 24.h),
              ButtonWidget(
                'Go Back',
                () => Navigator.of(context).pop(),
                icon: SolarIconsBold.arrowLeft,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
