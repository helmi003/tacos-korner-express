import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/data/support_data.dart';
import 'package:takos_corner_express/helpers/link_helper.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/button_widget.dart';
import 'package:takos_corner_express/widgets/global/custom_back_appbar.dart';
import 'package:takos_corner_express/widgets/others/info_card.dart';

class AboutScreen extends StatefulWidget {
  static const routeName = '/About';
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() => _packageInfo = info);
  }

  @override
  Widget build(BuildContext context) {
    final versionLabel = _packageInfo == null
        ? ''
        : 'Version ${_packageInfo!.version} (${_packageInfo!.buildNumber})';

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: customBackAppBar(context, 'About', ''),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset('assets/images/logo/logo.png', width: 96.w),
                  SizedBox(height: 12.h),
                  Text(
                    "Tako's Korner",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                      color: context.textColor,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Great food, delivered fast.',
                    style: TextStyle(fontSize: 13.sp, color: textMuted),
                  ),
                  if (versionLabel.isNotEmpty) ...[
                    SizedBox(height: 6.h),
                    Text(
                      versionLabel,
                      style: TextStyle(fontSize: 11.sp, color: textMuted),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 24.h),
            InfoCard(
              label: 'ABOUT US',
              title: "Tako's Korner Express",
              description:
                  "We connect you with the best local restaurants and dishes, "
                  "with fast delivery and real-time order tracking — all in "
                  "one app.",
              icon: SolarIconsBold.chefHat,
            ),
            SizedBox(height: 12.h),
            InfoCard(
              label: 'CONTACT',
              title: supportEmail,
              description: supportPhone,
              icon: SolarIconsBold.letter,
            ),
            SizedBox(height: 20.h),
            ButtonWidget(
              'Share this App',
              () => shareApp(context),
              icon: SolarIconsBold.share,
              isTransparent: true,
            ),
          ],
        ),
      ),
    );
  }
}
