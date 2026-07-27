import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/helpers/password_helper.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/button_widget.dart';
import 'package:takos_corner_express/widgets/global/custom_back_appbar.dart';
import 'package:takos_corner_express/widgets/global/custom_snackbar.dart';
import 'package:takos_corner_express/widgets/global/custom_textfield.dart';
import 'package:takos_corner_express/widgets/others/password_strength_bar.dart';
import 'package:takos_corner_express/widgets/others/password_strength_criteria.dart'
    show StrengthCriteria;

class ChangePasswordScreen extends StatefulWidget {
  static const routeName = '/ChangePassword';
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _newCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: customBackAppBar(context, 'Change Password', ''),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(30.w),
                decoration: BoxDecoration(
                  color: context.accentAmber.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(
                  SolarIconsBold.lockPassword_,
                  size: 60.sp,
                  color: context.accentAmber,
                ),
              ),
              SizedBox(height: 20.h),
              CustomTextfield(
                'Current Password',
                '••••••••',
                TextInputType.visiblePassword,
                _currentCtrl,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'The current password is required';
                  }
                  return null;
                },
                AutovalidateMode.onUserInteraction,
                prefixIcon: SolarIconsOutline.lockPassword,
                obscure: _obscureCurrent,
                setObscure: () =>
                    setState(() => _obscureCurrent = !_obscureCurrent),
                widthBG: true,
              ),
              SizedBox(height: 14.h),
              CustomTextfield(
                'New Password',
                '••••••••',
                TextInputType.visiblePassword,
                _newCtrl,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'The new password is required';
                  } else if (!hasMinLength(value)) {
                    return 'The password must be at least 8 characters';
                  } else if (!hasLetterAndNumber(value)) {
                    return 'The password must contain both letters and numbers';
                  } else if (!hasUppercase(value)) {
                    return 'The password must contain at least one uppercase letter';
                  }
                  return null;
                },
                AutovalidateMode.onUserInteraction,
                prefixIcon: SolarIconsOutline.lockPassword,
                obscure: _obscureNew,
                setObscure: () => setState(() => _obscureNew = !_obscureNew),
                widthBG: true,
              ),
              if (_newCtrl.text.isNotEmpty) ...[
                SizedBox(height: 8.h),
                PasswordStrengthBar(password: _newCtrl.text),
                SizedBox(height: 4.h),
                StrengthCriteria(password: _newCtrl.text),
              ],
              SizedBox(height: 14.h),
              CustomTextfield(
                'Confirm New Password',
                '••••••••',
                TextInputType.visiblePassword,
                _confirmCtrl,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'The confirmation password is required';
                  } else if (value != _newCtrl.text) {
                    return 'The passwords do not match';
                  }
                  return null;
                },
                AutovalidateMode.onUserInteraction,
                prefixIcon: SolarIconsOutline.lockPassword,
                obscure: _obscureConfirm,
                setObscure: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
                widthBG: true,
              ),
              SizedBox(height: 20.h),
              ButtonWidget(
                'Update Password',
                _submit,
                isLoading: _loading,
                icon: SolarIconsBold.checkCircle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _loading = false);
    CustomSnackbar.show(
      context,
      message: 'Password updated successfully!',
      type: SnackbarType.success,
    );
    Navigator.of(context).pop();
  }
}
