import 'package:flutter/material.dart';
import 'package:takos_corner_express/models/address_model.dart';
import 'package:takos_corner_express/utils/enums.dart';

class UserProvider extends ChangeNotifier {
  String? _name;
  String? _email;
  String? _phone;
  String? _avatarUrl;
  bool _isLoggedIn = false;
  int _ordersCount = 0;
  DateTime? _dateOfBirth;
  Gender _gender = Gender.preferNotToSay;
  List<String> _allergies = [];
  List<AddressModel> _addresses = [];

  String? get name => _name;
  String? get email => _email;
  String? get phone => _phone;
  String? get avatarUrl => _avatarUrl;
  bool get isLoggedIn => _isLoggedIn;
  int get ordersCount => _ordersCount;
  DateTime? get dateOfBirth => _dateOfBirth;
  Gender get gender => _gender;
  List<String> get allergies => List.unmodifiable(_allergies);
  List<AddressModel> get addresses => List.unmodifiable(_addresses);

  AddressModel? get defaultAddress {
    if (_addresses.isEmpty) return null;
    return _addresses.firstWhere(
      (a) => a.isDefault,
      orElse: () => _addresses.first,
    );
  }

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
    DateTime? dateOfBirth,
    Gender gender = Gender.preferNotToSay,
    List<String> allergies = const [],
    List<AddressModel> addresses = const [],
  }) {
    _name = name;
    _email = email;
    _phone = phone;
    _avatarUrl = avatarUrl;
    _isLoggedIn = true;
    _ordersCount = 12;
    _dateOfBirth = dateOfBirth;
    _gender = gender;
    _allergies = List.of(allergies);
    _addresses = List.of(addresses);
    notifyListeners();
  }

  void logout() {
    _name = null;
    _email = null;
    _phone = null;
    _avatarUrl = null;
    _isLoggedIn = false;
    _ordersCount = 0;
    _dateOfBirth = null;
    _gender = Gender.preferNotToSay;
    _allergies = [];
    _addresses = [];
    notifyListeners();
  }

  void updateProfile({
    String? name,
    String? phone,
    String? avatarUrl,
    DateTime? dateOfBirth,
    Gender? gender,
    List<String>? allergies,
    List<AddressModel>? addresses,
  }) {
    if (name != null) _name = name;
    if (phone != null) _phone = phone;
    if (avatarUrl != null) _avatarUrl = avatarUrl;
    if (dateOfBirth != null) _dateOfBirth = dateOfBirth;
    if (gender != null) _gender = gender;
    if (allergies != null) _allergies = List.of(allergies);
    if (addresses != null) _addresses = List.of(addresses);
    notifyListeners();
  }
}
