import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/screens/order/order_success_screen.dart';
import 'package:takos_corner_express/services/cart_provider.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/button_widget.dart';
import 'package:takos_corner_express/widgets/global/custom_back_appbar.dart';

enum _PaymentMethod { cash, card, wallet }

class PaymentScreen extends StatefulWidget {
  static const routeName = '/PaymentScreen';
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  _PaymentMethod _method = _PaymentMethod.cash;
  final _promoCtrl = TextEditingController();
  bool _promoError = false;
  bool _promoExpanded = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill if a promo is already applied
    final cart = context.read<CartProvider>();
    if (cart.promoCode.isNotEmpty) {
      _promoCtrl.text = cart.promoCode;
    }
  }

  @override
  void dispose() {
    _promoCtrl.dispose();
    super.dispose();
  }

  void _applyPromo(CartProvider cart) {
    final applied = cart.applyPromoCode(_promoCtrl.text);
    setState(() => _promoError = !applied);
    if (applied) {
      setState(() => _promoExpanded = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Promo "${cart.promoCode}" applied!'),
          backgroundColor: success,
        ),
      );
    }
  }

  void _placeOrder(CartProvider cart) {
    final orderNumber = 'TK-${2000 + cart.items.length * 37 + cart.itemCount}';
    cart.clearCart();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => OrderSuccessScreen(orderNumber: orderNumber),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: customBackAppBar(context, 'Payment', ''),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Promo code ────────────────────────────────────────────────
            _PromoSection(
              cart: cart,
              controller: _promoCtrl,
              hasError: _promoError,
              expanded: _promoExpanded,
              onToggle: () => setState(() => _promoExpanded = !_promoExpanded),
              onApply: () => _applyPromo(cart),
              onRemove: () {
                cart.removePromoCode();
                _promoCtrl.clear();
                setState(() {
                  _promoError = false;
                  _promoExpanded = false;
                });
              },
            ),
            SizedBox(height: 20.h),
            Container(
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
                  Text(
                    'Order Summary',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: context.textColor,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ...cart.items.map(
                    (i) => Padding(
                      padding: EdgeInsets.only(bottom: 6.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${i.quantity}x ${i.name}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: context.textBodyColor,
                              ),
                            ),
                          ),
                          Text(
                            '\$${i.total.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: context.textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(color: context.borderColor, height: 20.h),
                  _payRow(context, 'Items', cart.subtotal),
                  _payRow(context, 'Delivery', cart.deliveryFee),
                  _payRow(context, 'Service fee', cart.serviceFee),
                  if (cart.tipAmount > 0)
                    _payRow(
                      context,
                      'Courier tip (${cart.tipPercent.toStringAsFixed(1)} %)',
                      cart.tipAmount,
                    ),
                  if (cart.discount > 0)
                    _payRow(
                      context,
                      'Discount (${cart.promoCode})',
                      -cart.discount,
                      color: context.accentGreen,
                    ),
                  Divider(color: context.borderColor, height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: context.textColor,
                        ),
                      ),
                      Text(
                        '\$${cart.total.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'PAYMENT METHOD',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: textMuted,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 10.h),
            _paymentOption(
              emoji: '💵',
              name: 'Cash on Delivery',
              sub: 'Pay when your order arrives',
              method: _PaymentMethod.cash,
            ),
            SizedBox(height: 10.h),
            _paymentOption(
              emoji: '💳',
              name: 'Credit / Debit Card',
              sub: 'Visa, Mastercard, Amex',
              method: _PaymentMethod.card,
            ),
            SizedBox(height: 10.h),
            _paymentOption(
              emoji: '📱',
              name: 'Mobile Wallet',
              sub: 'Apple Pay, Google Pay',
              method: _PaymentMethod.wallet,
            ),
            SizedBox(height: 20.h),
            ButtonWidget(
              'Place Order',
              () => _placeOrder(cart),
              icon: SolarIconsBold.checkCircle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _payRow(
    BuildContext context,
    String label,
    double value, {
    Color? color,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12.sp, color: context.textBodyColor),
          ),
          Text(
            '${value < 0 ? '–' : ''}\$${value.abs().toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: color ?? context.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentOption({
    required String emoji,
    required String name,
    required String sub,
    required _PaymentMethod method,
  }) {
    final selected = _method == method;
    return GestureDetector(
      onTap: () => setState(() => _method = method),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: selected ? primaryColor : context.borderColor,
            width: selected ? 1.5 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Text(emoji, style: TextStyle(fontSize: 22.sp)),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: context.textColor,
                    ),
                  ),
                  Text(
                    sub,
                    style: TextStyle(fontSize: 11.sp, color: textMuted),
                  ),
                ],
              ),
            ),
            Icon(
              selected
                  ? SolarIconsBold.checkCircle
                  : SolarIconsOutline.checkCircle,
              size: 20.sp,
              color: selected ? primaryColor : textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Promo Section ────────────────────────────────────────────────────────────

class _PromoSection extends StatelessWidget {
  final CartProvider cart;
  final TextEditingController controller;
  final bool hasError;
  final bool expanded;
  final VoidCallback onToggle;
  final VoidCallback onApply;
  final VoidCallback onRemove;

  const _PromoSection({
    required this.cart,
    required this.controller,
    required this.hasError,
    required this.expanded,
    required this.onToggle,
    required this.onApply,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isApplied = cart.promoCode.isNotEmpty;
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isApplied
              ? context.accentGreen
              : hasError
              ? danger
              : context.borderColor,
          width: isApplied || hasError ? 1.5 : 0.5,
        ),
        boxShadow: context.shadows,
      ),
      child: Column(
        children: [
          // ── Header row ─────────────────────────────────────────────────
          GestureDetector(
            onTap: isApplied ? null : onToggle,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Row(
                children: [
                  Icon(
                    isApplied ? SolarIconsBold.tag : SolarIconsOutline.tag,
                    size: 18.sp,
                    color: isApplied ? context.accentGreen : textMuted,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: isApplied
                        ? Text(
                            '"${cart.promoCode}" applied  ✓',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: context.accentGreen,
                            ),
                          )
                        : Text(
                            'Do you have a promo code?',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: context.textBodyColor,
                            ),
                          ),
                  ),
                  if (isApplied)
                    GestureDetector(
                      onTap: onRemove,
                      child: Icon(
                        SolarIconsOutline.closeCircle,
                        size: 18.sp,
                        color: textMuted,
                      ),
                    )
                  else
                    Icon(
                      expanded
                          ? SolarIconsOutline.altArrowUp
                          : SolarIconsOutline.altArrowDown,
                      size: 16.sp,
                      color: textMuted,
                    ),
                ],
              ),
            ),
          ),

          // ── Expandable input ────────────────────────────────────────────
          if (!isApplied && expanded)
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      textCapitalization: TextCapitalization.characters,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: context.textColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter code (e.g. TACO10)',
                        hintStyle: TextStyle(
                          color: textMuted,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        isDense: true,
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
                        errorText: hasError ? 'Invalid code' : null,
                        errorStyle: TextStyle(fontSize: 10.sp),
                      ),
                      onSubmitted: (_) => onApply(),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: onApply,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: primaryGradient,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        'Apply',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
