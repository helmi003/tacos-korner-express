import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/models/address_model.dart';
import 'package:takos_corner_express/services/user_provider.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/utils/enums.dart';
import 'package:takos_corner_express/widgets/auth/address_list_editor.dart';
import 'package:takos_corner_express/widgets/auth/allergy_selector.dart';
import 'package:takos_corner_express/widgets/auth/gender_selector.dart';
import 'package:takos_corner_express/widgets/global/button_widget.dart';
import 'package:takos_corner_express/widgets/global/custom_back_appbar.dart';
import 'package:takos_corner_express/widgets/global/custom_snackbar.dart';
import 'package:takos_corner_express/widgets/global/custom_textfield.dart';
import 'package:takos_corner_express/widgets/global/custom_phone_number_field.dart';
import 'package:takos_corner_express/widgets/global/custome_date_time_input.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/EditProfileScreen';
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _allergyOtherCtrl;

  DateTime? _dateOfBirth;
  Gender _gender = Gender.preferNotToSay;
  Set<String> _allergies = {};
  List<AddressModel> _addresses = [];
  final _addressEditorKey = GlobalKey<AddressListEditorState>();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>();
    final nameParts = (user.name ?? '').trim().split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    _firstNameCtrl = TextEditingController(text: firstName);
    _lastNameCtrl = TextEditingController(text: lastName);
    _phoneCtrl = TextEditingController();
    _allergyOtherCtrl = TextEditingController();

    _dateOfBirth = user.dateOfBirth;
    _gender = user.gender;
    _allergies = user.allergies.toSet();
    _addresses = user.addresses.toList();
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    _allergyOtherCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(now.year - 25),
      firstDate: DateTime(now.year - 100),
      lastDate: now,
    );
    if (picked != null) setState(() => _dateOfBirth = picked);
  }

  Future<void> _save() async {
    final canProceed =
        await _addressEditorKey.currentState?.confirmDiscardIfNeeded() ??
        true;
    if (!canProceed || !mounted) return;

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    final allergies = {..._allergies};

    final firstName = _firstNameCtrl.text.trim();
    final lastName = _lastNameCtrl.text.trim();
    final name = [firstName, lastName].where((p) => p.isNotEmpty).join(' ');

    context.read<UserProvider>().updateProfile(
      name: name.isNotEmpty ? name : null,
      phone: _phoneCtrl.text.trim().isNotEmpty ? _phoneCtrl.text.trim() : null,
      dateOfBirth: _dateOfBirth,
      gender: _gender,
      allergies: allergies.toList(),
      addresses: _addresses,
    );

    setState(() => _loading = false);
    CustomSnackbar.show(
      context,
      message: 'Profile updated',
      type: SnackbarType.success,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: customBackAppBar(context, 'Edit Profile', ''),
      body: SingleChildScrollView(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextfield(
                'First Name',
                'John',
                TextInputType.name,
                _firstNameCtrl,
                null,
                AutovalidateMode.disabled,
                prefixIcon: SolarIconsOutline.user,
                widthBG: true,
              ),
              SizedBox(height: 14.h),
              CustomTextfield(
                'Last Name',
                'Doe',
                TextInputType.name,
                _lastNameCtrl,
                null,
                AutovalidateMode.disabled,
                prefixIcon: SolarIconsOutline.user,
                widthBG: true,
              ),
              SizedBox(height: 14.h),
              CustomPhoneNumberField(
                'Phone Number',
                _phoneCtrl,
                initialPhoneNumber: context.read<UserProvider>().phone,
                withBG: true,
              ),
              SizedBox(height: 14.h),
              CustomeDateTimeInput(
                'Date of Birth',
                _pickDateOfBirth,
                'Select your birth date',
                _dateOfBirth == null
                    ? ''
                    : '${_dateOfBirth!.day.toString().padLeft(2, '0')}/${_dateOfBirth!.month.toString().padLeft(2, '0')}/${_dateOfBirth!.year}',
                icon: SolarIconsOutline.calendar,
                widthBG: true,
                onClear: () => setState(() => _dateOfBirth = null),
              ),
              SizedBox(height: 16.h),
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
              SizedBox(height: 16.h),
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
              SizedBox(height: 20.h),
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
                'Save Changes',
                _save,
                isLoading: _loading,
                icon: SolarIconsBold.checkCircle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
