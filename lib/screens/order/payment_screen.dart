import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/models/address_model.dart';
import 'package:takos_corner_express/screens/settings/account/edit_profile_screen.dart';
import 'package:takos_corner_express/services/cart_provider.dart';
import 'package:takos_corner_express/services/user_provider.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/custom_back_appbar.dart';
import 'package:takos_corner_express/widgets/orders/receipt_summary_card.dart';
import 'package:takos_corner_express/widgets/others/or_divider.dart';

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
  AddressModel? _selectedAddress;

  @override
  void initState() {
    super.initState();
    // Pre-fill if a promo is already applied
    final cart = context.read<CartProvider>();
    if (cart.promoCode.isNotEmpty) {
      _promoCtrl.text = cart.promoCode;
    }
    _selectedAddress = context.read<UserProvider>().defaultAddress;
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

  Future<void> _chooseAddress() async {
    final addresses = context.read<UserProvider>().addresses;
    final picked = await showModalBottomSheet<AddressModel>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) =>
          _AddressPickerSheet(addresses: addresses, selected: _selectedAddress),
    );
    if (picked != null) setState(() => _selectedAddress = picked);
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: customBackAppBar(context, 'Payment', ''),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Delivery address ────────────────────────────────
                  _DeliverySection(
                    pickupLabel: cart.items.isNotEmpty
                        ? cart.items.first.restaurantName
                        : '',
                    address: _selectedAddress,
                    onChangeAddress: _chooseAddress,
                  ),
                  SizedBox(height: 20.h),
                  // ── Promo code ───────────────────────────────────────
                  _PromoSection(
                    cart: cart,
                    controller: _promoCtrl,
                    hasError: _promoError,
                    expanded: _promoExpanded,
                    onToggle: () =>
                        setState(() => _promoExpanded = !_promoExpanded),
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
                  _TipSection(cart: cart),
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
                ],
              ),
            ),
            ReceiptSummaryCard(cart: cart, selectedAddress: _selectedAddress),
          ],
        ),
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

// ─── Delivery Section ─────────────────────────────────────────────────────────

class _DeliverySection extends StatelessWidget {
  final String pickupLabel;
  final AddressModel? address;
  final VoidCallback onChangeAddress;

  const _DeliverySection({
    required this.pickupLabel,
    required this.address,
    required this.onChangeAddress,
  });

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'DELIVERY',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              GestureDetector(
                onTap: onChangeAddress,
                child: Text(
                  address == null ? 'Add address' : 'Change',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: context.accentAmber,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 1.5.w,
                    height: 32.h,
                    margin: EdgeInsets.symmetric(vertical: 3.h),
                    color: context.borderColor,
                  ),
                  Icon(
                    SolarIconsBold.mapPoint,
                    size: 14.sp,
                    color: context.accentGreen,
                  ),
                ],
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pickupLabel.isEmpty ? 'Restaurant' : pickupLabel,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: context.textColor,
                      ),
                    ),
                    SizedBox(height: 18.h),
                    if (address != null) ...[
                      Text(
                        address!.label,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: context.textColor,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        address!.line,
                        style: TextStyle(fontSize: 12.sp, color: textMuted),
                      ),
                    ] else
                      Text(
                        'Add a delivery address',
                        style: TextStyle(fontSize: 12.sp, color: textMuted),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddressPickerSheet extends StatefulWidget {
  final List<AddressModel> addresses;
  final AddressModel? selected;

  const _AddressPickerSheet({required this.addresses, required this.selected});

  @override
  State<_AddressPickerSheet> createState() => _AddressPickerSheetState();
}

class _AddressPickerSheetState extends State<_AddressPickerSheet> {
  bool _locating = false;

  Future<void> _useCurrentLocation() async {
    if (_locating) return;
    setState(() => _locating = true);
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enable location services')),
          );
        }
        return;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied')),
          );
        }
        return;
      }
      final pos = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      Navigator.of(context).pop(
        AddressModel(
          label: 'Current Location',
          street:
              '${pos.latitude.toStringAsFixed(4)}, ${pos.longitude.toStringAsFixed(4)}',
          lat: pos.latitude,
          lng: pos.longitude,
        ),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not get your location')),
        );
      }
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final addresses = widget.addresses;
    final selected = widget.selected;

    return SafeArea(
      child: Container(
        margin: EdgeInsets.all(12.w),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Deliver to',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: context.textColor,
              ),
            ),
            SizedBox(height: 12.h),
            if (addresses.isEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Text(
                  'No saved addresses yet.',
                  style: TextStyle(fontSize: 12.sp, color: textMuted),
                ),
              )
            else
              ...addresses.map(
                (a) => GestureDetector(
                  onTap: () => Navigator.of(context).pop(a),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10.h),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: context.cardGrayColor,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color:
                            a.label == selected?.label &&
                                a.line == selected?.line
                            ? primaryColor
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          SolarIconsBold.mapPoint,
                          size: 16.sp,
                          color: primaryColor,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                a.label,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: context.textColor,
                                ),
                              ),
                              Text(
                                a.line,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            SizedBox(height: 6.h),
            OrDivider(
              onTap: _useCurrentLocation,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_locating) ...[
                    SizedBox(
                      width: 12.sp,
                      height: 12.sp,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: primaryColor,
                      ),
                    ),
                  ] else ...[
                    Icon(
                      SolarIconsOutline.gps,
                      size: 13.sp,
                      color: primaryColor,
                    ),
                  ],
                  SizedBox(width: 6.w),
                  Text(
                    'USE MY CURRENT LOCATION',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    SolarIconsOutline.addCircle,
                    size: 14.sp,
                    color: context.textBodyColor,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Add new address',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: context.textBodyColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Tip Section ─────────────────────────────────────────────────────────────

class _TipSection extends StatelessWidget {
  final CartProvider cart;

  const _TipSection({required this.cart});

  static const _tipOptions = [0.0, 2.5, 5.0, 10.0];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🛵', style: TextStyle(fontSize: 28.sp)),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tip for your courier',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: context.textColor,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Goes entirely to your delivery person',
                      style: TextStyle(fontSize: 11.sp, color: textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: _tipOptions.asMap().entries.map((e) {
              final pct = e.value;
              final isLast = e.key == _tipOptions.length - 1;
              final isSelected = cart.tipPercent == pct;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: isLast ? 0 : 8.w),
                  child: GestureDetector(
                    onTap: () =>
                        context.read<CartProvider>().setTipPercent(pct),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: EdgeInsets.symmetric(vertical: 9.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? context.accentAmber
                            : context.cardGrayColor,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        pct == 0 ? '0 %' : '${pct.toStringAsFixed(1)} %',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.white
                              : context.textBodyColor,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
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
