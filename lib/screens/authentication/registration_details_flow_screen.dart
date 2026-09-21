import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/models/address_model.dart';
import 'package:takos_corner_express/screens/tabs/tab_screen.dart';
import 'package:takos_corner_express/services/user_provider.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/utils/enums.dart';
import 'package:takos_corner_express/widgets/auth/address_list_editor.dart';
import 'package:takos_corner_express/widgets/auth/allergy_selector.dart';
import 'package:takos_corner_express/widgets/auth/auth_header.dart';
import 'package:takos_corner_express/widgets/auth/gender_selector.dart';
import 'package:takos_corner_express/widgets/auth/step_progress_bar.dart';
import 'package:takos_corner_express/widgets/global/button_widget.dart';
import 'package:takos_corner_express/widgets/global/custome_date_time_input.dart';

enum _DetailsStep { personal, address }

class RegistrationDetailsFlowScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  const RegistrationDetailsFlowScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  @override
  State<RegistrationDetailsFlowScreen> createState() =>
      _RegistrationDetailsFlowScreenState();
}

class _RegistrationDetailsFlowScreenState
    extends State<RegistrationDetailsFlowScreen> {
  _DetailsStep _step = _DetailsStep.personal;

  DateTime? _dateOfBirth;
  Gender _gender = Gender.preferNotToSay;
  Set<String> _allergies = {};
  final _allergyOtherCtrl = TextEditingController();

  List<AddressModel> _addresses = [];
  final _addressEditorKey = GlobalKey<AddressListEditorState>();

  @override
  void dispose() {
    _allergyOtherCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 25),
      firstDate: DateTime(now.year - 100),
      lastDate: now,
    );
    if (picked != null) setState(() => _dateOfBirth = picked);
  }

  void _goToAddressStep() => setState(() => _step = _DetailsStep.address);

  Future<void> _finishRegistration() async {
    final canProceed =
        await _addressEditorKey.currentState?.confirmDiscardIfNeeded() ?? true;
    if (!canProceed || !mounted) return;

    final allergies = {..._allergies};

    context.read<UserProvider>().login(
      name: '${widget.firstName} ${widget.lastName}'.trim(),
      email: widget.email,
      phone: widget.phone,
      dateOfBirth: _dateOfBirth,
      gender: _gender,
      allergies: allergies.toList(),
      addresses: _addresses,
    );

    Navigator.pushNamedAndRemoveUntil(
      context,
      TabScreen.routeName,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPersonal = _step == _DetailsStep.personal;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthHeader(
              secondaryGradient,
              isPersonal ? 'Personal Details' : 'Delivery Address',
              isPersonal
                  ? "Tell us a bit about yourself (all optional)"
                  : 'Where should we deliver your orders?',
              showBackButton: true,
              onTap: () {
                if (isPersonal) {
                  Navigator.pop(context);
                } else {
                  setState(() => _step = _DetailsStep.personal);
                }
              },
              footer: StepProgressBar(
                currentStep: _step.index,
                totalSteps: _DetailsStep.values.length,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: isPersonal
                      ? _buildPersonalStep()
                      : _buildAddressStep(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalStep() {
    return Container(
      key: const ValueKey('personal'),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: context.border,
        boxShadow: context.shadows,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomeDateTimeInput(
            'Date of Birth',
            _pickDateOfBirth,
            'Select your birth date',
            _dateOfBirth == null
                ? ''
                : '${_dateOfBirth!.day.toString().padLeft(2, '0')}/${_dateOfBirth!.month.toString().padLeft(2, '0')}/${_dateOfBirth!.year}',
            icon: SolarIconsOutline.calendar,
            isRequired: false,
            widthBG: true,
            onClear: () => setState(() => _dateOfBirth = null),
          ),
          SizedBox(height: 18.h),
          Text(
            'GENDER',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: context.textColor,
            ),
          ),
          SizedBox(height: 8.h),
          GenderSelector(
            value: _gender,
            onChanged: (g) => setState(() => _gender = g),
          ),
          SizedBox(height: 18.h),
          Text(
            'ALLERGIES',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: context.textColor,
            ),
          ),
          SizedBox(height: 8.h),
          AllergySelector(
            selected: _allergies,
            customController: _allergyOtherCtrl,
            onChanged: (s) => setState(() => _allergies = s),
          ),
          SizedBox(height: 24.h),
          ButtonWidget(
            'Next',
            _goToAddressStep,
            bgColor: context.tertiary,
            icon: SolarIconsBold.arrowRight,
            iconRight: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressStep() {
    return Container(
      key: const ValueKey('address'),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: context.border,
        boxShadow: context.shadows,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DELIVERY ADDRESSES',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: context.textColor,
            ),
          ),
          SizedBox(height: 8.h),
          AddressListEditor(
            key: _addressEditorKey,
            initial: _addresses,
            onChanged: (list) => _addresses = list,
          ),
          SizedBox(height: 24.h),
          ButtonWidget(
            'Finish',
            _finishRegistration,
            bgColor: context.tertiary,
            icon: SolarIconsBold.checkCircle,
            iconRight: true,
          ),
        ],
      ),
    );
  }
}
