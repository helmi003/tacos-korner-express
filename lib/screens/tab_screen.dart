import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/screens/cart_screen.dart';
import 'package:takos_corner_express/screens/home_screen.dart';
import 'package:takos_corner_express/screens/profile_screen.dart';
import 'package:takos_corner_express/screens/reels_screen.dart';
import 'package:takos_corner_express/services/cart_provider.dart';
import 'package:takos_corner_express/utils/colors.dart';

class TabScreen extends StatefulWidget {
  static const routeName = '/TabScreen';
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _selectedIndex = 0;

  static const _screens = [
    HomeScreen(),
    ReelsScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cartCount = context.watch<CartProvider>().itemCount;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: IndexedStack(index: _selectedIndex, children: _screens),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: isDark ? uiCardDark : uiCardLight,
            border: Border(
              top: BorderSide(
                color: isDark ? uiBorderDark : uiBorderLight,
                width: 0.5,
              ),
            ),
            boxShadow: isDark ? darkShadows : lightShadows,
          ),
          child: SafeArea(
            child: SizedBox(
              height: 60.h,
              child: Row(
                children: [
                  _TabItem(
                    label: 'Home',
                    icon: SolarIconsOutline.homeSmile,
                    activeIcon: SolarIconsBold.homeSmile,
                    index: 0,
                    currentIndex: _selectedIndex,
                    onTap: (i) => setState(() => _selectedIndex = i),
                  ),
                  _TabItem(
                    label: 'Reels',
                    icon: SolarIconsOutline.playCircle,
                    activeIcon: SolarIconsBold.playCircle,
                    index: 1,
                    currentIndex: _selectedIndex,
                    onTap: (i) => setState(() => _selectedIndex = i),
                  ),
                  _TabItem(
                    label: 'Cart',
                    icon: SolarIconsOutline.cartLarge2,
                    activeIcon: SolarIconsBold.cartLarge2,
                    index: 2,
                    currentIndex: _selectedIndex,
                    badge: cartCount > 0 ? '$cartCount' : null,
                    onTap: (i) => setState(() => _selectedIndex = i),
                  ),
                  _TabItem(
                    label: 'Profile',
                    icon: SolarIconsOutline.userCircle,
                    activeIcon: SolarIconsBold.userCircle,
                    index: 3,
                    currentIndex: _selectedIndex,
                    onTap: (i) => setState(() => _selectedIndex = i),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final String? badge;

  const _TabItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.index,
    required this.currentIndex,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final active = index == currentIndex;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fgColor = active ? primaryColor : (isDark ? textMuted : textBody);

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(active ? activeIcon : icon, size: 24.sp, color: fgColor),
                if (badge != null)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      padding: EdgeInsets.all(3.w),
                      constraints: BoxConstraints(minWidth: 16.w),
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        badge!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 3.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                color: fgColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
