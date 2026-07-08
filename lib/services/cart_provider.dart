import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String restaurantName;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.restaurantName,
    this.quantity = 1,
  });

  double get total => price * quantity;
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  String _promoCode = '';
  double _discount = 0;
  static const double _deliveryFee = 2.50;

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  String get promoCode => _promoCode;
  double get discount => _discount;
  double get deliveryFee => _deliveryFee;

  double get subtotal =>
      _items.fold(0, (sum, item) => sum + item.total);

  double get total => (subtotal + _deliveryFee - _discount).clamp(0, double.infinity);

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
