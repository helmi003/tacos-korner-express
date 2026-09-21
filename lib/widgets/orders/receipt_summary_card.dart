import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/models/address_model.dart';
import 'package:takos_corner_express/screens/order/order_success_screen.dart';
import 'package:takos_corner_express/services/cart_provider.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/button_widget.dart';
import 'package:takos_corner_express/widgets/global/custom_snackbar.dart';

class ReceiptSummaryCard extends StatelessWidget {
  final CartProvider cart;
  final AddressModel? selectedAddress;

  const ReceiptSummaryCard({
    super.key,
    required this.cart,
    this.selectedAddress,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = context.cardColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomPaint(
          size: Size(double.infinity, 10.h),
          painter: ZigzagEdgePainter(color: bgColor),
        ),
        Container(
          color: bgColor,
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Summary',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w800,
                  color: context.textColor,
                ),
              ),
              SizedBox(height: 10.h),
              ReceiptRow(label: 'Items', value: cart.subtotal),
              ReceiptRow(label: 'Delivery', value: cart.deliveryFee),
              ReceiptRow(
                label: 'Service fee',
                value: cart.serviceFee,
                onInfoTap: () => showServiceFeeInfo(context),
              ),
              if (cart.tipAmount > 0)
                ReceiptRow(
                  label:
                      'Courier tip (${cart.tipPercent.toStringAsFixed(1)} %)',
                  value: cart.tipAmount,
                ),
              if (cart.discount > 0)
                ReceiptRow(
                  label: 'Discount (${cart.promoCode})',
                  value: -cart.discount,
                  valueColor: context.accentGreen,
                ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: DashedDivider(color: context.receiptDividerColor),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total to pay',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                      color: context.textColor,
                    ),
                  ),
                  Text(
                    '\$${cart.total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w800,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              ButtonWidget(
                'Place Order',
                () => _placeOrder(
                  context,
                  cart,
                  selectedAddress: selectedAddress,
                ),
                icon: SolarIconsBold.checkCircle,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void showServiceFeeInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Service Fee',
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'This fee helps us run the Tako\'s Korner platform — covering '
          'payment processing, order support, and app maintenance.',
          style: TextStyle(fontSize: 13.sp, color: textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Got it',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _placeOrder(
    BuildContext context,
    CartProvider cart, {
    AddressModel? selectedAddress,
  }) {
    if (selectedAddress == null) {
      CustomSnackbar.show(
        context,
        message: 'Please choose a delivery address',
        type: SnackbarType.error,
      );
      return;
    }
    final orderNumber = 'TK-${2000 + cart.items.length * 37 + cart.itemCount}';
    cart.clearCart();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => OrderSuccessScreen(orderNumber: orderNumber),
      ),
    );
  }
}

class ReceiptRow extends StatelessWidget {
  final String label;
  final double value;
  final Color? valueColor;
  final VoidCallback? onInfoTap;

  const ReceiptRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 13.sp, color: context.textBodyColor),
          ),
          if (onInfoTap != null) ...[
            SizedBox(width: 4.w),
            GestureDetector(
              onTap: onInfoTap,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.all(2.w),
                child: Icon(
                  SolarIconsOutline.infoCircle,
                  size: 13.sp,
                  color: textMuted,
                ),
              ),
            ),
          ],
          const Spacer(),
          Text(
            '${value < 0 ? '–' : ''}\$${value.abs().toStringAsFixed(3)}',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: valueColor ?? context.textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class ZigzagEdgePainter extends CustomPainter {
  final Color color;
  ZigzagEdgePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const double toothW = 12.0;
    final path = Path();
    path.moveTo(0, size.height);
    double x = 0;
    while (x < size.width + toothW) {
      path.lineTo(x + toothW / 2, 0);
      path.lineTo(x + toothW, size.height);
      x += toothW;
    }
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DashedDivider extends StatelessWidget {
  final Color color;
  const DashedDivider({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, 1),
      painter: _DashedLinePainter(color: color),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const double dashW = 6;
    const double gapW = 4;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(math.min(x + dashW, size.width), 0),
        paint,
      );
      x += dashW + gapW;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
