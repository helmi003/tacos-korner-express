import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/screens/authentication/login_screen.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/button_widget.dart';
import 'package:takos_corner_express/widgets/global/custom_textfield.dart';
import 'package:takos_corner_express/widgets/others/password_strength_bar.dart';
import 'package:takos_corner_express/widgets/others/password_strength_criteria.dart' show StrengthCriteria;

enum _ForgotStep { email, sent, otp, newPassword }

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '/ForgotPassword';
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  _ForgotStep _step = _ForgotStep.email;
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  final _confCtrl  = TextEditingController();
  final _otpCtrls  = List.generate(4, (_) => TextEditingController());
  final _otpNodes  = List.generate(4, (_) => FocusNode());
  bool _obscurePass = true;
  bool _obscureConf = true;
  bool _loading     = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confCtrl.dispose();
    for (final c in _otpCtrls) { c.dispose(); }
    for (final n in _otpNodes) { n.dispose(); }
    super.dispose();
  }

  Future<void> _sendEmail() async {
    if (_emailCtrl.text.isEmpty || !_emailCtrl.text.contains('@')) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() { _loading = false; _step = _ForgotStep.sent; });
  }

  Future<void> _verifyOtp() async {
    final code = _otpCtrls.map((c) => c.text).join();
    if (code.length < 4) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() { _loading = false; _step = _ForgotStep.newPassword; });
  }

  Future<void> _resetPassword() async {
    if (_passCtrl.text != _confCtrl.text || _passCtrl.text.length < 8) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }

  Widget _buildHeader() {
    final gradient = switch (_step) {
      _ForgotStep.email       => amberGradient,
      _ForgotStep.sent        => amberGradient,
      _ForgotStep.otp         => greenGradient,
      _ForgotStep.newPassword => greenGradient,
    };

    final title = switch (_step) {
      _ForgotStep.email       => 'Forgot Password? 🔑',
      _ForgotStep.sent        => 'Check Your Inbox 📧',
      _ForgotStep.otp         => 'Verify Code ✉️',
      _ForgotStep.newPassword => 'New Password 🔒',
    };

    final subtitle = switch (_step) {
      _ForgotStep.email       => "Enter your email and we'll send a reset link",
      _ForgotStep.sent        => 'We sent a code to your email address',
      _ForgotStep.otp         => 'Enter the 4-digit code we sent you',
      _ForgotStep.newPassword => 'Create a strong new password',
    };

    return Container(
      padding: EdgeInsets.fromLTRB(
        28.w,
        MediaQuery.of(context).padding.top + 24.h,
        28.w,
        28.h,
      ),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: const BorderRadius.only(
          bottomLeft:  Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if (_step == _ForgotStep.email) {
                Navigator.pop(context);
              } else {
                setState(() => _step = _ForgotStep.values[_step.index - 1]);
              }
            },
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(SolarIconsOutline.altArrowLeft,
                  color: Colors.white, size: 18.sp),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 4.h),
          Text(subtitle,
              style: TextStyle(color: Colors.white70, fontSize: 13.sp)),
        ],
      ),
    );
  }

  Widget _buildStep() {
    return switch (_step) {
      _ForgotStep.email       => _buildEmailStep(),
      _ForgotStep.sent        => _buildSentStep(),
      _ForgotStep.otp         => _buildOtpStep(),
      _ForgotStep.newPassword => _buildNewPasswordStep(),
    };
  }

  Widget _buildEmailStep() {
    return Container(
      key: const ValueKey('email'),
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
          Icon(SolarIconsBold.lockPassword,
              size: 60.sp, color: accentAmber),
          SizedBox(height: 20.h),
          CustomTextfield(
            'Email Address',
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
          SizedBox(height: 20.h),
          ButtonWidget(
            'Send Reset Code',
            _sendEmail,
            isLoading: _loading,
            bgColor: accentAmber,
            icon: SolarIconsBold.plain2,
            iconRight: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSentStep() {
    return Container(
      key: const ValueKey('sent'),
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
                fontSize: 18.sp, fontWeight: FontWeight.w700,
                color: context.textColor),
          ),
          SizedBox(height: 8.h),
          Text(
            'We sent a 4-digit code to\n${_emailCtrl.text}',
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
          TextButton(
            onPressed: _sendEmail,
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
      key: const ValueKey('otp'),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (i) {
              return Container(
                width: 56.w,
                height: 64.w,
                margin: EdgeInsets.symmetric(horizontal: 6.w),
                decoration: BoxDecoration(
                  color: context.backgroundColor,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: _otpCtrls[i].text.isNotEmpty
                        ? accentGreen
                        : context.borderColor,
                    width: 1.5,
                  ),
                ),
                child: TextField(
                  controller: _otpCtrls[i],
                  focusNode: _otpNodes[i],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: context.textColor,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    counterText: '',
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (v) {
                    setState(() {});
                    if (v.isNotEmpty && i < 3) {
                      _otpNodes[i + 1].requestFocus();
                    } else if (v.isEmpty && i > 0) {
                      _otpNodes[i - 1].requestFocus();
                    }
                  },
                ),
              );
            }),
          ),
          SizedBox(height: 16.h),
          TextButton(
            onPressed: _sendEmail,
            child: Text(
              "Didn't get a code? Resend",
              style: TextStyle(color: primaryColor, fontSize: 13.sp),
            ),
          ),
          SizedBox(height: 8.h),
          ButtonWidget(
            'Verify Code',
            _verifyOtp,
            isLoading: _loading,
            bgColor: accentGreen,
            icon: SolarIconsBold.checkCircle,
            iconRight: true,
          ),
        ],
      ),
    );
  }

  Widget _buildNewPasswordStep() {
    return Container(
      key: const ValueKey('newpass'),
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
          CustomTextfield(
            'New Password',
            'Min. 8 characters',
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
            setObscure: () => setState(() => _obscurePass = !_obscurePass),
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
              if (v != _passCtrl.text) return 'Passwords do not match';
              return null;
            },
            AutovalidateMode.onUserInteraction,
            prefixIcon: SolarIconsOutline.lockPassword,
            obscure: _obscureConf,
            setObscure: () => setState(() => _obscureConf = !_obscureConf),
          ),
          SizedBox(height: 20.h),
          ButtonWidget(
            'Reset Password',
            _resetPassword,
            isLoading: _loading,
            bgColor: accentGreen,
            icon: SolarIconsBold.checkCircle,
            iconRight: true,
          ),
        ],
      ),
    );
  }
}
