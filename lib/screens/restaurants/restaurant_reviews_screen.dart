import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/data/home_data.dart';
import 'package:takos_corner_express/data/reviews_data.dart';
import 'package:takos_corner_express/helpers/date_helper.dart';
import 'package:takos_corner_express/screens/restaurants/restaurant_details_screen.dart';
import 'package:takos_corner_express/services/reviews_provider.dart';
import 'package:takos_corner_express/services/user_provider.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/custom_back_appbar.dart';
import 'package:takos_corner_express/widgets/global/custom_not_found_text.dart';
import 'package:takos_corner_express/widgets/global/custom_snackbar.dart';
import 'package:takos_corner_express/widgets/others/review_stat.dart';

class RestaurantReviewsScreen extends StatelessWidget {
  static const routeName = '/RestaurantReviewsScreen';
  final RestaurantModel restaurant;
  const RestaurantReviewsScreen({super.key, required this.restaurant});

  void _openWriteReviewSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _WriteReviewSheet(restaurant: restaurant),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reviews = context.watch<ReviewsProvider>().reviewsFor(restaurant.id);
    final providerCount = reviews.length;
    final displayRating = providerCount > 0
        ? context.watch<ReviewsProvider>().averageFor(restaurant.id)
        : restaurant.rating;
    final displayCount = providerCount > 0 ? providerCount : restaurant.reviews;
    final breakdown = context.watch<ReviewsProvider>().breakdownFor(
      restaurant.id,
    );
    final maxBucket = breakdown.isEmpty
        ? 0
        : breakdown.reduce((a, b) => a > b ? a : b);

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: customBackAppBar(context, 'Reviews', restaurant.name),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReviewStat(
              displayRating: displayRating,
              displayCount: displayCount,
              breakdown: breakdown,
              maxBucket: maxBucket,
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: () => _openWriteReviewSheet(context),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 13.h),
                decoration: BoxDecoration(
                  gradient: primaryGradient,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(SolarIconsBold.pen2, size: 16.sp, color: Colors.white),
                    SizedBox(width: 8.w),
                    Text(
                      'Write a review',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            if (reviews.isEmpty)
              CustomNotFoundText('No reviews yet.')
            else
              ...reviews.map(
                (r) => Padding(
                  padding: EdgeInsets.only(bottom: 14.h),
                  child: _ReviewCard(review: r, restaurant: restaurant),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  final int rating;
  final double size;
  const _StarRow({required this.rating, required this.size});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < rating;
        return Icon(
          SolarIconsBold.start1,
          size: size,
          color: filled ? context.accentAmber : context.borderColor,
        );
      }),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final ReviewModel review;
  final RestaurantModel restaurant;
  const _ReviewCard({required this.review, required this.restaurant});

  String get _initials {
    final parts = review.authorName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.isNotEmpty && parts.first.isNotEmpty
        ? parts.first[0].toUpperCase()
        : '?';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.borderColor, width: 0.5),
        boxShadow: context.shadows,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34.w,
                height: 34.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: context.cardGrayColor,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  _initials,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: context.textBodyColor,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.authorName,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: context.textColor,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    _StarRow(rating: review.rating, size: 11.sp),
                  ],
                ),
              ),
              Text(
                humanReadableDate(context, review.date),
                style: TextStyle(
                  fontSize: 10.sp,
                  color: context.textMutedColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            review.comment,
            style: TextStyle(
              fontSize: 13.sp,
              color: context.textBodyColor,
              height: 1.5,
            ),
          ),
          if (review.ownerReplyText != null) ...[
            SizedBox(height: 10.h),
            Container(
              margin: EdgeInsets.only(left: 20.w),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: context.cardBlueColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        SolarIconsBold.shop,
                        size: 12.sp,
                        color: context.accentBlue,
                      ),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => RestaurantDetailsScreen(
                                restaurant: restaurant,
                              ),
                            ),
                          ),
                          child: Text(
                            restaurant.name,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              color: context.accentBlue,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      if (review.ownerReplyDate != null) ...[
                        SizedBox(width: 6.w),
                        Text(
                          humanReadableDate(context, review.ownerReplyDate!),
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: context.textMutedColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    review.ownerReplyText!,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: context.textBodyColor,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _WriteReviewSheet extends StatefulWidget {
  final RestaurantModel restaurant;
  const _WriteReviewSheet({required this.restaurant});

  @override
  State<_WriteReviewSheet> createState() => _WriteReviewSheetState();
}

class _WriteReviewSheetState extends State<_WriteReviewSheet> {
  final _commentCtrl = TextEditingController();
  int _rating = 0;

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_rating == 0 || _commentCtrl.text.trim().isEmpty) {
      CustomSnackbar.show(
        context,
        message: 'Please add a star rating and a comment',
        type: SnackbarType.warning,
      );
      return;
    }

    context.read<ReviewsProvider>().addReview(
      restaurantId: widget.restaurant.id,
      authorName: context.read<UserProvider>().name ?? 'You',
      rating: _rating,
      comment: _commentCtrl.text.trim(),
    );

    Navigator.of(context).pop();
    CustomSnackbar.show(
      context,
      message: 'Review submitted — thank you!',
      type: SnackbarType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20.w,
        16.h,
        20.w,
        20.h + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        boxShadow: context.shadows,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              height: 4.h,
              width: 40.w,
              decoration: BoxDecoration(
                color: context.borderColor,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Rate ${widget.restaurant.name}',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: context.textColor,
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final starValue = i + 1;
              final filled = starValue <= _rating;
              return GestureDetector(
                onTap: () => setState(() => _rating = starValue),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Icon(
                    SolarIconsBold.start1,
                    size: 30.sp,
                    color: filled ? context.accentAmber : context.borderColor,
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 16.h),
          TextField(
            controller: _commentCtrl,
            maxLines: 4,
            style: TextStyle(fontSize: 13.sp, color: context.textColor),
            decoration: InputDecoration(
              hintText: 'Share your experience…',
              hintStyle: TextStyle(fontSize: 13.sp, color: textMuted),
              filled: true,
              fillColor: context.cardGrayColor,
              contentPadding: EdgeInsets.all(12.w),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: _submit,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 13.h),
              decoration: BoxDecoration(
                gradient: primaryGradient,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                'Submit Review',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
