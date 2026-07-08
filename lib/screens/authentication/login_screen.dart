import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/screens/authentication/forgot_password_screen.dart';
import 'package:takos_corner_express/screens/authentication/register_screen.dart';
import 'package:takos_corner_express/screens/tab_screen.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/button_widget.dart';
import 'package:takos_corner_express/widgets/global/custom_textfield.dart';
import 'package:takos_corner_express/widgets/others/or_divider.dart';
import 'package:takos_corner_express/widgets/others/social_button.dart';
import 'package:email_validator/email_validator.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/Login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.pushReplacementNamed(context, TabScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(
                  28.w,
                  MediaQuery.of(context).padding.top + 40.h,
                  28.w,
                  36.h,
                ),
                decoration: const BoxDecoration(
                  gradient: primaryGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/logo/logo_foreground.png",
                          height: 40.h,
                          width: 40.w,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          "Tako's Korner",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Welcome back! 👋',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Sign in to continue ordering',
                      style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: BorderRadius.circular(20.r),
                    border: context.border,
                    boxShadow: context.shadows,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextfield(
                          'Email',
                          'your@email.com',
                          TextInputType.emailAddress,
                          _emailCtrl,
                          (value) {
                            if (value == null || value.isEmpty) {
                              return 'The email address is required';
                            } else if (!EmailValidator.validate(value)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                          AutovalidateMode.onUserInteraction,
                          prefixIcon: SolarIconsOutline.letter,
                        ),
                        SizedBox(height: 16.h),
                        CustomTextfield(
                          'Password',
                          '••••••••',
                          TextInputType.visiblePassword,
                          _passCtrl,
                          (value) {
                            if (value == null || value.isEmpty) {
                              return 'The password is required';
                            }
                            return null;
                          },
                          AutovalidateMode.onUserInteraction,
                          prefixIcon: SolarIconsOutline.lockPassword,
                          obscure: _obscure,
                          setObscure: () =>
                              setState(() => _obscure = !_obscure),
                        ),
                        SizedBox(height: 8.h),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Navigator.pushNamed(
                              context,
                              ForgotPasswordScreen.routeName,
                            ),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        ButtonWidget(
                          'Sign In',
                          _signIn,
                          isLoading: _loading,
                          icon: SolarIconsOutline.login,
                          iconRight: true,
                        ),
                        SizedBox(height: 20.h),
                        const OrDivider(),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            Expanded(
                              child: SocialButton(
                                title: 'Google',
                                icon: 'assets/images/google.png',
                                onTap: () {},
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: SocialButton(
                                title: 'Apple',
                                icon: 'assets/images/apple.png',
                                onTap: () {},
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                color: isDark ? textMuted : textBody,
                                fontSize: 13.sp,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pushReplacementNamed(
                                context,
                                RegisterScreen.routeName,
                              ),
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
