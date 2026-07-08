import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/services/cart_provider.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/button_widget.dart';
import 'package:takos_corner_express/widgets/others/empty_card.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/Cart';
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _promoCtrl = TextEditingController();
  bool _promoError = false;

  @override
  void dispose() {
    _promoCtrl.dispose();
    super.dispose();
  }

  void _applyPromo(CartProvider cart) {
    final applied = cart.applyPromoCode(_promoCtrl.text);
    setState(() => _promoError = !applied);
    if (applied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Promo "${cart.promoCode}" applied!'),
          backgroundColor: success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart  = context.watch<CartProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: isDark ? uiCardDark : uiCardLight,
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
                padding:
                    EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  '${cart.itemCount}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700),
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
                  builder: (_) => AlertDialog(
                    title: const Text('Clear Cart'),
                    content: const Text(
                        'Remove all items from your cart?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          cart.clearCart();
                          Navigator.pop(context);
                        },
                        child: Text('Clear',
                            style: TextStyle(color: danger)),
                      ),
                    ],
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
            color: isDark ? uiBorderDark : uiBorderLight,
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
                onPressed: () {},
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(16.w),
                    children: [
                      ...cart.items.map((item) => _CartItemTile(
                            item: item,
                            isDark: isDark,
                            onIncrement: () =>
                                context.read<CartProvider>().addItem(item),
                            onDecrement: () => context
                                .read<CartProvider>()
                                .decrementItem(item.id),
                            onRemove: () => context
                                .read<CartProvider>()
                                .removeItem(item.id),
                          )),
                      SizedBox(height: 12.h),
                      _PromoCodeField(
                        controller: _promoCtrl,
                        isDark: isDark,
                        hasError: _promoError,
                        appliedCode: cart.promoCode,
                        onApply: () => _applyPromo(cart),
                        onRemove: () {
                          cart.removePromoCode();
                          _promoCtrl.clear();
                          setState(() => _promoError = false);
                        },
                      ),
                      SizedBox(height: 12.h),
                      _OrderSummary(cart: cart, isDark: isDark),
                    ],
                  ),
                ),
                _CheckoutBar(cart: cart),
              ],
            ),
    );
  }
}

// ─── Cart Item Tile ───────────────────────────────────────────────────────────
class _CartItemTile extends StatelessWidget {
  final CartItem item;
  final bool isDark;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const _CartItemTile({
    required this.item,
    required this.isDark,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 16.w),
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: dangerBg,
          borderRadius: BorderRadius.circular(16.r),
        ),
          child: Icon(Icons.delete_outline, color: danger, size: 22.sp),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: isDark ? uiCardDark : uiCardLight,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDark ? uiBorderDark : uiBorderLight,
            width: 0.5,
          ),
          boxShadow: isDark ? darkShadows : lightShadows,
        ),
        child: Row(
          children: [
            // Image placeholder
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text('🌮', style: TextStyle(fontSize: 24.sp)),
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
                      color: isDark ? textLight : textMain,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(item.restaurantName,
                      style: TextStyle(fontSize: 11.sp, color: textMuted)),
                  SizedBox(height: 6.h),
                  Text(
                    '\$${item.total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            // Qty stepper
            Row(
              children: [
                _StepBtn(
                  icon: SolarIconsBold.minusCircle,
                  color: item.quantity <= 1 ? textMuted : primaryColor,
                  onTap: onDecrement,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    '${item.quantity}',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: isDark ? textLight : textMain,
                    ),
                  ),
                ),
                _StepBtn(
                  icon: SolarIconsBold.addCircle,
                  color: primaryColor,
                  onTap: onIncrement,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _StepBtn(
      {required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: color, size: 26.sp),
    );
  }
}

// ─── Promo Code Field ─────────────────────────────────────────────────────────
class _PromoCodeField extends StatelessWidget {
  final TextEditingController controller;
  final bool isDark;
  final bool hasError;
  final String appliedCode;
  final VoidCallback onApply;
  final VoidCallback onRemove;

  const _PromoCodeField({
    required this.controller,
    required this.isDark,
    required this.hasError,
    required this.appliedCode,
    required this.onApply,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isApplied = appliedCode.isNotEmpty;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark ? uiCardDark : uiCardLight,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isApplied
              ? success
              : hasError
                  ? danger
                  : (isDark ? uiBorderDark : uiBorderLight),
          width: isApplied || hasError ? 1.5 : 0.5,
        ),
      ),
      child: isApplied
          ? Row(
              children: [
                Icon(SolarIconsBold.tag, color: success, size: 18.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    '"$appliedCode" applied!',
                    style: TextStyle(
                      color: success,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onRemove,
                  child: Icon(SolarIconsOutline.closeCircle,
                      color: textMuted, size: 18.sp),
                ),
              ],
            )
          : Row(
              children: [
                Icon(SolarIconsOutline.tag, color: textMuted, size: 18.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: TextStyle(fontSize: 13.sp, color: context.textColor),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Promo code (try TACO10)',
                      hintStyle:
                          TextStyle(color: textMuted, fontSize: 13.sp),
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      errorText: hasError ? 'Invalid promo code' : null,
                    ),
                    onSubmitted: (_) => onApply(),
                  ),
                ),
                GestureDetector(
                  onTap: onApply,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'Apply',
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
    );
  }
}

// ─── Order Summary ────────────────────────────────────────────────────────────
class _OrderSummary extends StatelessWidget {
  final CartProvider cart;
  final bool isDark;
  const _OrderSummary({required this.cart, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? textLight : textMain,
            ),
          ),
          SizedBox(height: 14.h),
          _SummaryRow(
            label: 'Subtotal',
            value: '\$${cart.subtotal.toStringAsFixed(2)}',
            isDark: isDark,
          ),
          _SummaryRow(
            label: 'Delivery fee',
            value: '\$${cart.deliveryFee.toStringAsFixed(2)}',
            isDark: isDark,
          ),
          if (cart.discount > 0)
            _SummaryRow(
              label: 'Discount (${cart.promoCode})',
              value: '–\$${cart.discount.toStringAsFixed(2)}',
              isDark: isDark,
              valueColor: success,
            ),
          Divider(
            color: isDark ? uiBorderDark : uiBorderLight,
            height: 24.h,
          ),
          _SummaryRow(
            label: 'Total',
            value: '\$${cart.total.toStringAsFixed(2)}',
            isDark: isDark,
            bold: true,
            valueColor: primaryColor,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final bool bold;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.isDark,
    this.bold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: bold ? 15.sp : 13.sp,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
              color: isDark ? textMuted : textBody,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: bold ? 16.sp : 13.sp,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
              color: valueColor ?? (isDark ? textLight : textMain),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Checkout Bar ─────────────────────────────────────────────────────────────
class _CheckoutBar extends StatelessWidget {
  final CartProvider cart;
  const _CheckoutBar({required this.cart});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w,
          MediaQuery.of(context).padding.bottom + 12.h),
      decoration: BoxDecoration(
        color: isDark ? uiCardDark : uiCardLight,
        border: Border(
          top: BorderSide(
            color: isDark ? uiBorderDark : uiBorderLight,
            width: 0.5,
          ),
        ),
      ),
      child: ButtonWidget(
        'Proceed to Checkout  •  \$${cart.total.toStringAsFixed(2)}',
        () {},
        icon: SolarIconsBold.arrowRight,
        iconRight: true,
      ),
    );
  }
}
