import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_corner_express/helpers/user_helper.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/utils/enums.dart';
import 'package:takos_corner_express/widgets/global/custom_cashed_image.dart';
import 'package:solar_icons/solar_icons.dart';

class UserAvatar extends StatelessWidget {
  final String fullName;
  final bool? emailVerified;
  final String? userPhotoUrl;
  final AuthProvider? authProvider;
  final double size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BoxBorder? border;

  const UserAvatar({
    super.key,
    required this.fullName,
    this.emailVerified,
    this.userPhotoUrl,
    this.authProvider,
    this.size = 38,
    this.backgroundColor,
    this.foregroundColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final dim = size.w;
    final iconSize = (size * 0.53).sp;
    final fontSize = (size * 0.34).sp;
    final badgeDim = (size * 0.42).w;
    final badgeBorder = (size * 0.08).w;
    final badgeIconSize = (size * 0.26).sp;
    final badgeOffset = -(size * 0.08).w;
    final effectiveBg = backgroundColor ?? primaryColor.withValues(alpha: 0.1);
    final effectiveFg = foregroundColor ?? primaryColor;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: dim,
          height: dim,
          decoration: BoxDecoration(
            color: effectiveBg,
            shape: BoxShape.circle,
            border: border,
          ),
          alignment: Alignment.center,
          child: userPhotoUrl != null && userPhotoUrl!.isNotEmpty
              ? ClipOval(
                  child: CustomCashedImage(
                    userPhotoUrl!,
                    width: dim,
                    height: dim,
                    fit: BoxFit.cover,
                    errorWidget: Icon(
                      SolarIconsBold.user,
                      size: iconSize,
                      color: effectiveFg,
                    ),
                  ),
                )
              : Text(
                  getUserNameLetters(fullName),
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w700,
                    color: effectiveFg,
                  ),
                ),
        ),
        if (authProvider != null || emailVerified == true)
          Positioned(
            bottom: badgeOffset,
            right: badgeOffset,
            child: Container(
              width: badgeDim,
              height: badgeDim,
              decoration: BoxDecoration(
                color: context.cardColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.cardColor,
                  width: badgeBorder,
                ),
              ),
              child: switch (authProvider) {
                AuthProvider.google || AuthProvider.facebook => Image.asset(
                  'assets/images/${authProvider!.name}.png',
                  fit: BoxFit.contain,
                ),
                _ => Icon(
                  SolarIconsBold.verifiedCheck,
                  size: badgeIconSize,
                  color: success,
                ),
              },
            ),
          ),
      ],
    );
  }
}
