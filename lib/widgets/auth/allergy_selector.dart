import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/data/home_data.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/others/selectable_chip.dart';

class AllergySelector extends StatefulWidget {
  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;
  final TextEditingController customController;

  const AllergySelector({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.customController,
  });

  @override
  State<AllergySelector> createState() => _AllergySelectorState();
}

class _AllergySelectorState extends State<AllergySelector> {
  final _focusNode = FocusNode();
  bool _adding = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _toggle(String allergen) {
    final next = {...widget.selected};
    if (!next.remove(allergen)) next.add(allergen);
    widget.onChanged(next);
  }

  void _remove(String allergen) {
    widget.onChanged({...widget.selected}..remove(allergen));
  }

  void _startAdding() {
    setState(() => _adding = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _submitCustom() {
    final value = widget.customController.text.trim();
    if (value.isNotEmpty) {
      widget.onChanged({...widget.selected, value});
    }
    widget.customController.clear();
    setState(() => _adding = false);
  }

  @override
  Widget build(BuildContext context) {
    final customItems = widget.selected
        .where((a) => !allergensList.contains(a))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            ...allergensList.map(
              (allergen) => SelectableChip(
                label: allergen,
                active: widget.selected.contains(allergen),
                onTap: () => _toggle(allergen),
              ),
            ),
            ...customItems.map(
              (allergen) => SelectableChip(
                label: allergen,
                active: true,
                leadingIcon: SolarIconsOutline.closeCircle,
                onTap: () => _remove(allergen),
              ),
            ),
            SelectableChip(
              label: 'Add',
              active: _adding,
              leadingIcon: SolarIconsOutline.addCircle,
              onTap: _adding
                  ? () => setState(() => _adding = false)
                  : _startAdding,
            ),
          ],
        ),
        if (_adding) ...[
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.customController,
                  focusNode: _focusNode,
                  textInputAction: TextInputAction.done,
                  style: TextStyle(fontSize: 14.sp),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: context.cardColor,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    hintText: 'e.g. Sesame',
                    hintStyle: TextStyle(color: textMuted, fontSize: 12.sp),
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: context.borderColor,
                        width: 0.5.w,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: context.borderColor,
                        width: 0.5.w,
                      ),
                    ),
                  ),
                  onSubmitted: (_) => _submitCustom(),
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: _submitCustom,
                child: Container(
                  padding: EdgeInsets.all(11.w),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(Icons.check, size: 16.sp, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
