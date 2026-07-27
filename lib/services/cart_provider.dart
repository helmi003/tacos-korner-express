import 'package:flutter/material.dart';
import 'package:takos_corner_express/data/home_data.dart';
import 'package:takos_corner_express/models/ingredient_model.dart';

class CartCustomization {
  final String typeId;
  final String typeName;
  final List<IngredientModel> selected;

  const CartCustomization({
    required this.typeId,
    required this.typeName,
    required this.selected,
  });

  double get extraCost => selected.fold(0.0, (sum, item) => sum + item.price);

  String get summary => selected.map((i) => i.name).join(', ');
}

class CartItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String restaurantName;
  final List<CartCustomization> customizations;
  final ProductModel? product;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.restaurantName,
    this.customizations = const [],
    this.product,
    this.quantity = 1,
  });

  /// Unit price = base price + all customization extras
  double get unitTotal =>
      price + customizations.fold(0.0, (sum, c) => sum + c.extraCost);

  double get total => unitTotal * quantity;

  /// Human-readable customization summary for cart display
  String get customizationSummary {
    if (customizations.isEmpty) return description;
    final parts = customizations
        .where((c) => c.selected.isNotEmpty)
        .map((c) => c.summary);
    return parts.join(' · ');
  }
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  final List<CartItem> _savedCombos = [];
  String _promoCode = '';
  double _discount = 0;
  double _tipPercent = 0;
  String _note = '';

  static const double _deliveryFee = 0.500;
  static const double _serviceFee = 3.000;

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  String get promoCode => _promoCode;
  double get discount => _discount;
  double get deliveryFee => _deliveryFee;
  double get serviceFee => _serviceFee;
  double get tipPercent => _tipPercent;
  double get tipAmount => subtotal * (_tipPercent / 100);
  String get note => _note;

  List<CartItem> get savedCombos => List.unmodifiable(_savedCombos);

  bool isComboSaved(CartItem item) => _savedCombos.any(
    (s) =>
        s.name == item.name &&
        s.customizationSummary == item.customizationSummary,
  );

  void saveCombo(CartItem item) {
    if (!isComboSaved(item)) {
      _savedCombos.add(
        CartItem(
          id: 'saved_${item.name}_${DateTime.now().millisecondsSinceEpoch}',
          name: item.name,
          description: item.description,
          price: item.price,
          imageUrl: item.imageUrl,
          restaurantName: item.restaurantName,
          customizations: List.from(item.customizations),
        ),
      );
      notifyListeners();
    }
  }

  void removeSavedCombo(String name, String summary) {
    _savedCombos.removeWhere(
      (s) => s.name == name && s.customizationSummary == summary,
    );
    notifyListeners();
  }

  void addSavedComboToCart(CartItem saved) {
    addItem(
      CartItem(
        id: '${saved.name}_${DateTime.now().millisecondsSinceEpoch}',
        name: saved.name,
        description: saved.description,
        price: saved.price,
        imageUrl: saved.imageUrl,
        restaurantName: saved.restaurantName,
        customizations: List.from(saved.customizations),
      ),
    );
  }

  double get subtotal => _items.fold(0, (sum, item) => sum + item.total);

  double get total =>
      (subtotal + _deliveryFee + _serviceFee + tipAmount - _discount).clamp(
        0,
        double.infinity,
      );

  void setTipPercent(double percent) {
    _tipPercent = percent;
    notifyListeners();
  }

  /// Updated silently — note is read at checkout time, no rebuild needed.
  void setNote(String note) {
    _note = note;
  }

  void addItem(CartItem item) {
    final existing = _items.indexWhere((i) => i.id == item.id);
    if (existing >= 0) {
      _items[existing].quantity++;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((i) => i.id == id);
    notifyListeners();
  }

  void replaceItem(String id, CartItem newItem) {
    final idx = _items.indexWhere((i) => i.id == id);
    if (idx < 0) return;
    _items[idx] = newItem;
    notifyListeners();
  }

  void decrementItem(String id) {
    final idx = _items.indexWhere((i) => i.id == id);
    if (idx < 0) return;
    if (_items[idx].quantity <= 1) {
      _items.removeAt(idx);
    } else {
      _items[idx].quantity--;
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _promoCode = '';
    _discount = 0;
    _note = '';
    notifyListeners();
  }

  bool applyPromoCode(String code) {
    final upper = code.trim().toUpperCase();
    if (upper == 'TACO10') {
      _promoCode = upper;
      _discount = subtotal * 0.10;
      notifyListeners();
      return true;
    } else if (upper == 'WELCOME') {
      _promoCode = upper;
      _discount = 3.00;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removePromoCode() {
    _promoCode = '';
    _discount = 0;
    notifyListeners();
  }
}
