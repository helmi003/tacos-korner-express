class AddressModel {
  final String label;
  final String street;
  final String city;
  final String state;
  final String country;
  final double? lat;
  final double? lng;
  final bool isDefault;

  const AddressModel({
    required this.label,
    required this.street,
    this.city = '',
    this.state = '',
    this.country = '',
    this.lat,
    this.lng,
    this.isDefault = false,
  });

  String get line => [
    street,
    city,
    state,
    country,
  ].where((part) => part.trim().isNotEmpty).join(', ');

  AddressModel copyWith({
    String? label,
    String? street,
    String? city,
    String? state,
    String? country,
    double? lat,
    double? lng,
    bool? isDefault,
  }) {
    return AddressModel(
      label: label ?? this.label,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
