import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/main.dart';
import 'package:takos_corner_express/utils/colors.dart';

enum SnackbarType { success, error, warning, info }

class CustomSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    required SnackbarType type,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = navigatorKey.currentState?.overlay;
    if (overlay == null) return;

    final snackbarData = _getSnackbarData(type);
    final border = context.border;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _SnackbarOverlay(
        message: message,
        icon: snackbarData['icon'],
        color: snackbarData['color'] as Color,
        border: border,
        duration: duration,
        onDismiss: () {
          if (entry.mounted) entry.remove();
        },
      ),
    );

    overlay.insert(entry);
  }

  static Map<String, dynamic> _getSnackbarData(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return {'color': success, 'icon': SolarIconsBold.checkCircle};
      case SnackbarType.error:
        return {'color': danger, 'icon': SolarIconsBold.closeCircle};
      case SnackbarType.warning:
        return {
          'color': warning,
          'icon': SolarIconsBold.dangerTriangle,
        };
      case SnackbarType.info:
        return {'color': info, 'icon': SolarIconsBold.infoCircle};
    }
  }
}

class _SnackbarOverlay extends StatefulWidget {
  final String message;
  final IconData icon;
  final Color color;
  final BoxBorder border;
  final Duration duration;
  final VoidCallback onDismiss;

  const _SnackbarOverlay({
    required this.message,
    required this.icon,
    required this.color,
    required this.border,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_SnackbarOverlay> createState() => _SnackbarOverlayState();
}

class _SnackbarOverlayState extends State<_SnackbarOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);

    _ctrl.forward();

    Future.delayed(widget.duration, _dismiss);
  }

  Future<void> _dismiss() async {
    if (!mounted) return;
    await _ctrl.reverse();
    widget.onDismiss();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 16.h),
          child: SlideTransition(
            position: _slide,
            child: FadeTransition(
              opacity: _fade,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Icon(widget.icon, color: textLight, size: 20.sp),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          widget.message,
                          style: TextStyle(
                            color: textLight,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
