import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_corner_express/utils/enums.dart';
import 'package:takos_corner_express/widgets/others/selectable_chip.dart';

class GenderSelector extends StatelessWidget {
  final Gender value;
  final ValueChanged<Gender> onChanged;
  const GenderSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: Gender.values.map((g) {
        return SelectableChip(
          label: g.label,
          leadingIcon: g.icon,
          active: value == g,
          onTap: () => onChanged(g),
        );
      }).toList(),
    );
  }
}
