import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/models/address_model.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/auth/address_form_fields.dart';
import 'package:takos_corner_express/widgets/global/button_widget.dart';
import 'package:takos_corner_express/widgets/global/custom_confirmation_dialog.dart';

class AddressListEditor extends StatefulWidget {
  final List<AddressModel> initial;
  final ValueChanged<List<AddressModel>> onChanged;

  const AddressListEditor({
    super.key,
    this.initial = const [],
    required this.onChanged,
  });

  @override
  State<AddressListEditor> createState() => AddressListEditorState();
}

class AddressListEditorState extends State<AddressListEditor> {
  late List<AddressModel> _addresses = List.of(widget.initial);
  bool _adding = false;
  AddressModel? _draft;
  var _formKey = GlobalKey<FormState>();

  bool get _draftHasContent {
    final d = _draft;
    if (d == null) return false;
    return [
      d.label,
      d.street,
      d.city,
      d.state,
      d.country,
    ].any((v) => v.trim().isNotEmpty);
  }

  void _startAdding() {
    setState(() {
      _adding = true;
      _draft = null;
      _formKey = GlobalKey<FormState>();
    });
  }

  void _cancelAdding() {
    setState(() {
      _adding = false;
      _draft = null;
    });
  }

  void _confirmAdd() {
    if (_formKey.currentState?.validate() != true) return;
    final d = _draft;
    if (d == null) return;
    setState(() {
      _addresses = [..._addresses, d.copyWith(isDefault: _addresses.isEmpty)];
      _adding = false;
      _draft = null;
    });
    widget.onChanged(_addresses);
  }

  void _removeAt(int index) {
    setState(() {
      _addresses = [..._addresses]..removeAt(index);
      if (_addresses.isNotEmpty && !_addresses.any((a) => a.isDefault)) {
        _addresses[0] = _addresses[0].copyWith(isDefault: true);
      }
    });
    widget.onChanged(_addresses);
  }

  /// Returns true once it's safe to navigate away (no draft, or the user
  /// chose to discard it). Returns false if the user wants to keep editing.
  Future<bool> confirmDiscardIfNeeded() async {
    if (!_adding || !_draftHasContent) return true;
    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => ConfirmationDialog(
        'You have an address you haven\'t added yet. Keep editing it or discard it?',
        'Keep Editing',
        'Discard',
        danger,
        () => Navigator.of(dialogContext).pop(true),
      ),
    );
    if (discard != true) return false;
    _cancelAdding();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._addresses.asMap().entries.map(
          (e) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: _AddressCard(
              address: e.value,
              onRemove: () => _removeAt(e.key),
            ),
          ),
        ),
        if (_adding) ...[
          AddressFormFields(
            formKey: _formKey,
            allowCurrentLocation: _addresses.isEmpty,
            onChanged: (a) => _draft = a,
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: ButtonWidget(
                  'Cancel',
                  _cancelAdding,
                  isTransparent: true,
                  color: context.textBodyColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                flex: 2,
                child: ButtonWidget(
                  'Add Address',
                  _confirmAdd,
                  icon: SolarIconsBold.addCircle,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ] else ...[
          GestureDetector(
            onTap: _startAdding,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: primaryColor.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    SolarIconsOutline.addCircle,
                    size: 16.sp,
                    color: primaryColor,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    _addresses.isEmpty ? 'Add Address' : 'Add Another Address',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _AddressCard extends StatelessWidget {
  final AddressModel address;
  final VoidCallback onRemove;

  const _AddressCard({required this.address, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: context.border,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(SolarIconsBold.mapPoint, size: 18.sp, color: primaryColor),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      address.label,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: context.textColor,
                      ),
                    ),
                    if (address.isDefault) ...[
                      SizedBox(width: 6.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          'DEFAULT',
                          style: TextStyle(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w700,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  address.line,
                  style: TextStyle(fontSize: 12.sp, color: textMuted),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              SolarIconsOutline.trashBinTrash,
              size: 16.sp,
              color: danger,
            ),
          ),
        ],
      ),
    );
  }
}
