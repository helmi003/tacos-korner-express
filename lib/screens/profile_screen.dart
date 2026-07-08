import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/screens/authentication/login_screen.dart';
import 'package:takos_corner_express/services/theme_provider.dart';
import 'package:takos_corner_express/services/user_provider.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/others/user_avatar.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/Profile';
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user   = context.watch<UserProvider>();
    final theme  = context.watch<ThemeProvider>();
    final isDark = theme.isDark;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, isDark),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildProfileHeader(context, user, isDark),
                SizedBox(height: 8.h),
                _buildStatsRow(context, user, isDark),
                SizedBox(height: 16.h),
                _buildSection(
                  context,
                  'Account',
                  isDark,
                  [
                    _MenuItem(
                      icon: SolarIconsOutline.penNewSquare,
                      label: 'Edit Profile',
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: SolarIconsOutline.mapPoint,
                      label: 'My Addresses',
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: SolarIconsOutline.lockPassword,
                      label: 'Change Password',
                      onTap: () {},
                    ),
                  ],
                ),
                _buildSection(
                  context,
                  'Orders',
                  isDark,
                  [
                    _MenuItem(
                      icon: SolarIconsOutline.bag2,
                      label: 'My Orders',
                      badge: user.ordersCount > 0
                          ? '${user.ordersCount}'
                          : null,
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: SolarIconsOutline.heart,
                      label: 'Favourites',
                      badge: user.favoritesCount > 0
                          ? '${user.favoritesCount}'
                          : null,
                      onTap: () {},
                    ),
                  ],
                ),
                _buildSection(
                  context,
                  'Preferences',
                  isDark,
                  [
                    _MenuItem(
                      icon: SolarIconsOutline.globus,
                      label: 'Language',
                      trailing: Text(
                        'English',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: textMuted,
                        ),
                      ),
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: isDark
                          ? SolarIconsOutline.sun
                          : SolarIconsOutline.moon,
                      label: isDark ? 'Light Mode' : 'Dark Mode',
                      trailing: Switch(
                        value: isDark,
                        onChanged: (_) => theme.toggleTheme(),
                        activeThumbColor: primaryColor,
                      ),
                      onTap: () => theme.toggleTheme(),
                    ),
                    _MenuItem(
                      icon: SolarIconsOutline.bell,
                      label: 'Notifications',
                      onTap: () {},
                    ),
                  ],
                ),
                _buildSection(
                  context,
                  'Support',
                  isDark,
                  [
                    _MenuItem(
                      icon: SolarIconsOutline.questionCircle,
                      label: 'Help & Support',
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: SolarIconsOutline.star,
                      label: 'Rate the App',
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: SolarIconsOutline.infoCircle,
                      label: 'About',
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: SolarIconsOutline.logout,
                      label: 'Logout',
                      labelColor: danger,
                      iconColor: danger,
                      onTap: () => _confirmLogout(context),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Text(
                  "Tako's Korner v1.0.0",
                  style: TextStyle(fontSize: 11.sp, color: textMuted),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDark) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: isDark ? uiCardDark : uiCardLight,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Text(
        'Profile',
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: context.textColor,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(SolarIconsOutline.settings,
              color: context.textColor, size: 22.sp),
          onPressed: () {},
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(0.5.h),
        child: Divider(
          height: 0.5.h,
          thickness: 0.5,
          color: isDark ? uiBorderDark : uiBorderLight,
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
      BuildContext context, UserProvider user, bool isDark) {
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
                    color: Colors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  user.isLoggedIn ? (user.email ?? '') : 'Sign in to order',
                  style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                ),
                if (!user.isLoggedIn) ...[
                  SizedBox(height: 8.h),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(
                        context, LoginScreen.routeName),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 14.w, vertical: 6.h),
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
            Icon(SolarIconsOutline.penNewSquare,
                color: Colors.white70, size: 20.sp),
        ],
      ),
    );
  }

  Widget _buildStatsRow(
      BuildContext context, UserProvider user, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          _StatCard(
            value: '${user.ordersCount}',
            label: 'Orders',
            icon: SolarIconsBold.bag2,
            isDark: isDark,
          ),
          SizedBox(width: 10.w),
          _StatCard(
            value: '${user.favoritesCount}',
            label: 'Favourites',
            icon: SolarIconsBold.heart,
            color: danger,
            isDark: isDark,
          ),
          SizedBox(width: 10.w),
          _StatCard(
            value: '4.9',
            label: 'Rating',
            icon: SolarIconsBold.star,
            color: accentAmber,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    bool isDark,
    List<_MenuItem> items,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.h, top: 4.h),
            child: Text(
              title.toUpperCase(),
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: textMuted,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: isDark ? uiCardDark : uiCardLight,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isDark ? uiBorderDark : uiBorderLight,
                width: 0.5,
              ),
              boxShadow: isDark ? darkShadows : lightShadows,
            ),
            child: Column(
              children: items.asMap().entries.map((e) {
                final i    = e.key;
                final item = e.value;
                return Column(
                  children: [
                    _MenuItemTile(item: item, isDark: isDark),
                    if (i < items.length - 1)
                      Divider(
                        height: 0.5,
                        thickness: 0.5,
                        indent: 50.w,
                        color: isDark ? uiBorderDark : uiBorderLight,
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<UserProvider>().logout();
              Navigator.pop(context);
              Navigator.pushReplacementNamed(
                  context, LoginScreen.routeName);
            },
            child: Text('Logout', style: TextStyle(color: danger)),
          ),
        ],
      ),
    );
  }
}

// ─── Stat Card ────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color? color;
  final bool isDark;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.isDark,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? primaryColor;
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: isDark ? uiCardDark : uiCardLight,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isDark ? uiBorderDark : uiBorderLight,
            width: 0.5,
          ),
          boxShadow: isDark ? darkShadows : lightShadows,
        ),
        child: Column(
          children: [
            Icon(icon, color: c, size: 20.sp),
            SizedBox(height: 4.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: isDark ? textLight : textMain,
              ),
            ),
            Text(label,
                style: TextStyle(fontSize: 10.sp, color: textMuted)),
          ],
        ),
      ),
    );
  }
}

// ─── Menu Item ────────────────────────────────────────────────────────────────
class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? labelColor;
  final Color? iconColor;
  final String? badge;
  final Widget? trailing;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.labelColor,
    this.iconColor,
    this.badge,
    this.trailing,
  });
}

class _MenuItemTile extends StatelessWidget {
  final _MenuItem item;
  final bool isDark;
  const _MenuItemTile({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final iconColor = item.iconColor ?? (isDark ? textMuted : primaryColor);
    final labelColor = item.labelColor ?? (isDark ? textLight : textMain);

    return ListTile(
      dense: true,
      onTap: item.onTap,
      leading: Container(
        width: 34.w,
        height: 34.w,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(item.icon, color: iconColor, size: 17.sp),
      ),
      title: Text(
        item.label,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: labelColor,
        ),
      ),
      trailing: item.trailing ??
          (item.badge != null
              ? Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    item.badge!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              : Icon(SolarIconsOutline.altArrowRight,
                  size: 14.sp, color: textMuted)),
    );
  }
}
