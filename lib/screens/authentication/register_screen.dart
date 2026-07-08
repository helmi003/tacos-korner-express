import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/screens/authentication/login_screen.dart';
import 'package:takos_corner_express/screens/tab_screen.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/button_widget.dart';
import 'package:takos_corner_express/widgets/global/custom_checkbox.dart';
import 'package:takos_corner_express/widgets/global/custom_phone_number_field.dart';
import 'package:takos_corner_express/widgets/global/custom_textfield.dart';
import 'package:takos_corner_express/widgets/others/or_divider.dart';
import 'package:takos_corner_express/widgets/others/password_strength_bar.dart';
import 'package:takos_corner_express/widgets/others/password_strength_criteria.dart'
    show StrengthCriteria;
import 'package:takos_corner_express/widgets/others/social_button.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/Register';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confCtrl = TextEditingController();
  PhoneNumber _phone = PhoneNumber(isoCode: 'DZ');

  bool _obscurePass = true;
  bool _obscureConf = true;
  bool _termsAccepted = false;
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _confCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the terms to continue')),
      );
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.pushReplacementNamed(context, TabScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(
                28.w,
                MediaQuery.of(context).padding.top + 24.h,
                28.w,
                32.h,
              ),
              decoration: const BoxDecoration(
                gradient: secondaryGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        SolarIconsOutline.altArrowLeft,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Text('🌮', style: TextStyle(fontSize: 22.sp)),
                      SizedBox(width: 8.w),
                      Text(
                        "Tako's Korner",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Create Account 🎉',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Join thousands of happy foodies',
                    style: TextStyle(color: Colors.white70, fontSize: 13.sp),
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
                        'Full Name',
                        'John Doe',
                        TextInputType.name,
                        _nameCtrl,
                        (v) => v == null || v.isEmpty ? 'Required' : null,
                        AutovalidateMode.onUserInteraction,
                        prefixIcon: SolarIconsOutline.user,
                      ),
                      SizedBox(height: 14.h),
                      CustomTextfield(
                        'Email',
                        'your@email.com',
                        TextInputType.emailAddress,
                        _emailCtrl,
                        (v) {
                          if (v == null || v.isEmpty) return 'Required';
                          if (!v.contains('@')) return 'Enter a valid email';
                          return null;
                        },
                        AutovalidateMode.onUserInteraction,
                        prefixIcon: SolarIconsOutline.letter,
                      ),
                      SizedBox(height: 14.h),
                      CustomPhoneNumberField(
                        "Phone Number",
                        _phoneCtrl,
                        isRequired: true,
                        onInputChanged: (p) => _phone = p,
                      ),
                      SizedBox(height: 14.h),
                      CustomTextfield(
                        'Password',
                        '••••••••',
                        TextInputType.visiblePassword,
                        _passCtrl,
                        (v) {
                          if (v == null || v.isEmpty) return 'Required';
                          if (v.length < 8) return 'Min. 8 characters';
                          return null;
                        },
                        AutovalidateMode.onUserInteraction,
                        prefixIcon: SolarIconsOutline.lockPassword,
                        obscure: _obscurePass,
                        setObscure: () =>
                            setState(() => _obscurePass = !_obscurePass),
                      ),
                      SizedBox(height: 8.h),
                      PasswordStrengthBar(password: _passCtrl.text),
                      SizedBox(height: 4.h),
                      StrengthCriteria(password: _passCtrl.text),
                      SizedBox(height: 14.h),
                      CustomTextfield(
                        'Confirm Password',
                        '••••••••',
                        TextInputType.visiblePassword,
                        _confCtrl,
                        (v) {
                          if (v == null || v.isEmpty) return 'Required';
                          if (v != _passCtrl.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        AutovalidateMode.onUserInteraction,
                        prefixIcon: SolarIconsOutline.lockPassword,
                        obscure: _obscureConf,
                        setObscure: () =>
                            setState(() => _obscureConf = !_obscureConf),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomCheckbox(
                            value: _termsAccepted,
                            onChanged: (v) =>
                                setState(() => _termsAccepted = v ?? false),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: isDark ? textMuted : textBody,
                                ),
                                children: [
                                  const TextSpan(text: 'I agree to the '),
                                  TextSpan(
                                    text: 'Terms of Service',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const TextSpan(text: ' and '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      ButtonWidget(
                        'Create Account',
                        _register,
                        isLoading: _loading,
                        bgColor: secondaryColor,
                        icon: SolarIconsBold.arrowRight,
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
                            'Already have an account? ',
                            style: TextStyle(
                              color: isDark ? textMuted : textBody,
                              fontSize: 13.sp,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushReplacementNamed(
                              context,
                              LoginScreen.routeName,
                            ),
                            child: Text(
                              'Sign In',
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
    );
  }
}
