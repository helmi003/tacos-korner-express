import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/screens/authentication/login_screen.dart';
import 'package:takos_corner_express/screens/settings/orders/favorite_screen.dart';
import 'package:takos_corner_express/services/favorites_provider.dart';
import 'package:takos_corner_express/services/user_provider.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/custom_appbar.dart';
import 'package:takos_corner_express/widgets/others/user_avatar.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/Profile';
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();

    return Scaffold(
      appBar: customAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(context, user),
            SizedBox(height: 8.h),
            _buildStatsRow(context, user),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserProvider user) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: primaryGradient,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          UserAvatar(
            fullName: user.isLoggedIn ? (user.name ?? 'Guest') : 'Guest',
            userPhotoUrl: user.avatarUrl,
            size: 60,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.isLoggedIn ? (user.name ?? 'User') : 'Guest User',
                  style: TextStyle(
                    color: textLight,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  user.isLoggedIn ? (user.email ?? '') : 'Sign in to order',
                  style: TextStyle(color: textMuted, fontSize: 12.sp),
                ),
                if (!user.isLoggedIn) ...[
                  SizedBox(height: 8.h),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, LoginScreen.routeName),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (user.isLoggedIn)
            Icon(
              SolarIconsOutline.penNewSquare,
              color: Colors.white70,
              size: 20.sp,
            ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, UserProvider user) {
    final favoritesCount = context.watch<FavoritesProvider>().count;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          _StatCard(
            value: '${user.ordersCount}',
            label: 'Orders',
            icon: SolarIconsBold.bag2,
          ),
          SizedBox(width: 10.w),
          _StatCard(
            value: '$favoritesCount',
            label: 'Favourites',
            icon: SolarIconsBold.heart,
            color: danger,
            onTap: () =>
                Navigator.of(context).pushNamed(FavouritesScreen.routeName),
          ),
          SizedBox(width: 10.w),
          _StatCard(
            value: '4.9',
            label: 'Rating',
            icon: SolarIconsBold.start1,
            color: context.accentAmber,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? primaryColor;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: context.borderColor, width: 0.5),
            boxShadow: context.shadows,
          ),
          child: Column(
            children: [
              Icon(icon, color: c, size: 20.sp),
              SizedBox(height: 4.h),
              Text(
                value,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800),
              ),
              Text(
                label,
                style: TextStyle(fontSize: 10.sp, color: textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
