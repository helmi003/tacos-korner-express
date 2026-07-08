import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takos_corner_express/main.dart';
import 'package:takos_corner_express/screens/authentication/onboarding_screen.dart';
import 'package:takos_corner_express/screens/tab_screen.dart';
import 'package:takos_corner_express/widgets/global/custom_error_dialog.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = "/SplashScreen";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.1, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );

    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (startupError != null) {
        CustomErrorDialog.show(context, startupError!);
        return;
      }
      _startSplashTimer();
    });
  }

  void _startSplashTimer() async {
    await Future.delayed(const Duration(seconds: 2));
    loadDataAndNavigate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void loadDataAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool('seen_onboarding') ?? false;
    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      seenOnboarding ? TabScreen.routeName : OnboardingScreen.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScaleTransition(
        scale: _animation,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(30.w),
            child: Image.asset("assets/images/logo/logo.png", width: 200.w),
          ),
        ),
      ),
    );
  }
}
