import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_corner_express/utils/colors.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final Function(bool?)? onChanged;
  const CustomCheckbox({super.key, required this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20.w,
      height: 20.w,
      child: Checkbox(
        value: value,
        onChanged: onChanged,
        activeColor: primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
        side: BorderSide(color: context.borderColor, width: 1.5),
      ),
    );
  }
}
