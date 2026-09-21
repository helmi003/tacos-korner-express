import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/screens/authentication/login_screen.dart';
import 'package:takos_corner_express/screens/settings/account/change_password_screen.dart';
import 'package:takos_corner_express/screens/settings/account/edit_profile_screen.dart';
import 'package:takos_corner_express/screens/coming_soon_screen.dart';
import 'package:takos_corner_express/screens/settings/notification_preferences_screen.dart';
import 'package:takos_corner_express/screens/settings/orders/favorite_screen.dart';
import 'package:takos_corner_express/screens/settings/orders/saved_combos_screen.dart';
import 'package:takos_corner_express/screens/settings/support/about_screen.dart';
import 'package:takos_corner_express/screens/settings/support/help_screen.dart';
import 'package:takos_corner_express/screens/settings/orders/orders_screen.dart';
import 'package:takos_corner_express/services/cart_provider.dart';
import 'package:takos_corner_express/services/favorites_provider.dart';
import 'package:takos_corner_express/services/theme_provider.dart';
import 'package:takos_corner_express/services/user_provider.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/custom_back_appbar.dart';
import 'package:takos_corner_express/widgets/global/custom_switch_button.dart';
import 'package:takos_corner_express/widgets/others/language_selector.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/SettingsScreen';
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();
    final isDark = context.watch<ThemeProvider>().isDark;
    final favoritesCount = context.watch<FavoritesProvider>().count;
    final savedCombosCount = context.watch<CartProvider>().savedCombos.length;

    return Scaffold(
      appBar: customBackAppBar(context, "Settings", ""),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSection(context, 'Account', [
              _MenuItemTile(
                icon: SolarIconsOutline.penNewSquare,
                label: 'Edit Profile',
                onTap: () =>
                    Navigator.of(context).pushNamed(EditProfileScreen.routeName),
              ),
              _MenuItemTile(
                icon: SolarIconsOutline.lockPassword,
                label: 'Change Password',
                onTap: () => Navigator.of(
                  context,
                ).pushNamed(ChangePasswordScreen.routeName),
              ),
            ]),
            _buildSection(context, 'Orders', [
              _MenuItemTile(
                icon: SolarIconsOutline.bag2,
                label: 'My Orders',
                badge: user.ordersCount > 0 ? '${user.ordersCount}' : null,
                onTap: () =>
                    Navigator.of(context).pushNamed(OrdersScreen.routeName),
              ),
              _MenuItemTile(
                icon: SolarIconsOutline.heart,
                label: 'Favourites',
                badge: favoritesCount > 0 ? '$favoritesCount' : null,
                onTap: () =>
                    Navigator.of(context).pushNamed(FavouritesScreen.routeName),
              ),
              _MenuItemTile(
                icon: SolarIconsOutline.bookmark,
                label: 'Saved Combos',
                badge: savedCombosCount > 0 ? '$savedCombosCount' : null,
                onTap: () => Navigator.of(
                  context,
                ).pushNamed(SavedCombosScreen.routeName),
              ),
            ]),
            _buildSection(context, 'Preferences', [
              _MenuItemTile(
                icon: SolarIconsOutline.globus,
                label: 'Language',
                trailing: LanguageSelector(showTitle: false),
              ),
              _MenuItemTile(
                icon: isDark ? SolarIconsOutline.sun : SolarIconsOutline.moon,
                label: isDark ? 'Light Mode' : 'Dark Mode',
                trailing: CustomSwitchButton(
                  value: isDark,
                  onChanged: (_) => context.read<ThemeProvider>().toggleTheme(),
                ),
              ),
              _MenuItemTile(
                icon: SolarIconsOutline.bell,
                label: 'Notifications',
                onTap: () => Navigator.of(
                  context,
                ).pushNamed(NotificationPreferencesScreen.routeName),
              ),
            ]),
            _buildSection(context, 'Support', [
              _MenuItemTile(
                icon: SolarIconsOutline.questionCircle,
                label: 'Help & Support',
                onTap: () =>
                    Navigator.of(context).pushNamed(HelpScreen.routeName),
              ),
              _MenuItemTile(
                icon: SolarIconsOutline.start1,
                label: 'Rate the App',
                onTap: () => _openComingSoon(context, 'Rate the App'),
              ),
              _MenuItemTile(
                icon: SolarIconsOutline.infoCircle,
                label: 'About',
                onTap: () =>
                    Navigator.of(context).pushNamed(AboutScreen.routeName),
              ),
              _MenuItemTile(
                icon: SolarIconsOutline.logout,
                label: 'Logout',
                labelColor: danger,
                iconColor: danger,
                onTap: () => _confirmLogout(context),
              ),
            ]),
            SizedBox(height: 24.h),
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                final info = snapshot.data;
                return Text(
                  info == null
                      ? "Tako's Korner"
                      : "Tako's Korner v${info.version}",
                  style: TextStyle(fontSize: 11.sp, color: textMuted),
                );
              },
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  void _openComingSoon(BuildContext context, String title) {
    Navigator.of(
      context,
    ).pushNamed(ComingSoonScreen.routeName, arguments: title);
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<_MenuItemTile> items,
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
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: context.borderColor, width: 0.5),
              boxShadow: context.shadows,
            ),
            clipBehavior: Clip.antiAlias,
            child: Material(
              color: context.cardColor,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Column(
                  children: items.asMap().entries.map((e) {
                    final i = e.key;
                    final item = e.value;
                    return Column(
                      children: [
                        item,
                        if (i < items.length - 1)
                          Divider(
                            height: 0.5,
                            thickness: 0.5,
                            indent: 50.w,
                            color: context.borderColor,
                          ),
                      ],
                    );
                  }).toList(),
                ),
              ),
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
              Navigator.pushReplacementNamed(context, LoginScreen.routeName);
            },
            child: Text('Logout', style: TextStyle(color: danger)),
          ),
        ],
      ),
    );
  }
}

class _MenuItemTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? labelColor;
  final Color? iconColor;
  final String? badge;
  final Widget? trailing;
  const _MenuItemTile({
    required this.icon,
    required this.label,
    this.onTap,
    this.labelColor,
    this.iconColor,
    this.badge,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedIconColor = iconColor ?? context.textMutedColor;
    final resolvedLabelColor = labelColor ?? context.textColor;

    return ListTile(
      dense: true,
      onTap: onTap,
      leading: Container(
        width: 34.w,
        height: 34.w,
        decoration: BoxDecoration(
          color: resolvedIconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(icon, color: resolvedIconColor, size: 17.sp),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: resolvedLabelColor,
        ),
      ),
      trailing:
          trailing ??
          (badge != null
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    badge!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              : Icon(
                  SolarIconsOutline.altArrowRight,
                  size: 14.sp,
                  color: textMuted,
                )),
    );
  }
}
