import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_corner_express/widgets/global/button_widget.dart';
import 'package:takos_corner_express/widgets/global/custom_textfield.dart';

class TextfieldPopup extends StatelessWidget {
  final String description;
  final String hintText;
  final String buttonOne;
  final String buttonTwo;
  final VoidCallback onPressed;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isLoading;

  const TextfieldPopup(
    this.description,
    this.hintText,
    this.buttonOne,
    this.buttonTwo,
    this.onPressed,
    this.controller,
    this.validator, {
    super.key,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.r)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              description,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            CustomTextfield(
              "",
              hintText,
              TextInputType.text,
              controller,
              validator,
              AutovalidateMode.onUserInteraction,
            ),
          ],
        ),
        actions: <Widget>[
          Row(
            children: [
              Expanded(
                child: ButtonWidget(buttonOne, () {
                  Navigator.of(context).pop();
                }, isTransparent: true),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: ButtonWidget(buttonTwo, onPressed, isLoading: isLoading),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void displayDialog(BuildContext context) {
    showDialog(context: context, builder: (BuildContext context) => this);
  }
}
