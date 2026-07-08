import 'package:flutter/material.dart';
import 'package:takos_corner_express/utils/colors.dart';

class CustomSwitchButton extends StatelessWidget {
  final bool? value;
  final ValueChanged<bool>? onChanged;
  const CustomSwitchButton({super.key, this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value!,
      onChanged: onChanged,
      thumbColor: WidgetStateProperty.all<Color>(textLight),
      trackColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return context.primary;
        }
        return uiBorderLight;
      }),
      trackOutlineColor: WidgetStateProperty.all<Color>(Colors.transparent),
      overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
      splashRadius: 0,
    );
  }
}
