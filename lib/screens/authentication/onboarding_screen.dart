import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/screens/authentication/login_screen.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/button_widget.dart';
import 'package:takos_corner_express/widgets/others/language_selector.dart';

class OnboardingScreen extends StatefulWidget {
  static const routeName = '/Onboarding';
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_FeatureItem> _features = const [
    _FeatureItem(
      icon: SolarIconsBold.delivery,
      title: 'Express Delivery',
      subtitle: '30 mins guaranteed',
      color: accentRed,
      bg: accentRedBg,
    ),
    _FeatureItem(
      icon: SolarIconsBold.leaf,
      title: 'Fresh Ingredients',
      subtitle: 'Locally sourced daily',
      color: accentGreen,
      bg: accentGreenBg,
    ),
    _FeatureItem(
      icon: SolarIconsOutline.card,
      title: 'Easy Payment',
      subtitle: 'Online or cash on delivery',
      color: accentBlue,
      bg: accentBlueBg,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < 2) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _back() {
    _controller.previousPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _getStarted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_onboarding', true);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (i) => setState(() => _currentPage = i),
            children: [
              _Slide1(),
              _Slide2(features: _features),
              _Slide3(onGetStarted: _getStarted),
            ],
          ),
          Positioned(
            bottom: 110.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) {
                final active = i == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  width: active ? 24.w : 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: active ? primaryColor : Colors.white38,
                    borderRadius: BorderRadius.circular(99),
                  ),
                );
              }),
            ),
          ),
          Positioned(
            bottom: 48.h,
            left: 24.w,
            right: 24.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _currentPage > 0
                    ? Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: ButtonWidget(
                                "Back",
                                _back,
                                icon: SolarIconsOutline.altArrowLeft,
                                isTransparent: true,
                                color: textMuted,
                              ),
                            ),
                            SizedBox(width: 20.w),
                          ],
                        ),
                      )
                    : SizedBox.shrink(),
                _currentPage < 2
                    ? Expanded(
                        child: ButtonWidget(
                          "Next",
                          _next,
                          icon: SolarIconsOutline.altArrowRight,
                          iconRight: true,
                        ),
                      )
                    : Expanded(
                        child: ButtonWidget(
                          "Get Started",
                          _getStarted,
                          icon: SolarIconsOutline.altArrowRight,
                          iconRight: true,
                        ),
                      ),
              ],
            ),
          ),
          if (_currentPage < 2)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16.h,
              right: 20.w,
              child: GestureDetector(
                onTap: _getStarted,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Slide1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(decoration: const BoxDecoration(gradient: gradientDark)),
        Positioned(
          top: -80.h,
          left: -80.w,
          child: Container(
            width: 350.w,
            height: 350.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  primaryColor.withValues(alpha: 0.4),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/logo/logo.png',
                    width: 200.w,
                    height: 200.w,
                  ),
                ),
                Text(
                  'Delicious\nfood,\ndelivered fast.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Right to your door — in under 30 minutes.',
                  style: TextStyle(color: Colors.white70, fontSize: 15.sp),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Slide2 extends StatelessWidget {
  final List<_FeatureItem> features;
  const _Slide2({required this.features});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(decoration: const BoxDecoration(gradient: gradientDark)),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60.h),
                Text(
                  "Why Tako's Korner?",
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w800,
                    color: textLight,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Everything you need, all in one place',
                  style: TextStyle(fontSize: 14.sp, color: textMuted),
                ),
                SizedBox(height: 40.h),
                ...features.map((f) => _FeatureCard(item: f)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final _FeatureItem item;
  const _FeatureCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: uiCardDark,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: uiBorderDark, width: 0.5),
        boxShadow: darkShadows,
      ),
      child: Row(
        children: [
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              color: item.bg,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(item.icon, color: item.color, size: 26.sp),
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: textLight,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                item.subtitle,
                style: TextStyle(fontSize: 12.sp, color: textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Slide3 extends StatelessWidget {
  final VoidCallback onGetStarted;
  const _Slide3({required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(decoration: const BoxDecoration(gradient: gradientDark)),
        Positioned(
          bottom: -60.h,
          right: -60.w,
          child: Container(
            width: 300.w,
            height: 300.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  primaryColor.withValues(alpha: 0.4),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 28.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logo/logo_foreground.png",
                  width: 200.w,
                ),
                Text(
                  "Tako's Korner",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Order from the best restaurants near you',
                  style: TextStyle(color: Colors.white60, fontSize: 13.sp),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40.h),
                Text(
                  'Choose your language',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 14.h),
                LanguageSelector(isDark: true),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FeatureItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color bg;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.bg,
  });
}
