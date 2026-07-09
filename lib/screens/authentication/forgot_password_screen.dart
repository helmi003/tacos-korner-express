import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/helpers/password_helper.dart';
import 'package:takos_corner_express/models/http_exceptions.dart';
import 'package:takos_corner_express/screens/authentication/login_screen.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/auth/auth_header.dart';
import 'package:takos_corner_express/widgets/auth/otp_box.dart';
import 'package:takos_corner_express/widgets/global/button_widget.dart';
import 'package:takos_corner_express/widgets/global/custom_snackbar.dart';
import 'package:takos_corner_express/widgets/global/custom_textfield.dart';
import 'package:takos_corner_express/widgets/others/password_strength_bar.dart';
import 'package:takos_corner_express/widgets/others/password_strength_criteria.dart'
    show StrengthCriteria;

enum _ForgotStep { email, sent, otp, newPassword }

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '/ForgotPassword';
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  _ForgotStep _step = _ForgotStep.email;
  final _passFormKey = GlobalKey<FormState>();
  final _emailFormKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confCtrl = TextEditingController();
  final _otpCtrls = List.generate(6, (_) => TextEditingController());
  final _otpNodes = List.generate(6, (_) => FocusNode());
  bool _obscurePass = true;
  bool _obscureConf = true;
  bool isLoading = false;
  bool isVerifying = false;
  String? _otpError;

  @override
  void initState() {
    super.initState();
    _passCtrl.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confCtrl.dispose();
    for (final c in _otpCtrls) {
      c.dispose();
    }
    for (final n in _otpNodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _onPasswordChanged() => setState(() {});

  Future<void> _sendEmail() async {
    try {
      if (!_emailFormKey.currentState!.validate()) return;
      setState(() => isLoading = true);
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _step = _ForgotStep.sent;
        });
        CustomSnackbar.show(
          context,
          message: "Email sent successfully! Please check your inbox.",
          type: SnackbarType.success,
        );
      }
    } on CustomHttpException catch (error) {
      if (mounted) {
        CustomSnackbar.show(
          context,
          message: error.message,
          type: SnackbarType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> reSendEmail() async {
    try {
      setState(() => isLoading = true);
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        CustomSnackbar.show(
          context,
          message: "Email resent successfully! Please check your inbox.",
          type: SnackbarType.success,
        );
      }
    } on CustomHttpException catch (error) {
      if (mounted) {
        CustomSnackbar.show(
          context,
          message: error.message,
          type: SnackbarType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _verifyOtp() async {
    final code = _otpCtrls.map((c) => c.text).join();
    if (code.length < 6) {
      setState(() => _otpError = 'Please enter all 6 digits');
      return;
    }
    setState(() {
      _otpError = null;
      isVerifying = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      isVerifying = false;
      _step = _ForgotStep.newPassword;
    });
  }

  Future<void> _resetPassword() async {
    if (!_passFormKey.currentState!.validate()) return;
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => isLoading = false);
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildStep(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final gradient = switch (_step) {
      _ForgotStep.email => amberGradient,
      _ForgotStep.sent => amberGradient,
      _ForgotStep.otp => greenGradient,
      _ForgotStep.newPassword => greenGradient,
    };

    final title = switch (_step) {
      _ForgotStep.email => 'Forgot Password? 🔑',
      _ForgotStep.sent => 'Check Your Inbox 📧',
      _ForgotStep.otp => 'Verify Code ✉️',
      _ForgotStep.newPassword => 'New Password 🔒',
    };

    final subtitle = switch (_step) {
      _ForgotStep.email => "Enter your email and we'll send a reset link",
      _ForgotStep.sent => 'We sent a code to your email address',
      _ForgotStep.otp => 'Enter the 6-digit code we sent you',
      _ForgotStep.newPassword => 'Create a strong new password',
    };

    return AuthHeader(
      gradient,
      title,
      subtitle,
      onTap: () {
        if (_step == _ForgotStep.email) {
          Navigator.pop(context);
        } else {
          setState(() => _step = _ForgotStep.values[_step.index - 1]);
        }
      },
      showBackButton: true,
    );
  }

  Widget _buildStep() {
    return switch (_step) {
      _ForgotStep.email => _buildEmailStep(),
      _ForgotStep.sent => _buildSentStep(),
      _ForgotStep.otp => _buildOtpStep(),
      _ForgotStep.newPassword => _buildNewPasswordStep(),
    };
  }

  Widget _buildEmailStep() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: context.border,
        boxShadow: context.shadows,
      ),
      child: Form(
        key: _emailFormKey,
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Icon(
              SolarIconsOutline.lockPassword,
              size: 60.sp,
              color: accentAmber,
            ),
            SizedBox(height: 20.h),
            CustomTextfield(
              'Email Address',
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
              widthBG: true,
            ),
            SizedBox(height: 20.h),
            ButtonWidget(
              'Send Reset Code',
              _sendEmail,
              isLoading: isLoading,
              bgColor: accentAmber,
              icon: SolarIconsBold.plain2,
              iconRight: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSentStep() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: context.border,
        boxShadow: context.shadows,
      ),
      child: Column(
        children: [
          SizedBox(height: 10.h),
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: accentAmberDark.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(SolarIconsBold.letter, size: 38.sp, color: accentAmber),
          ),
          SizedBox(height: 16.h),
          Text(
            'Email sent!',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: context.textColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'We sent a 6-digit code to\n${_emailCtrl.text}',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.sp, color: textMuted),
          ),
          SizedBox(height: 24.h),
          ButtonWidget(
            'Enter OTP Code',
            () => setState(() => _step = _ForgotStep.otp),
            bgColor: accentAmber,
            icon: SolarIconsBold.key,
            iconRight: true,
          ),
          SizedBox(height: 12.h),
          isLoading
              ? LoadingAnimationWidget.staggeredDotsWave(
                  color: primaryColor,
                  size: 20.h,
                )
              : TextButton(
                  onPressed: reSendEmail,
                  child: Text(
                    "Didn't receive? Resend code",
                    style: TextStyle(color: primaryColor, fontSize: 13.sp),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildOtpStep() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: context.border,
        boxShadow: context.shadows,
      ),
      child: Form(
        key: _otpFormKey,
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (i) {
                return OtpBox(
                  controller: _otpCtrls[i],
                  focusNode: _otpNodes[i],
                  onChanged: (v) {
                    setState(() => _otpError = null);
                    if (v.isNotEmpty && i < 5) {
                      _otpNodes[i + 1].requestFocus();
                    } else if (v.isEmpty && i > 0) {
                      _otpNodes[i - 1].requestFocus();
                    }
                  },
                  onBackspace: () {
                    if (i > 0) {
                      _otpNodes[i - 1].requestFocus();
                    }
                  },
                );
              }),
            ),
            if (_otpError != null) ...[
              SizedBox(height: 10.h),
              Text(
                _otpError!,
                textAlign: TextAlign.center,
                style: TextStyle(color: danger, fontSize: 12.sp),
              ),
            ],
            SizedBox(height: 16.h),
            isLoading
                ? LoadingAnimationWidget.staggeredDotsWave(
                    color: primaryColor,
                    size: 20.h,
                  )
                : TextButton(
                    onPressed: reSendEmail,
                    child: Text(
                      "Didn't get a code? Resend",
                      style: TextStyle(color: primaryColor, fontSize: 13.sp),
                    ),
                  ),
            SizedBox(height: 8.h),
            ButtonWidget(
              'Verify Code',
              _verifyOtp,
              isLoading: isVerifying,
              bgColor: accentGreen,
              icon: SolarIconsBold.checkCircle,
              iconRight: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewPasswordStep() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: context.border,
        boxShadow: context.shadows,
      ),
      child: Form(
        key: _passFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            CustomTextfield(
              'New Password',
              'Min. 8 characters',
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
              setObscure: () => setState(() => _obscurePass = !_obscurePass),
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
              setObscure: () => setState(() => _obscureConf = !_obscureConf),
              widthBG: true,
            ),
            SizedBox(height: 20.h),
            ButtonWidget(
              'Reset Password',
              _resetPassword,
              isLoading: isLoading,
              bgColor: accentGreen,
              icon: SolarIconsBold.checkCircle,
              iconRight: true,
            ),
          ],
        ),
      ),
    );
  }
}
