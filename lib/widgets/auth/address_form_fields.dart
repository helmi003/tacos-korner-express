import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/models/address_model.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/custom_textfield.dart';
import 'package:takos_corner_express/widgets/others/or_divider.dart';

class AddressFormFields extends StatefulWidget {
  final AddressModel? initial;
  final bool isDefault;
  final bool allowCurrentLocation;
  final GlobalKey<FormState>? formKey;
  final ValueChanged<AddressModel> onChanged;

  const AddressFormFields({
    super.key,
    this.initial,
    this.isDefault = true,
    this.allowCurrentLocation = true,
    this.formKey,
    required this.onChanged,
  });

  @override
  State<AddressFormFields> createState() => _AddressFormFieldsState();
}

class _AddressFormFieldsState extends State<AddressFormFields> {
  late final _labelCtrl = TextEditingController(text: widget.initial?.label);
  late final _streetCtrl = TextEditingController(text: widget.initial?.street);
  late final _cityCtrl = TextEditingController(text: widget.initial?.city);
  late final _stateCtrl = TextEditingController(text: widget.initial?.state);
  late final _countryCtrl = TextEditingController(
    text: widget.initial?.country,
  );
  double? _lat;
  double? _lng;
  bool _locating = false;

  @override
  void initState() {
    super.initState();
    _lat = widget.initial?.lat;
    _lng = widget.initial?.lng;
    for (final ctrl in [
      _labelCtrl,
      _streetCtrl,
      _cityCtrl,
      _stateCtrl,
      _countryCtrl,
    ]) {
      ctrl.addListener(_emitChange);
    }
  }

  @override
  void dispose() {
    _labelCtrl.dispose();
    _streetCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _countryCtrl.dispose();
    super.dispose();
  }

  void _emitChange() {
    widget.onChanged(
      AddressModel(
        label: _labelCtrl.text,
        street: _streetCtrl.text,
        city: _cityCtrl.text,
        state: _stateCtrl.text,
        country: _countryCtrl.text,
        lat: _lat,
        lng: _lng,
        isDefault: widget.isDefault,
      ),
    );
  }

  Future<void> _useCurrentLocation() async {
    if (_locating) return;
    setState(() => _locating = true);
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enable location services')),
          );
        }
        return;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied')),
          );
        }
        return;
      }
      final pos = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      setState(() {
        _lat = pos.latitude;
        _lng = pos.longitude;
        if (_labelCtrl.text.trim().isEmpty) {
          _labelCtrl.text = 'Current Location';
        }
      });
      _emitChange();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not get your location')),
        );
      }
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  String? _required(String field, String? value) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextfield(
            'Label',
            'e.g. Home, Work',
            TextInputType.text,
            _labelCtrl,
            (v) => _required('Label', v),
            AutovalidateMode.onUserInteraction,
            widthBG: true,
          ),
          SizedBox(height: 12.h),
          CustomTextfield(
            'Street',
            'Street, building, apartment…',
            TextInputType.streetAddress,
            _streetCtrl,
            (v) => _required('Street', v),
            AutovalidateMode.onUserInteraction,
            widthBG: true,
          ),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomTextfield(
                  'City',
                  'e.g. Tunis',
                  TextInputType.text,
                  _cityCtrl,
                  (v) => _required('City', v),
                  AutovalidateMode.onUserInteraction,
                  widthBG: true,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: CustomTextfield(
                  'State',
                  'e.g. Ariana',
                  TextInputType.text,
                  _stateCtrl,
                  null,
                  AutovalidateMode.disabled,
                  isRequired: false,
                  widthBG: true,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          CustomTextfield(
            'Country',
            'e.g. Tunisia',
            TextInputType.text,
            _countryCtrl,
            (v) => _required('Country', v),
            AutovalidateMode.onUserInteraction,
            widthBG: true,
          ),
          if (widget.allowCurrentLocation) ...[
            SizedBox(height: 14.h),
            OrDivider(
              onTap: _useCurrentLocation,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_locating) ...[
                    SizedBox(
                      width: 12.sp,
                      height: 12.sp,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: primaryColor,
                      ),
                    ),
                  ] else ...[
                    Icon(
                      SolarIconsOutline.gps,
                      size: 13.sp,
                      color: primaryColor,
                    ),
                  ],
                  SizedBox(width: 6.w),
                  Text(
                    _lat != null
                        ? 'LOCATION CAPTURED'
                        : 'USE MY CURRENT LOCATION',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
