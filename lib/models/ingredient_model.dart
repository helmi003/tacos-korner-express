class IngredientModel {
  final String id;
  final String name;
  final String? image;
  final double price;
  final bool outOfStock;

  const IngredientModel({
    required this.id,
    required this.name,
    this.image,
    this.price = 0.0,
    this.outOfStock = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IngredientModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
