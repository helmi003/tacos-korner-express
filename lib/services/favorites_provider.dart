import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {
  static const _productKey = 'favorite_products';
  static const _restaurantKey = 'favorite_restaurants';

  Set<String> _productNames = {};
  Set<int> _restaurantIds = {};

  Set<String> get favoriteProductNames => Set.unmodifiable(_productNames);
  Set<int> get favoriteRestaurantIds => Set.unmodifiable(_restaurantIds);
  int get count => _productNames.length + _restaurantIds.length;

  FavoritesProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _productNames = (prefs.getStringList(_productKey) ?? []).toSet();
    _restaurantIds = (prefs.getStringList(_restaurantKey) ?? [])
        .map(int.parse)
        .toSet();
    notifyListeners();
  }

  bool isProductFavorite(String name) => _productNames.contains(name);
  bool isRestaurantFavorite(int id) => _restaurantIds.contains(id);

  Future<void> toggleProduct(String name) async {
    if (_productNames.contains(name)) {
      _productNames = {..._productNames}..remove(name);
    } else {
      _productNames = {..._productNames, name};
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_productKey, _productNames.toList());
  }

  Future<void> toggleRestaurant(int id) async {
    if (_restaurantIds.contains(id)) {
      _restaurantIds = {..._restaurantIds}..remove(id);
    } else {
      _restaurantIds = {..._restaurantIds, id};
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _restaurantKey,
      _restaurantIds.map((e) => e.toString()).toList(),
    );
  }
}
