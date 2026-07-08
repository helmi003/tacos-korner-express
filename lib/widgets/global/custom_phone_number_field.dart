import 'package:country_phone_validator/country_phone_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:takos_corner_express/utils/colors.dart';

class CustomPhoneNumberField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final void Function(PhoneNumber)? onInputChanged;
  final String initialCountry;
  final String? initialPhoneNumber;
  final bool? isRequired;
  final bool? withBG;

  const CustomPhoneNumberField(
    this.label,
    this.controller, {
    super.key,
    this.onInputChanged,
    this.initialCountry = "TN",
    this.initialPhoneNumber,
    this.isRequired,
    this.withBG,
  });

  @override
  State<CustomPhoneNumberField> createState() => _CustomPhoneNumberFieldState();
}

class _CustomPhoneNumberFieldState extends State<CustomPhoneNumberField> {
  PhoneNumber? _initialNumber;
  PhoneNumber? _currentPhone;

  @override
  void initState() {
    super.initState();
    _initialNumber = PhoneNumber(
      isoCode: widget.initialCountry,
      phoneNumber: widget.initialPhoneNumber,
    );
    _currentPhone = _initialNumber;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: phoneValidator,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.label.isNotEmpty) ...[
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: context.textColor,
                  ),
                  children: [
                    TextSpan(text: widget.label.toUpperCase()),
                    if (widget.isRequired == true)
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: danger),
                      )
                    else if (widget.isRequired == false)
                      TextSpan(
                        text: ' Optional',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: textMuted,
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 5.h),
            ],
            Container(
              constraints: BoxConstraints(maxHeight: 300.h),
              decoration: BoxDecoration(
                color: widget.withBG == true
                    ? context.cardColor
                    : context.backgroundColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: field.hasError ? danger : context.borderColor,
                  width: 0.5.w,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: InternationalPhoneNumberInput(
                  textFieldController: widget.controller,
                  initialValue: _initialNumber,
                  onInputChanged: (number) {
                    _currentPhone = number;
                    widget.onInputChanged?.call(number);
                    field.didChange(widget.controller.text);
                  },
                  formatInput: false,
                  selectorConfig: const SelectorConfig(
                    selectorType: PhoneInputSelectorType.DROPDOWN,
                  ),
                  inputDecoration: InputDecoration(
                    hintText: '+216 96 XXX XXX',
                    hintStyle: TextStyle(color: textMuted, fontSize: 12.sp),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                  textStyle: TextStyle(
                    fontSize: 14.sp,
                    color: context.textColor,
                  ),
                  validator: (_) => null,
                ),
              ),
            ),
            if (field.hasError)
              Padding(
                padding: EdgeInsets.only(top: 5.h, left: 2.w),
                child: Text(
                  field.errorText!,
                  style: TextStyle(color: danger, fontSize: 10.sp),
                ),
              )
            else
              Padding(
                padding: EdgeInsets.only(top: 4.h, left: 2.w),
                child: Text(
                  _getFormatHint(),
                  style: TextStyle(fontSize: 10.sp, color: textMuted),
                ),
              ),
          ],
        );
      },
    );
  }

  String _getFormatHint() {
    final isoCode = _currentPhone?.isoCode ?? widget.initialCountry;
    final country = CountryUtils.getCountryByIsoCode(isoCode);
    if (country == null) return '';
    final lengthText = country.phoneMinLength == country.phoneMaxLength
        ? '${country.phoneMinLength} chiffres'
        : '${country.phoneMinLength}–${country.phoneMaxLength} chiffres';
    return '$lengthText pour $isoCode';
  }

  String? phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      if (widget.isRequired == true) return 'Ce champ est obligatoire';
      return null;
    }
    final isoCode = _currentPhone?.isoCode ?? widget.initialCountry;
    final country = CountryUtils.getCountryByIsoCode(isoCode);
    if (country == null) return null;
    final national = value.trim().replaceAll(RegExp(r'[\s\-]'), '');
    final len = national.length;
    if (country.phoneMinLength == country.phoneMaxLength) {
      if (len != country.phoneMinLength) {
        return 'Doit contenir exactement ${country.phoneMinLength} chiffres';
      }
    } else {
      if (len < country.phoneMinLength || len > country.phoneMaxLength) {
        return 'Doit contenir entre ${country.phoneMinLength} et ${country.phoneMaxLength} chiffres';
      }
    }
    if (country.startingDigits.isNotEmpty &&
        !country.startingDigits.any((d) => national.startsWith(d))) {
      return 'Doit commencer par ${country.startingDigits.join(', ')}';
    }
    return null;
  }
}
