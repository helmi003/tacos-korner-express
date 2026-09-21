import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/screens/order/payment_screen.dart';
import 'package:takos_corner_express/screens/products/product_customizer_screen.dart';
import 'package:takos_corner_express/screens/search_screen.dart';
import 'package:takos_corner_express/widgets/products/qty_stepper.dart';
import 'package:takos_corner_express/services/cart_provider.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/custom_cashed_image.dart';
import 'package:takos_corner_express/widgets/global/custom_confirmation_dialog.dart';
import 'package:takos_corner_express/widgets/global/custom_snackbar.dart';
import 'package:takos_corner_express/widgets/others/empty_card.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/Cart';
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late final TextEditingController _noteCtrl;

  @override
  void initState() {
    super.initState();
    _noteCtrl = TextEditingController(text: context.read<CartProvider>().note);
  }

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.cardColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text(
              'My Cart',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: context.textColor,
              ),
            ),
            if (cart.itemCount > 0) ...[
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  '${cart.itemCount}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (cart.items.isNotEmpty)
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => ConfirmationDialog(
                    'Remove all items from your cart?',
                    'Clear',
                    'Cancel',
                    danger,
                    () {
                      cart.clearCart();
                      Navigator.pop(context);
                    },
                  ),
                );
              },
              child: Text(
                'Clear',
                style: TextStyle(color: danger, fontSize: 13.sp),
              ),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0.5.h),
          child: Divider(
            height: 0.5.h,
            thickness: 0.5,
            color: context.borderColor,
          ),
        ),
      ),
      body: cart.items.isEmpty
          ? Center(
              child: EmptyCard(
                icon: SolarIconsOutline.cartLarge2,
                message: 'Your cart is empty',
                caption: 'Browse restaurants and add items to get started.',
                buttonText: 'Browse Food',
                onPressed: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const SearchScreen())),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                children: [
                  ...cart.items.map(
                    (item) => _CartItemTile(
                      item: item,
                      onIncrement: () =>
                          context.read<CartProvider>().incrementItem(item.id),
                      onDecrement: () =>
                          context.read<CartProvider>().decrementItem(item.id),
                      onRemove: () =>
                          context.read<CartProvider>().removeItem(item.id),
                      onEdit: item.product != null
                          ? () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductCustomizerScreen(
                                  product: item.product!,
                                  editCartItemId: item.id,
                                  initialQty: item.quantity,
                                  initialSelections: {
                                    for (final c in item.customizations)
                                      c.typeId: List.from(c.selected),
                                  },
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _NoteCard(
                    controller: _noteCtrl,
                    onChanged: (v) => context.read<CartProvider>().setNote(v),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: cart.items.isEmpty
          ? null
          : _CheckoutBar(total: cart.total),
    );
  }
}

// ─── Checkout Bar ─────────────────────────────────────────────────────────────

class _CheckoutBar extends StatelessWidget {
  final double total;
  const _CheckoutBar({required this.total});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const PaymentScreen())),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.h),
        margin: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1AAB8E),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Proceed to Checkout',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                '\$${total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Cart Item Tile ───────────────────────────────────────────────────────────

class _CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;
  final VoidCallback? onEdit;

  const _CartItemTile({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: danger,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(SolarIconsBold.trashBin2, color: Colors.white, size: 22.sp),
            SizedBox(height: 4.h),
            Text(
              'Remove',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: context.borderColor, width: 0.5),
          boxShadow: context.shadows,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Main content row ─────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: CustomCashedImage(
                    item.imageUrl,
                    width: 58.w,
                    height: 58.w,
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
                          fontWeight: FontWeight.w600,
                          color: context.textColor,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      if (item.customizations.isNotEmpty)
                        Text(
                          item.customizationSummary,
                          style: TextStyle(fontSize: 10.sp, color: textMuted),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )
                      else if (item.restaurantName.isNotEmpty)
                        Text(
                          item.restaurantName,
                          style: TextStyle(fontSize: 11.sp, color: textMuted),
                        ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ── Price ─────────────────────────────────────────
                    Text(
                      '\$${item.unitTotal.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    // ── Qty stepper ───────────────────────────────────
                    QtyStepper(
                      qty: item.quantity,
                      onDecrement: onDecrement,
                      onIncrement: onIncrement,
                    ),
                  ],
                ),
              ],
            ),
            // ── Action bar ───────────────────────────────────────────
            SizedBox(height: 10.h),
            Divider(height: 1, thickness: 0.5, color: context.borderColor),
            SizedBox(height: 8.h),
            Row(
              children: [
                if (item.customizations.isNotEmpty) ...[
                  Expanded(child: _SaveComboButton(item: item)),
                  SizedBox(width: 10.w),
                ],
                if (onEdit != null) ...[
                  Expanded(
                    child: GestureDetector(
                      onTap: onEdit,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              SolarIconsBold.pen2,
                              size: 14.sp,
                              color: primaryColor,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              'Edit',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                ],
                Expanded(
                  child: GestureDetector(
                    onTap: onRemove,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      decoration: BoxDecoration(
                        color: context.dangerBgColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            SolarIconsBold.trashBin2,
                            size: 14.sp,
                            color: danger,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Remove',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: danger,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Save Combo Button ────────────────────────────────────────────────────────

class _SaveComboButton extends StatelessWidget {
  final CartItem item;
  const _SaveComboButton({required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final isSaved = cart.isComboSaved(item);

    return GestureDetector(
      onTap: () {
        if (isSaved) {
          cart.removeSavedCombo(item.name, item.customizationSummary);
          CustomSnackbar.show(
            context,
            message: 'Combo removed from saved',
            type: SnackbarType.info,
          );
        } else {
          cart.saveCombo(item);
          CustomSnackbar.show(
            context,
            message: 'Combo saved!',
            type: SnackbarType.success,
          );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: isSaved
              ? context.accentAmber.withValues(alpha: 0.12)
              : context.cardGrayColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSaved
                ? context.accentAmber.withValues(alpha: 0.6)
                : context.borderColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSaved ? SolarIconsBold.bookmark : SolarIconsOutline.bookmark,
              size: 11.sp,
              color: isSaved ? context.accentAmber : textMuted,
            ),
            SizedBox(width: 4.w),
            Text(
              isSaved ? 'Saved' : 'Save combo',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: isSaved ? context.accentAmber : textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Note Card ────────────────────────────────────────────────────────────────

class _NoteCard extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _NoteCard({required this.controller, required this.onChanged});

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
              Icon(SolarIconsOutline.notes, size: 17.sp, color: textMuted),
              SizedBox(width: 8.w),
              Text(
                'Special Instructions',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: context.textColor,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                '(optional)',
                style: TextStyle(fontSize: 11.sp, color: textMuted),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          TextField(
            controller: controller,
            onChanged: onChanged,
            maxLines: 3,
            maxLength: 200,
            style: TextStyle(fontSize: 13.sp, color: context.textColor),
            decoration: InputDecoration(
              hintText: 'Allergies, no onions, extra napkins…',
              hintStyle: TextStyle(fontSize: 12.sp, color: textMuted),
              filled: true,
              fillColor: context.cardGrayColor,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 10.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide.none,
              ),
              counterStyle: TextStyle(fontSize: 10.sp, color: textMuted),
            ),
          ),
        ],
      ),
    );
  }
}
