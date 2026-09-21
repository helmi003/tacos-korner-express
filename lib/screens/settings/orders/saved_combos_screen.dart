import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/services/cart_provider.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/custom_back_appbar.dart';
import 'package:takos_corner_express/widgets/global/custom_cashed_image.dart';
import 'package:takos_corner_express/widgets/global/custom_confirmation_dialog.dart';
import 'package:takos_corner_express/widgets/global/custom_snackbar.dart';
import 'package:takos_corner_express/widgets/others/empty_card.dart';

class SavedCombosScreen extends StatelessWidget {
  static const routeName = '/SavedCombosScreen';
  const SavedCombosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final combos = context.watch<CartProvider>().savedCombos;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: customBackAppBar(context, 'Saved Combos', ''),
      body: combos.isEmpty
          ? Padding(
              padding: EdgeInsets.all(16.w),
              child: const EmptyCard(
                icon: SolarIconsOutline.bookmark,
                message: 'No saved combos yet.',
                caption:
                    'Save a customized order from your cart to reorder it quickly.',
                withBG: false,
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.all(16.w),
              itemCount: combos.length,
              separatorBuilder: (_, _) => SizedBox(height: 12.h),
              itemBuilder: (_, i) => _ComboTile(item: combos[i]),
            ),
    );
  }
}

class _ComboTile extends StatelessWidget {
  final CartItem item;
  const _ComboTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.borderColor, width: 0.5),
        boxShadow: context.shadows,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: CustomCashedImage(
              item.imageUrl,
              width: 56.w,
              height: 56.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: context.textColor,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  item.customizationSummary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11.sp, color: textMuted),
                ),
                SizedBox(height: 6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${item.unitTotal.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                        color: primaryColor,
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => showDialog(
                            context: context,
                            builder: (_) => ConfirmationDialog(
                              'Remove Saved Combo',
                              'Remove',
                              'Cancel',
                              danger,
                              () {
                                context.read<CartProvider>().removeSavedCombo(
                                  item.name,
                                  item.customizationSummary,
                                );
                                CustomSnackbar.show(
                                  context,
                                  message:
                                      '${item.name} removed from saved combos',
                                  type: SnackbarType.info,
                                );
                              },
                            ),
                          ),
                          child: Icon(
                            SolarIconsOutline.trashBinTrash,
                            size: 16.sp,
                            color: danger,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        GestureDetector(
                          onTap: () {
                            context.read<CartProvider>().addSavedComboToCart(
                              item,
                            );
                            CustomSnackbar.show(
                              context,
                              message: '${item.name} added to cart',
                              type: SnackbarType.success,
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 5.h,
                            ),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              'Reorder',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
