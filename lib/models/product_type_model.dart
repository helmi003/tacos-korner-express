import 'package:takos_corner_express/models/ingredient_model.dart';

class ProductTypeModel {
  final String id;
  final String name;
  final String message;
  final int min;
  final int max;
  final List<IngredientModel> options;

  const ProductTypeModel({
    required this.id,
    required this.name,
    this.message = '',
    this.min = 0,
    this.max = 1,
    required this.options,
  });

  bool get isRequired => min > 0;
  bool get isSingleChoice => max == 1;
}
