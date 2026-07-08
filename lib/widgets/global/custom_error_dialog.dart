import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_corner_express/l10n/app_localizations.dart';
import 'package:takos_corner_express/widgets/global/button_widget.dart';

class CustomErrorDialog extends StatelessWidget {
  final String errorMsg;
  const CustomErrorDialog(this.errorMsg, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.r)),
      ),
      content: Text(
        errorMsg,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
      ),
      actions: <Widget>[
        ButtonWidget(AppLocalizations.of(context)!.common_agree, () {
          Navigator.of(context).pop();
        }),
      ],
    );
  }

  static void show(BuildContext context, String message) {
    if (!context.mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CustomErrorDialog(message),
    );
  }
}
