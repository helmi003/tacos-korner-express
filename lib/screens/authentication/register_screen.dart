import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/helpers/password_helper.dart';
import 'package:takos_corner_express/screens/authentication/login_screen.dart';
import 'package:takos_corner_express/screens/tab_screen.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/auth/auth_header.dart';
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
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confCtrl = TextEditingController();
  PhoneNumber _phone = PhoneNumber(isoCode: 'DZ');

  bool _obscurePass = true;
  bool _obscureConf = true;
  bool _termsAccepted = false;
  bool _loading = false;
  String? _termsError;

  @override
  void initState() {
    super.initState();
    _passCtrl.addListener(_onPasswordChanged);
  }

  void _onPasswordChanged() => setState(() {});

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _confCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    print(_phone);
    if (!_termsAccepted) {
      setState(() => _termsError = 'Please accept the terms to continue');
      return;
    }
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
              AuthHeader(
                secondaryGradient,
                'Create Account 🎉',
                'Join thousands of happy foodies',
                showBackButton: true,
                onTap: () => Navigator.pop(context),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextfield(
                          'First Name',
                          'John',
                          TextInputType.name,
                          _firstNameCtrl,
                          (value) {
                            if (value == null || value.isEmpty) {
                              return "The first name is required";
                            }
                            return null;
                          },
                          AutovalidateMode.onUserInteraction,
                          prefixIcon: SolarIconsOutline.user,
                          isRequired: true,
                          widthBG: true,
                        ),
                        SizedBox(height: 14.h),
                        CustomTextfield(
                          'Last Name',
                          'Doe',
                          TextInputType.name,
                          _lastNameCtrl,
                          (value) {
                            if (value == null || value.isEmpty) {
                              return "The last name is required";
                            }
                            return null;
                          },
                          AutovalidateMode.onUserInteraction,
                          prefixIcon: SolarIconsOutline.user,
                          isRequired: true,
                          widthBG: true,
                        ),
                        SizedBox(height: 14.h),
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
                          isRequired: true,
                          widthBG: true,
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
                          (value) {
                            if (value == null || value.isEmpty) {
                              return "The password is required";
                            } else if (!hasMinLength(value)) {
                              return "The password must be at least 8 characters";
                            } else if (!hasLetterAndNumber(value)) {
                              return "The password must contain both letters and numbers";
                            } else if (!hasUppercase(value)) {
                              return "The password must contain at least one uppercase letter";
                            }
                            return null;
                          },
                          AutovalidateMode.onUserInteraction,
                          prefixIcon: SolarIconsOutline.lockPassword,
                          obscure: _obscurePass,
                          setObscure: () =>
                              setState(() => _obscurePass = !_obscurePass),
                          isRequired: true,
                          widthBG: true,
                        ),
                        SizedBox(height: 8.h),
                        if (_passCtrl.text.isNotEmpty) ...[
                          PasswordStrengthBar(password: _passCtrl.text),
                          SizedBox(height: 4.h),
                          StrengthCriteria(password: _passCtrl.text),
                        ],
                        SizedBox(height: 14.h),
                        CustomTextfield(
                          'Confirm Password',
                          '••••••••',
                          TextInputType.visiblePassword,
                          _confCtrl,
                          (value) {
                            if (value == null || value.isEmpty) {
                              return "The confirmation password is required";
                            } else if (value != _passCtrl.text) {
                              return "The passwords do not match";
                            }
                            return null;
                          },
                          AutovalidateMode.onUserInteraction,
                          prefixIcon: SolarIconsOutline.lockPassword,
                          obscure: _obscureConf,
                          setObscure: () =>
                              setState(() => _obscureConf = !_obscureConf),
                          isRequired: true,
                          widthBG: true,
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            CustomCheckbox(
                              value: _termsAccepted,
                              onChanged: (v) => setState(() {
                                _termsAccepted = v ?? false;
                                if (_termsAccepted) _termsError = null;
                              }),
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
                        if (_termsError != null) ...[
                          SizedBox(height: 6.h),
                          Text(
                            _termsError!,
                            style: TextStyle(color: danger, fontSize: 11.sp),
                          ),
                        ],
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
      ),
    );
  }
}
