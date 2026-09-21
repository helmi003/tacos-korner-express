import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/screens/authentication/registration_details_flow_screen.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/auth/auth_header.dart';
import 'package:takos_corner_express/widgets/auth/otp_box.dart';
import 'package:takos_corner_express/widgets/global/button_widget.dart';

class VerifyAccountScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  const VerifyAccountScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  @override
  State<VerifyAccountScreen> createState() => _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends State<VerifyAccountScreen> {
  final _otpCtrls = List.generate(6, (_) => TextEditingController());
  final _otpNodes = List.generate(6, (_) => FocusNode());
  String? _otpError;
  bool _isVerifying = false;
  bool _isResending = false;

  @override
  void dispose() {
    for (final c in _otpCtrls) {
      c.dispose();
    }
    for (final n in _otpNodes) {
      n.dispose();
    }
    super.dispose();
  }

  Future<void> _resend() async {
    setState(() => _isResending = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isResending = false);
  }

  Future<void> _verify() async {
    final code = _otpCtrls.map((c) => c.text).join();
    if (code.length < 6) {
      setState(() => _otpError = 'Please enter all 6 digits');
      return;
    }
    setState(() {
      _otpError = null;
      _isVerifying = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => RegistrationDetailsFlowScreen(
          firstName: widget.firstName,
          lastName: widget.lastName,
          email: widget.email,
          phone: widget.phone,
        ),
      ),
    );
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
            AuthHeader(
              greenGradient,
              'Verify Your Account',
              'Enter the 6-digit code we sent to ${widget.email}',
              showBackButton: true,
              onTap: () => Navigator.pop(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Container(
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
                              if (i > 0) _otpNodes[i - 1].requestFocus();
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
                      _isResending
                          ? LoadingAnimationWidget.staggeredDotsWave(
                              color: primaryColor,
                              size: 20.h,
                            )
                          : TextButton(
                              onPressed: _resend,
                              child: Text(
                                "Didn't get a code? Resend",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ),
                      SizedBox(height: 8.h),
                      ButtonWidget(
                        'Verify & Finish',
                        _verify,
                        isLoading: _isVerifying,
                        bgColor: context.accentGreen,
                        icon: SolarIconsBold.checkCircle,
                        iconRight: true,
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
