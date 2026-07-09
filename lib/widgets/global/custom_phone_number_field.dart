import 'package:country_phone_validator/country_phone_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart'
    show PhoneNumber;
import 'package:takos_corner_express/utils/colors.dart';

String _flagEmoji(String isoCode) {
  if (isoCode.length != 2) return '🏳';
  const base = 0x1F1E6;
  final chars = isoCode
      .toUpperCase()
      .codeUnits
      .map((c) => base + (c - 0x41))
      .toList();
  return String.fromCharCodes(chars);
}

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
  late Country _country;

  @override
  void initState() {
    super.initState();
    _country =
        CountryUtils.getCountryByIsoCode(widget.initialCountry) ??
        countries.first;
    if (widget.initialPhoneNumber != null) {
      widget.controller.text = widget.initialPhoneNumber!;
    }
    widget.controller.addListener(_onNumberChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onNumberChanged);
    super.dispose();
  }

  void _onNumberChanged() {
    widget.onInputChanged?.call(
      PhoneNumber(
        isoCode: _country.isoCode,
        dialCode: _country.dialCode,
        phoneNumber: '${_country.dialCode}${widget.controller.text}',
      ),
    );
  }

  Future<void> _pickCountry() async {
    final selected = await showModalBottomSheet<Country>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CountryPickerSheet(selected: _country),
    );
    if (selected != null && mounted) {
      setState(() => _country = selected);
      _onNumberChanged();
    }
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      if (widget.isRequired == true) return 'Ce champ est obligatoire';
      return null;
    }
    final national = value.trim().replaceAll(RegExp(r'[\s\-]'), '');
    final len = national.length;
    if (_country.phoneMinLength == _country.phoneMaxLength) {
      if (len != _country.phoneMinLength) {
        return 'Doit contenir exactement ${_country.phoneMinLength} chiffres';
      }
    } else {
      if (len < _country.phoneMinLength || len > _country.phoneMaxLength) {
        return 'Doit contenir entre ${_country.phoneMinLength} et ${_country.phoneMaxLength} chiffres';
      }
    }
    if (_country.startingDigits.isNotEmpty &&
        !_country.startingDigits.any((d) => national.startsWith(d))) {
      return 'Doit commencer par ${_country.startingDigits.join(', ')}';
    }
    return null;
  }

  String _formatHint() {
    final lengthText = _country.phoneMinLength == _country.phoneMaxLength
        ? '${_country.phoneMinLength} chiffres'
        : '${_country.phoneMinLength}–${_country.phoneMaxLength} chiffres';
    return '$lengthText pour ${_country.isoCode}';
  }

  @override
  Widget build(BuildContext context) {
    final fillColor = widget.withBG == true
        ? context.cardColor
        : context.backgroundColor;

    return FormField<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: _phoneValidator,
      builder: (field) {
        final borderColor = field.hasError ? danger : context.borderColor;
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _pickCountry,
                  child: Container(
                    height: 46.h,
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    decoration: BoxDecoration(
                      color: fillColor,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: borderColor, width: 0.5.w),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _flagEmoji(_country.isoCode),
                          style: TextStyle(fontSize: 18.sp),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          _country.dialCode,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: context.textColor,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 18.sp,
                          color: textMuted,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: SizedBox(
                    height: 46.h,
                    child: TextFormField(
                      controller: widget.controller,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: context.textColor,
                      ),
                      onChanged: (_) => field.didChange(widget.controller.text),
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: fillColor,
                        hintText: '96 XXX XXX',
                        hintStyle: TextStyle(color: textMuted, fontSize: 12.sp),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: borderColor,
                            width: 0.5.w,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: borderColor,
                            width: 0.5.w,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: borderColor,
                            width: 0.5.w,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
                  _formatHint(),
                  style: TextStyle(fontSize: 10.sp, color: textMuted),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _CountryPickerSheet extends StatefulWidget {
  final Country selected;
  const _CountryPickerSheet({required this.selected});

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  final _searchCtrl = TextEditingController();
  List<Country> _filtered = countries;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? countries
          : countries
                .where(
                  (c) =>
                      c.name.toLowerCase().contains(q) ||
                      c.dialCode.contains(q),
                )
                .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.75,
      child: Container(
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          children: [
            SizedBox(height: 12.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: context.borderColor,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: TextField(
                controller: _searchCtrl,
                onChanged: _onSearch,
                style: TextStyle(color: context.textColor, fontSize: 14.sp),
                decoration: InputDecoration(
                  hintText: 'Search country or code',
                  hintStyle: TextStyle(color: textMuted, fontSize: 13.sp),
                  prefixIcon: Icon(Icons.search, color: textMuted, size: 20.sp),
                  filled: true,
                  fillColor: context.backgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: ListView.builder(
                itemCount: _filtered.length,
                itemBuilder: (_, i) {
                  final c = _filtered[i];
                  final isSelected = c.isoCode == widget.selected.isoCode;
                  return ListTile(
                    leading: Text(
                      _flagEmoji(c.isoCode),
                      style: TextStyle(fontSize: 22.sp),
                    ),
                    title: Text(
                      c.name,
                      style: TextStyle(
                        color: context.textColor,
                        fontSize: 14.sp,
                      ),
                    ),
                    trailing: Text(
                      c.dialCode,
                      style: TextStyle(color: textMuted, fontSize: 13.sp),
                    ),
                    selected: isSelected,
                    selectedTileColor: primaryColor.withValues(alpha: 0.08),
                    onTap: () => Navigator.pop(context, c),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
