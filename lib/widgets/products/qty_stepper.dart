import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/utils/colors.dart';

/// A reusable quantity stepper (+/−) widget used across the app:
/// cart item tiles, the product customizer bottom bar, and the product
/// details screen.
///
/// **[useIconButton]** — set `true` for bottom-bar contexts where a larger
/// tap area is needed (renders `IconButton` with min-size constraints).
/// Defaults to `false` which uses a compact `GestureDetector`.
///
/// When [useIconButton] is `true` the minus button is *disabled* (not just
/// visually muted) at [qty] == 1, so the callback is never invoked.
/// When `false` the callback is always invoked; the caller decides whether
/// to act on it (e.g. `decrementItem` at qty 1 removes the cart entry).
class QtyStepper extends StatelessWidget {
  const QtyStepper({
    super.key,
    required this.qty,
    required this.onIncrement,
    required this.onDecrement,
    this.iconSize = 24,
    this.fontSize = 15,
    this.useIconButton = false,
  });

  final int qty;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  /// Icon size in logical sp units. Defaults to 24 (compact inline use).
  final double iconSize;

  /// Font size for the quantity counter. Defaults to 15.
  final double fontSize;

  /// Use `IconButton` with a larger tap area. Set `true` for bottom bars.
  final bool useIconButton;

  @override
  Widget build(BuildContext context) {
    final canDecrement = qty > 1;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: context.cardGrayColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Minus ────────────────────────────────────────────────────────
          if (useIconButton)
            IconButton(
              onPressed: canDecrement ? onDecrement : null,
              icon: Icon(
                SolarIconsBold.minusCircle,
                size: iconSize.sp,
                color: canDecrement ? primaryColor : textMuted,
              ),
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(minWidth: 32.w, minHeight: 32.h),
            )
          else
            GestureDetector(
              onTap: onDecrement,
              child: Icon(
                SolarIconsBold.minusCircle,
                color: canDecrement ? primaryColor : textMuted,
                size: iconSize.sp,
              ),
            ),

          // ── Count ────────────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              '$qty',
              style: TextStyle(
                fontSize: fontSize.sp,
                fontWeight: FontWeight.w700,
                color: context.textColor,
              ),
            ),
          ),

          // ── Plus ─────────────────────────────────────────────────────────
          if (useIconButton)
            IconButton(
              onPressed: onIncrement,
              icon: Icon(
                SolarIconsBold.addCircle,
                size: iconSize.sp,
                color: primaryColor,
              ),
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(minWidth: 32.w, minHeight: 32.h),
            )
          else
            GestureDetector(
              onTap: onIncrement,
              child: Icon(
                SolarIconsBold.addCircle,
                color: primaryColor,
                size: iconSize.sp,
              ),
            ),
        ],
      ),
    );
  }
}
