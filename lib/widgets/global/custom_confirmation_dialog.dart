import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/button_widget.dart';

class ConfirmationDialog extends StatelessWidget {
  final String contentText;
  final String cancelText;
  final String confirmText;
  final Color color;
  final VoidCallback onPressed;
  final bool isLoading;

  const ConfirmationDialog(
    this.contentText,
    this.cancelText,
    this.confirmText,
    this.color,
    this.onPressed, {
    super.key,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.r)),
      ),
      content: Text(
        contentText,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ButtonWidget(
                cancelText,
                () => Navigator.of(context).pop(),
                isTransparent: true,
                color: context.textBodyColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: ButtonWidget(
                confirmText,
                onPressed,
                bgColor: color,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                isLoading: isLoading,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void displayDialog(BuildContext context) {
    showDialog(context: context, builder: (BuildContext context) => this);
  }
}
