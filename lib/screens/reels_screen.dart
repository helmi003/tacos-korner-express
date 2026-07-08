import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/utils/colors.dart';

class _Reel {
  final String restaurantName;
  final String dishName;
  final String emoji;
  final int likes;
  final int comments;
  final Color accent;

  const _Reel({
    required this.restaurantName,
    required this.dishName,
    required this.emoji,
    required this.likes,
    required this.comments,
    required this.accent,
  });
}

const _reels = [
  _Reel(restaurantName: 'El Rancho', dishName: 'Crispy Chicken Taco', emoji: '🌮', likes: 1420, comments: 84, accent: primaryColor),
  _Reel(restaurantName: 'Burger Craft', dishName: 'Double Smash Burger', emoji: '🍔', likes: 983, comments: 51, accent: accentAmber),
  _Reel(restaurantName: 'Sakura Sushi', dishName: 'Dragon Roll', emoji: '🍣', likes: 2100, comments: 123, accent: accentBlue),
  _Reel(restaurantName: 'La Bella Pizza', dishName: 'Quattro Formaggi', emoji: '🍕', likes: 760, comments: 39, accent: accentGreen),
  _Reel(restaurantName: 'Fresh Bar', dishName: 'Tropical Açaí', emoji: '🫐', likes: 1830, comments: 97, accent: accentPurple),
];

class ReelsScreen extends StatefulWidget {
  static const routeName = '/Reels';
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  final PageController _controller = PageController();
  final Set<int> _liked = {};

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _controller,
        scrollDirection: Axis.vertical,
        itemCount: _reels.length,
        itemBuilder: (_, i) => _ReelPage(
          reel: _reels[i],
          isLiked: _liked.contains(i),
          onLike: () => setState(() {
            if (_liked.contains(i)) {
              _liked.remove(i);
            } else {
              _liked.add(i);
            }
          }),
        ),
      ),
    );
  }
}

class _ReelPage extends StatelessWidget {
  final _Reel reel;
  final bool isLiked;
  final VoidCallback onLike;

  const _ReelPage({
    required this.reel,
    required this.isLiked,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                reel.accent.withValues(alpha: 0.6),
                Colors.black,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Text(
              reel.emoji,
              style: TextStyle(fontSize: 140.sp),
            ),
          ),
        ),

        // Bottom gradient overlay
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 300.h,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black.withValues(alpha: 0.85)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),

        // Top app bar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reels',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Icon(SolarIconsOutline.camera, color: Colors.white, size: 22.sp),
                ],
              ),
            ),
          ),
        ),

        // Right action column
        Positioned(
          right: 12.w,
          bottom: 120.h,
          child: Column(
            children: [
              _ActionBtn(
                icon: isLiked ? SolarIconsBold.heart : SolarIconsOutline.heart,
                label: _formatCount(reel.likes + (isLiked ? 1 : 0)),
                color: isLiked ? primaryColor : Colors.white,
                onTap: onLike,
              ),
              SizedBox(height: 24.h),
              _ActionBtn(
                icon: SolarIconsOutline.chatRound,
                label: _formatCount(reel.comments),
                color: Colors.white,
                onTap: () {},
              ),
              SizedBox(height: 24.h),
              _ActionBtn(
                icon: SolarIconsOutline.shareCircle,
                label: 'Share',
                color: Colors.white,
                onTap: () {},
              ),
              SizedBox(height: 24.h),
              _ActionBtn(
                icon: SolarIconsOutline.bookmark,
                label: 'Save',
                color: Colors.white,
                onTap: () {},
              ),
            ],
          ),
        ),

        // Bottom info
        Positioned(
          left: 16.w,
          right: 70.w,
          bottom: 60.h,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Restaurant chip
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: reel.accent.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    reel.restaurantName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  reel.dishName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6.h),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w, vertical: 7.h),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      'Order Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatCount(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 28.sp),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
