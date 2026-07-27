import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:takos_corner_express/data/home_data.dart';
import 'package:takos_corner_express/models/ingredient_model.dart';
import 'package:takos_corner_express/models/product_type_model.dart';
import 'package:takos_corner_express/screens/restaurants/restaurant_details_screen.dart';
import 'package:takos_corner_express/services/cart_provider.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/custom_cashed_image.dart';
import 'package:takos_corner_express/widgets/global/custom_snackbar.dart';
import 'package:takos_corner_express/widgets/products/product_hero_widget.dart';
import 'package:takos_corner_express/widgets/products/qty_stepper.dart';

class ProductCustomizerScreen extends StatefulWidget {
  static const routeName = '/ProductCustomizerScreen';
  final ProductModel product;
  final String? editCartItemId;
  final int? initialQty;
  final Map<String, List<IngredientModel>>? initialSelections;

  const ProductCustomizerScreen({
    super.key,
    required this.product,
    this.editCartItemId,
    this.initialQty,
    this.initialSelections,
  });

  @override
  State<ProductCustomizerScreen> createState() =>
      _ProductCustomizerScreenState();
}

class _ProductCustomizerScreenState extends State<ProductCustomizerScreen> {
  final Map<String, List<IngredientModel>> _selections = {};
  int _qty = 1;
  bool _isFav = false;

  @override
  void initState() {
    super.initState();
    _qty = widget.initialQty ?? 1;
    for (final type in widget.product.types) {
      _selections[type.id] = List.from(
        widget.initialSelections?[type.id] ?? [],
      );
    }
  }

  double get _extrasTotal => _selections.values
      .expand((list) => list)
      .fold(0.0, (sum, i) => sum + i.price);

  double get _unitTotal => widget.product.price + _extrasTotal;
  double get _grandTotal => _unitTotal * _qty;

  bool get _isValid {
    for (final type in widget.product.types) {
      if (type.isRequired) {
        final count = (_selections[type.id] ?? []).length;
        if (count < type.min) return false;
      }
    }
    return true;
  }

  void _toggle(ProductTypeModel type, IngredientModel ingredient) {
    final current = List<IngredientModel>.from(_selections[type.id] ?? []);

    if (type.isSingleChoice) {
      if (current.contains(ingredient)) {
        if (!type.isRequired) current.clear();
      } else {
        current
          ..clear()
          ..add(ingredient);
      }
    } else {
      if (current.contains(ingredient)) {
        current.remove(ingredient);
      } else if (current.length < type.max) {
        current.add(ingredient);
      } else {
        HapticFeedback.heavyImpact();
        CustomSnackbar.show(
          context,
          message: 'You can only pick ${type.max} from "${type.name}"',
          type: SnackbarType.warning,
        );
        return;
      }
    }

    setState(() => _selections[type.id] = current);
  }

  void _addToCart() {
    if (!_isValid) {
      HapticFeedback.heavyImpact();
      CustomSnackbar.show(
        context,
        message: 'Please complete all required selections',
        type: SnackbarType.error,
      );
      return;
    }

    final customizations = widget.product.types
        .where((t) => (_selections[t.id] ?? []).isNotEmpty)
        .map(
          (t) => CartCustomization(
            typeId: t.id,
            typeName: t.name,
            selected: List.from(_selections[t.id]!),
          ),
        )
        .toList();

    final isEdit = widget.editCartItemId != null;

    final cartItem = CartItem(
      id: isEdit
          ? widget.editCartItemId!
          : '${widget.product.name}_${DateTime.now().millisecondsSinceEpoch}',
      name: widget.product.name,
      description: widget.product.description,
      price: _unitTotal,
      imageUrl: widget.product.image,
      restaurantName: '',
      customizations: customizations,
      product: widget.product,
      quantity: _qty,
    );

    if (isEdit) {
      context.read<CartProvider>().replaceItem(
        widget.editCartItemId!,
        cartItem,
      );
    } else {
      context.read<CartProvider>().addItem(cartItem);
    }

    HapticFeedback.mediumImpact();
    CustomSnackbar.show(
      context,
      message: isEdit
          ? '${widget.product.name} updated'
          : '${widget.product.name} added to cart',
      type: SnackbarType.success,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final restaurant = restaurantOf(product);
    return Scaffold(
      body: Column(
        children: [
          ProductHeroWidget(
            product: product,
            isFav: _isFav,
            onFavToggle: () => setState(() => _isFav = !_isFav),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 20.h,
                bottom: 16.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProductHeader(product: product, extrasTotal: _extrasTotal),
                  SizedBox(height: 16.h),
                  Text(
                    'AVAILABLE AT',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: textMuted,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            RestaurantDetailsScreen(restaurant: restaurant),
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: context.cardColor,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: context.borderColor,
                          width: 0.5,
                        ),
                        boxShadow: context.shadows,
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: CustomCashedImage(
                              restaurant.image,
                              width: 48.w,
                              height: 48.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  restaurant.name,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                    color: context.textColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    Icon(
                                      SolarIconsBold.mapPoint,
                                      size: 11.sp,
                                      color: context.textMutedColor,
                                    ),
                                    SizedBox(width: 3.w),
                                    Expanded(
                                      child: Text(
                                        restaurant.zone,
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: context.textMutedColor,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Icon(
                                      SolarIconsBold.start1,
                                      size: 11.sp,
                                      color: context.accentAmber,
                                    ),
                                    SizedBox(width: 3.w),
                                    Text(
                                      '${restaurant.rating}',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w600,
                                        color: context.textColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Icon(
                            SolarIconsOutline.altArrowRight,
                            size: 16.sp,
                            color: context.textMutedColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  ...widget.product.types.map(
                    (type) => _TypeSection(
                      type: type,
                      selected: _selections[type.id] ?? [],
                      onToggle: (ingredient) => _toggle(type, ingredient),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _BottomBar(
            qty: _qty,
            grandTotal: _grandTotal,
            isValid: _isValid,
            isEditMode: widget.editCartItemId != null,
            onDecrement: () {
              if (_qty > 1) setState(() => _qty--);
            },
            onIncrement: () => setState(() => _qty++),
            onAddToCart: _addToCart,
          ),
        ],
      ),
    );
  }
}

class _ProductHeader extends StatelessWidget {
  const _ProductHeader({required this.product, required this.extrasTotal});
  final ProductModel product;
  final double extrasTotal;

  @override
  Widget build(BuildContext context) {
    final unitTotal = product.price + extrasTotal;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: TextStyle(
                  fontSize: 19.sp,
                  fontWeight: FontWeight.w800,
                  color: context.textColor,
                ),
              ),
              SizedBox(height: 4.h),
              if (product.description.isNotEmpty)
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: textMuted,
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${unitTotal.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: primaryColor,
              ),
            ),
            if (extrasTotal > 0)
              Text(
                'incl. \$${extrasTotal.toStringAsFixed(2)} extras',
                style: TextStyle(fontSize: 9.sp, color: textMuted),
              ),
          ],
        ),
      ],
    );
  }
}

class _TypeSection extends StatelessWidget {
  const _TypeSection({
    required this.type,
    required this.selected,
    required this.onToggle,
  });

  final ProductTypeModel type;
  final List<IngredientModel> selected;
  final ValueChanged<IngredientModel> onToggle;

  @override
  Widget build(BuildContext context) {
    final count = selected.length;
    final isFulfilled = !type.isRequired || count >= type.min;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type.name,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: context.textColor,
                      ),
                    ),
                    if (type.message.isNotEmpty)
                      Text(
                        type.message,
                        style: TextStyle(fontSize: 11.sp, color: textMuted),
                      ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 3.5.h),
                decoration: BoxDecoration(
                  color: type.isRequired
                      ? (isFulfilled
                            ? context.accentGreenBgColor
                            : context.accentRedBgColor)
                      : context.cardGrayColor,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (type.isRequired && isFulfilled)
                      Padding(
                        padding: EdgeInsets.only(right: 3.w),
                        child: Icon(
                          SolarIconsBold.checkCircle,
                          size: 10.sp,
                          color: context.accentGreen,
                        ),
                      ),
                    Text(
                      type.isRequired
                          ? (isFulfilled ? 'Done' : 'Required')
                          : 'Optional',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: type.isRequired
                            ? (isFulfilled ? context.accentGreen : danger)
                            : context.textMutedColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (!type.isSingleChoice) ...[
                SizedBox(width: 6.w),
                Text(
                  '$count/${type.max}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: count >= type.max
                        ? primaryColor
                        : context.textMutedColor,
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: type.options.map((ingredient) {
              final isSelected = selected.contains(ingredient);
              final isDisabled =
                  ingredient.outOfStock ||
                  (!isSelected && !type.isSingleChoice && count >= type.max);
              return _OptionChip(
                ingredient: ingredient,
                isSelected: isSelected,
                isDisabled: isDisabled,
                onTap: isDisabled ? null : () => onToggle(ingredient),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _OptionChip extends StatelessWidget {
  const _OptionChip({
    required this.ingredient,
    required this.isSelected,
    required this.isDisabled,
    this.onTap,
  });

  final IngredientModel ingredient;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withValues(alpha: 0.08)
              : isDisabled
              ? context.cardGrayColor
              : context.cardColor,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: isSelected ? primaryColor : context.borderColor,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              Padding(
                padding: EdgeInsets.only(right: 5.w),
                child: Icon(
                  SolarIconsBold.checkCircle,
                  size: 12.sp,
                  color: primaryColor,
                ),
              ),
            Text(
              ingredient.name,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? primaryColor
                    : isDisabled
                    ? context.textMutedColor
                    : context.textBodyColor,
              ),
            ),
            if (ingredient.price > 0) ...[
              SizedBox(width: 5.w),
              Text(
                '+\$${ingredient.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? primaryColor : textMuted,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.qty,
    required this.grandTotal,
    required this.isValid,
    required this.isEditMode,
    required this.onDecrement,
    required this.onIncrement,
    required this.onAddToCart,
  });

  final int qty;
  final double grandTotal;
  final bool isValid;
  final bool isEditMode;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16.w,
        12.h,
        16.w,
        MediaQuery.of(context).padding.bottom + 12.h,
      ),
      decoration: BoxDecoration(
        color: context.cardColor,
        border: Border(top: BorderSide(color: context.borderColor, width: 0.5)),
      ),
      child: Row(
        children: [
          QtyStepper(
            qty: qty,
            onDecrement: onDecrement,
            onIncrement: onIncrement,
            iconSize: 20,
            useIconButton: true,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: GestureDetector(
              onTap: isValid ? onAddToCart : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 13.h),
                decoration: BoxDecoration(
                  gradient: isValid ? primaryGradient : null,
                  color: isValid ? null : textMuted.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isEditMode
                          ? SolarIconsBold.pen2
                          : SolarIconsBold.cartLarge2,
                      size: 17.sp,
                      color: isValid ? Colors.white : textMuted,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      isEditMode ? 'Update Cart' : 'Add to Cart',
                      style: TextStyle(
                        color: isValid ? Colors.white : textMuted,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: isValid
                            ? Colors.white.withValues(alpha: 0.22)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        '\$${grandTotal.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: isValid ? Colors.white : textMuted,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
