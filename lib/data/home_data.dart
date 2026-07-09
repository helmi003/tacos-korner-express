import 'dart:ui';
import 'package:takos_corner_express/utils/colors.dart';

class Category {
  final String emoji;
  final String label;
  const Category(this.emoji, this.label);
}

class RestaurantModel {
  final String name;
  final String cuisine;
  final double rating;
  final String deliveryTime;
  final double deliveryFee;
  final Color accent;
  final String emoji;
  const RestaurantModel({
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.accent,
    required this.emoji,
  });
}

class PromoModel {
  final String title;
  final String sub;
  final Color color;
  final String emoji;
  const PromoModel({
    required this.title,
    required this.sub,
    required this.color,
    required this.emoji,
  });
}


class ProductModel {
  final String name;
  final String restaurant;
  final double price;
  final double rating;
  final String emoji;
  const ProductModel({
    required this.name,
    required this.restaurant,
    required this.price,
    required this.rating,
    required this.emoji,
  });
}

const categories = [
  Category('🌮', 'Tacos'),
  Category('🍔', 'Burgers'),
  Category('🍕', 'Pizza'),
  Category('🍣', 'Sushi'),
  Category('🥗', 'Salads'),
  Category('🍜', 'Noodles'),
  Category('🥤', 'Drinks'),
  Category('🍦', 'Desserts'),
];

const restaurants = [
  RestaurantModel(
    name: 'El Rancho Tacos',
    cuisine: 'Mexican • Tacos • Burritos',
    rating: 4.8,
    deliveryTime: '20–30 min',
    deliveryFee: 1.50,
    accent: primaryColor,
    emoji: '🌮',
  ),
  RestaurantModel(
    name: 'Burger Craft',
    cuisine: 'American • Burgers • Fries',
    rating: 4.6,
    deliveryTime: '25–35 min',
    deliveryFee: 2.00,
    accent: accentAmber,
    emoji: '🍔',
  ),
  RestaurantModel(
    name: 'Sakura Sushi',
    cuisine: 'Japanese • Sushi • Ramen',
    rating: 4.9,
    deliveryTime: '30–45 min',
    deliveryFee: 2.50,
    accent: accentBlue,
    emoji: '🍣',
  ),
  RestaurantModel(
    name: 'La Bella Pizza',
    cuisine: 'Italian • Pizza • Pasta',
    rating: 4.5,
    deliveryTime: '20–30 min',
    deliveryFee: 1.00,
    accent: accentGreen,
    emoji: '🍕',
  ),
];

const products = [
  ProductModel(
    name: 'Crispy Chicken Taco',
    restaurant: 'El Rancho',
    price: 6.50,
    rating: 4.9,
    emoji: '🌮',
  ),
  ProductModel(
    name: 'Double Smash Burger',
    restaurant: 'Burger Craft',
    price: 9.90,
    rating: 4.8,
    emoji: '🍔',
  ),
  ProductModel(
    name: 'Spicy Tuna Roll',
    restaurant: 'Sakura Sushi',
    price: 12.00,
    rating: 4.7,
    emoji: '🍣',
  ),
  ProductModel(
    name: 'Margherita Pizza',
    restaurant: 'La Bella Pizza',
    price: 11.50,
    rating: 4.6,
    emoji: '🍕',
  ),
  ProductModel(
    name: 'Loaded Nachos',
    restaurant: 'El Rancho Tacos',
    price: 7.80,
    rating: 4.5,
    emoji: '🧀',
  ),
  ProductModel(
    name: 'Açaí Bowl',
    restaurant: 'Fresh Bar',
    price: 8.90,
    rating: 4.9,
    emoji: '🫐',
  ),
];

const promos = [
  PromoModel(
    title: '30% OFF',
    sub: 'Your first order',
    color: primaryColor,
    emoji: '🎉',
  ),
  PromoModel(
    title: 'Free Delivery',
    sub: 'Orders above \$20',
    color: secondaryColor,
    emoji: '🚀',
  ),
  PromoModel(
    title: 'Combo Deal',
    sub: 'Burger + Fries + Drink',
    color: accentAmber,
    emoji: '🍔',
  ),
];