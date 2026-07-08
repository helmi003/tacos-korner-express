import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String? _name;
  String? _email;
  String? _phone;
  String? _avatarUrl;
  bool _isLoggedIn = false;
  int _ordersCount = 0;
  int _favoritesCount = 0;

  String? get name        => _name;
  String? get email       => _email;
  String? get phone       => _phone;
  String? get avatarUrl   => _avatarUrl;
  bool    get isLoggedIn  => _isLoggedIn;
  int     get ordersCount => _ordersCount;
  int     get favoritesCount => _favoritesCount;

  String get initials {
    if (_name == null || _name!.isEmpty) return '?';
    final parts = _name!.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }

  void login({
    required String name,
    required String email,
    String? phone,
    String? avatarUrl,
  }) {
    _name      = name;
    _email     = email;
    _phone     = phone;
    _avatarUrl = avatarUrl;
    _isLoggedIn = true;
    _ordersCount    = 12;
    _favoritesCount = 5;
    notifyListeners();
  }

  void logout() {
    _name      = null;
    _email     = null;
    _phone     = null;
    _avatarUrl = null;
    _isLoggedIn     = false;
    _ordersCount    = 0;
    _favoritesCount = 0;
    notifyListeners();
  }

  void updateProfile({String? name, String? phone, String? avatarUrl}) {
    if (name      != null) _name      = name;
    if (phone     != null) _phone     = phone;
    if (avatarUrl != null) _avatarUrl = avatarUrl;
    notifyListeners();
  }
}
