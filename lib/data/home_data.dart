import 'dart:ui';
import 'package:takos_corner_express/models/ingredient_model.dart';
import 'package:takos_corner_express/models/product_type_model.dart';
import 'package:takos_corner_express/utils/colors.dart';

class Category {
  final String emoji;
  final String label;
  const Category(this.emoji, this.label);
}

class RestaurantModel {
  final int id;
  final String name;
  final String cuisine;
  final double rating;
  final int reviews;
  final String deliveryTime;
  final double deliveryFee;
  final String zone;
  final bool isOpen;
  final String image;
  final double lat;
  final double lng;
  final String address;
  final String phone;
  const RestaurantModel({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.reviews,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.zone,
    required this.isOpen,
    required this.image,
    required this.lat,
    required this.lng,
    required this.address,
    required this.phone,
  });
}

class PromoModel {
  final String title;
  final String sub;
  final Color color;
  final String image;
  final String cta;
  const PromoModel({
    required this.title,
    required this.sub,
    required this.color,
    required this.image,
    this.cta = 'Order Now',
  });
}

class ProductModel {
  final String name;
  final String description;
  final double price;
  final double rating;
  final int reviews;
  final bool isNew;
  final bool isFeatured;
  final String image;
  final String category;
  final int restaurantId;
  final bool isCustomizable;
  final List<ProductTypeModel> types;
  final List<String> allergens;

  const ProductModel({
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.isNew,
    required this.isFeatured,
    required this.image,
    required this.category,
    required this.restaurantId,
    this.isCustomizable = false,
    this.types = const [],
    this.allergens = const [],
  });
}

RestaurantModel restaurantOf(ProductModel product) =>
    restaurants.firstWhere((r) => r.id == product.restaurantId);

const allergensList = [
  'Gluten',
  'Dairy',
  'Nuts',
  'Peanuts',
  'Shellfish',
  'Fish',
  'Egg',
  'Soy',
];

const categories = [
  Category('✨', 'All'),
  Category('🌮', 'Tacos'),
  Category('🍔', 'Burgers'),
  Category('🍕', 'Pizza'),
  Category('🍣', 'Sushi'),
  Category('🥗', 'Salads'),
  Category('🍜', 'Noodles'),
  Category('🥤', 'Drinks'),
  Category('🍦', 'Desserts'),
  Category('🍝', 'Pasta'),
  Category('🍗', 'Chicken'),
];

const restaurants = [
  RestaurantModel(
    id: 1,
    name: 'Smash & Stack',
    cuisine: 'Burgers · American',
    rating: 4.8,
    reviews: 534,
    deliveryTime: '20–30 min',
    deliveryFee: 1.99,
    zone: 'Centre-Ville',
    isOpen: true,
    image:
        'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=400&q=80',
    lat: 36.7992,
    lng: 10.1817,
    address: 'Avenue Habib Bourguiba, Centre-Ville, Tunis',
    phone: '+216 71 234 501',
  ),
  RestaurantModel(
    id: 2,
    name: 'Sushi Omakase',
    cuisine: 'Sushi · Japanese',
    rating: 4.9,
    reviews: 412,
    deliveryTime: '30–45 min',
    deliveryFee: 2.49,
    zone: 'Lac 1',
    isOpen: true,
    image:
        'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=400&q=80',
    lat: 36.8375,
    lng: 10.2408,
    address: 'Rue du Lac Léman, Les Berges du Lac 1, Tunis',
    phone: '+216 71 234 502',
  ),
  RestaurantModel(
    id: 3,
    name: "Luigi's Pizzeria",
    cuisine: 'Pizza · Italian',
    rating: 4.7,
    reviews: 721,
    deliveryTime: '25–35 min',
    deliveryFee: 0,
    zone: 'Lac 2',
    isOpen: true,
    image:
        'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=400&q=80',
    lat: 36.8447,
    lng: 10.2650,
    address: 'Rue du Lac Malaren, Les Berges du Lac 2, Tunis',
    phone: '+216 71 234 503',
  ),
  RestaurantModel(
    id: 4,
    name: 'Taco Loco',
    cuisine: 'Tacos · Mexican',
    rating: 4.6,
    reviews: 309,
    deliveryTime: '15–25 min',
    deliveryFee: 1.49,
    zone: 'La Marsa',
    isOpen: true,
    image:
        'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=400&q=80',
    lat: 36.8782,
    lng: 10.3247,
    address: 'Avenue Habib Bourguiba, La Marsa, Tunis',
    phone: '+216 71 234 504',
  ),
  RestaurantModel(
    id: 5,
    name: 'Green Bowl',
    cuisine: 'Salads · Healthy',
    rating: 4.5,
    reviews: 198,
    deliveryTime: '20–30 min',
    deliveryFee: 1.99,
    zone: 'Carthage',
    isOpen: true,
    image:
        'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&q=80',
    lat: 36.8528,
    lng: 10.3233,
    address: 'Rue de Carthage, Carthage, Tunis',
    phone: '+216 71 234 505',
  ),
  RestaurantModel(
    id: 6,
    name: 'Pasta Madre',
    cuisine: 'Pasta · Italian',
    rating: 4.8,
    reviews: 445,
    deliveryTime: '30–40 min',
    deliveryFee: 2.99,
    zone: 'Sidi Bou Said',
    isOpen: false,
    image:
        'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=400&q=80',
    lat: 36.8703,
    lng: 10.3418,
    address: 'Rue Sidi Bou Said, Sidi Bou Said, Tunis',
    phone: '+216 71 234 506',
  ),
  RestaurantModel(
    id: 7,
    name: 'The Fried Chicken House',
    cuisine: 'Chicken · American',
    rating: 4.7,
    reviews: 376,
    deliveryTime: '20–30 min',
    deliveryFee: 1.49,
    zone: 'Ariana',
    isOpen: true,
    image:
        'https://images.unsplash.com/photo-1527477396000-e27163b481c2?w=400&q=80',
    lat: 36.8625,
    lng: 10.1956,
    address: 'Avenue Ennasr, Ariana, Tunis',
    phone: '+216 71 234 507',
  ),
  RestaurantModel(
    id: 8,
    name: 'Dessert Lab',
    cuisine: 'Desserts · Café',
    rating: 4.9,
    reviews: 612,
    deliveryTime: '15–20 min',
    deliveryFee: 0.99,
    zone: 'Le Bardo',
    isOpen: true,
    image:
        'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400&q=80',
    lat: 36.8092,
    lng: 10.1397,
    address: 'Rue du Bardo, Le Bardo, Tunis',
    phone: '+216 71 234 508',
  ),
  RestaurantModel(
    id: 9,
    name: 'Dragon Wok',
    cuisine: 'Asian · Fusion',
    rating: 4.6,
    reviews: 271,
    deliveryTime: '25–35 min',
    deliveryFee: 2.99,
    zone: 'Menzah',
    isOpen: true,
    image:
        'https://images.unsplash.com/photo-1617196034183-421b4040ed20?w=400&q=80',
    lat: 36.8397,
    lng: 10.1608,
    address: 'Avenue Fattouma Bourguiba, El Menzah, Tunis',
    phone: '+216 71 234 509',
  ),
  RestaurantModel(
    id: 10,
    name: 'The Juice Bar',
    cuisine: 'Drinks · Healthy',
    rating: 4.5,
    reviews: 152,
    deliveryTime: '10–15 min',
    deliveryFee: 0,
    zone: 'Ennasr',
    isOpen: true,
    image:
        'https://images.unsplash.com/photo-1570197788417-0e82375c9371?w=400&q=80',
    lat: 36.8508,
    lng: 10.1780,
    address: 'Rue du Lac Constance, Ennasr, Tunis',
    phone: '+216 71 234 510',
  ),
  RestaurantModel(
    id: 11,
    name: 'Baja Fish Shack',
    cuisine: 'Seafood · Mexican',
    rating: 4.6,
    reviews: 218,
    deliveryTime: '20–30 min',
    deliveryFee: 1.99,
    zone: 'Manar',
    isOpen: true,
    image:
        'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=400&q=80',
    lat: 36.8324,
    lng: 10.1500,
    address: 'Avenue de la Bourse, El Manar, Tunis',
    phone: '+216 71 234 511',
  ),
  RestaurantModel(
    id: 12,
    name: 'Truffle & Co.',
    cuisine: 'Gourmet · American',
    rating: 4.8,
    reviews: 389,
    deliveryTime: '35–50 min',
    deliveryFee: 3.49,
    zone: 'Tunis-Carthage Airport',
    isOpen: false,
    image:
        'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?w=400&q=80',
    lat: 36.8510,
    lng: 10.2272,
    address: "Route de l'Aéroport, Tunis-Carthage, Tunis",
    phone: '+216 71 234 512',
  ),
];

const products = [
  // ── Burgers (customizable) ───────────────────────────────────────────────
  ProductModel(
    name: 'Classic Smash Burger',
    description:
        'Juicy double smash patty with cheddar, pickles, and our secret sauce.',
    price: 12.99,
    rating: 4.8,
    reviews: 234,
    isNew: true,
    isFeatured: true,
    image:
        'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300&q=80',
    category: 'Burgers',
    restaurantId: 1,
    allergens: ['Gluten', 'Dairy'],
    isCustomizable: true,
    types: [
      ProductTypeModel(
        id: 'burger-size',
        name: 'Choose Size',
        message: 'Select one size',
        min: 1,
        max: 1,
        options: [
          IngredientModel(id: 'size-single', name: 'Single', price: 0),
          IngredientModel(id: 'size-double', name: 'Double', price: 2.50),
          IngredientModel(id: 'size-triple', name: 'Triple', price: 4.50),
        ],
      ),
      ProductTypeModel(
        id: 'burger-sauce',
        name: 'Choose Sauce',
        message: 'Pick your favourite',
        min: 1,
        max: 1,
        options: [
          IngredientModel(id: 'sauce-secret', name: 'Secret Sauce', price: 0),
          IngredientModel(id: 'sauce-bbq', name: 'BBQ', price: 0),
          IngredientModel(id: 'sauce-chipotle', name: 'Chipotle', price: 0),
          IngredientModel(id: 'sauce-mustard', name: 'Mustard', price: 0),
        ],
      ),
      ProductTypeModel(
        id: 'burger-toppings',
        name: 'Add Toppings',
        message: 'Up to 4 extras',
        min: 0,
        max: 4,
        options: [
          IngredientModel(id: 'top-cheese', name: 'Cheddar', price: 0.80),
          IngredientModel(id: 'top-bacon', name: 'Bacon', price: 1.50),
          IngredientModel(id: 'top-jalapen', name: 'Jalapeños', price: 0.50),
          IngredientModel(id: 'top-avocado', name: 'Avocado', price: 1.20),
          IngredientModel(id: 'top-egg', name: 'Fried Egg', price: 1.00),
          IngredientModel(id: 'top-mushroom', name: 'Mushrooms', price: 0.80),
          IngredientModel(
            id: 'top-onion',
            name: 'Caramelised Onion',
            price: 0.60,
          ),
        ],
      ),
    ],
  ),
  ProductModel(
    name: 'Spicy Chipotle Burger',
    description: 'Fiery chipotle aioli, pepper jack cheese, and jalapeños.',
    price: 13.50,
    rating: 4.7,
    reviews: 187,
    isNew: false,
    isFeatured: true,
    image:
        'https://images.unsplash.com/photo-1553979459-d2229ba7433b?w=300&q=80',
    category: 'Burgers',
    restaurantId: 1,
    allergens: ['Gluten', 'Dairy'],
    isCustomizable: true,
    types: [
      ProductTypeModel(
        id: 'chipotle-size',
        name: 'Choose Size',
        message: 'Select one size',
        min: 1,
        max: 1,
        options: [
          IngredientModel(id: 'csize-single', name: 'Single', price: 0),
          IngredientModel(id: 'csize-double', name: 'Double', price: 2.50),
        ],
      ),
      ProductTypeModel(
        id: 'chipotle-heat',
        name: 'Spice Level',
        message: 'How hot can you go?',
        min: 1,
        max: 1,
        options: [
          IngredientModel(id: 'heat-mild', name: 'Mild', price: 0),
          IngredientModel(id: 'heat-medium', name: 'Medium', price: 0),
          IngredientModel(id: 'heat-hot', name: 'Hot 🔥', price: 0),
          IngredientModel(id: 'heat-xhot', name: 'Extra Hot 🔥🔥', price: 0),
        ],
      ),
      ProductTypeModel(
        id: 'chipotle-extras',
        name: 'Add Extras',
        message: 'Optional add-ons',
        min: 0,
        max: 3,
        options: [
          IngredientModel(id: 'cex-cheese', name: 'Pepper Jack', price: 0.80),
          IngredientModel(id: 'cex-bacon', name: 'Bacon', price: 1.50),
          IngredientModel(id: 'cex-guac', name: 'Guacamole', price: 1.20),
          IngredientModel(
            id: 'cex-jalap',
            name: 'Extra Jalapeños',
            price: 0.50,
          ),
        ],
      ),
    ],
  ),

  // ── Pizza (customizable) ──────────────────────────────────────────────────
  ProductModel(
    name: 'Margherita Classica',
    description:
        'San Marzano tomato, fresh mozzarella, basil, extra virgin olive oil.',
    price: 14.00,
    rating: 4.9,
    reviews: 412,
    isNew: false,
    isFeatured: true,
    image:
        'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=300&q=80',
    category: 'Pizza',
    restaurantId: 3,
    allergens: ['Gluten', 'Dairy'],
    isCustomizable: true,
    types: [
      ProductTypeModel(
        id: 'marg-crust',
        name: 'Choose Crust',
        message: 'Select your base',
        min: 1,
        max: 1,
        options: [
          IngredientModel(id: 'crust-thin', name: 'Thin Crust', price: 0),
          IngredientModel(id: 'crust-classic', name: 'Classic', price: 0),
          IngredientModel(id: 'crust-thick', name: 'Thick Crust', price: 1.00),
          IngredientModel(
            id: 'crust-stuffed',
            name: 'Stuffed Crust',
            price: 2.50,
          ),
        ],
      ),
      ProductTypeModel(
        id: 'marg-sauce',
        name: 'Sauce',
        message: 'Base sauce',
        min: 1,
        max: 1,
        options: [
          IngredientModel(id: 'psauce-tomato', name: 'Tomato', price: 0),
          IngredientModel(id: 'psauce-white', name: 'White Cream', price: 0),
          IngredientModel(id: 'psauce-pesto', name: 'Pesto', price: 0.50),
        ],
      ),
      ProductTypeModel(
        id: 'marg-toppings',
        name: 'Choose Toppings',
        message: 'Pick up to 5',
        min: 0,
        max: 5,
        options: [
          IngredientModel(id: 'pt-pineapple', name: 'Pineapple', price: 0.80),
          IngredientModel(id: 'pt-jalapeno', name: 'Jalapeños', price: 0.50),
          IngredientModel(id: 'pt-sweetcorn', name: 'Sweet Corn', price: 0.50),
          IngredientModel(id: 'pt-pepperoni', name: 'Pepperoni', price: 1.20),
          IngredientModel(id: 'pt-redonion', name: 'Red Onions', price: 0.50),
          IngredientModel(id: 'pt-anchovies', name: 'Anchovies', price: 1.00),
          IngredientModel(
            id: 'pt-groundbeef',
            name: 'Ground Beef',
            price: 1.50,
          ),
          IngredientModel(id: 'pt-chicken', name: 'Chicken Tikka', price: 1.50),
          IngredientModel(id: 'pt-mushroom', name: 'Mushroom', price: 0.80),
          IngredientModel(id: 'pt-tuna', name: 'Tuna', price: 1.00),
        ],
      ),
    ],
  ),
  ProductModel(
    name: 'BBQ Pulled Pork Pizza',
    description: 'Slow-cooked pulled pork, BBQ sauce, red onion, and cheddar.',
    price: 16.50,
    rating: 4.6,
    reviews: 156,
    isNew: true,
    isFeatured: false,
    image:
        'https://images.unsplash.com/photo-1565299507177-b0ac66763828?w=300&q=80',
    category: 'Pizza',
    restaurantId: 3,
    allergens: ['Gluten', 'Dairy'],
    isCustomizable: true,
    types: [
      ProductTypeModel(
        id: 'bbqp-crust',
        name: 'Choose Crust',
        message: 'Select your base',
        min: 1,
        max: 1,
        options: [
          IngredientModel(id: 'bbqcrust-thin', name: 'Thin Crust', price: 0),
          IngredientModel(id: 'bbqcrust-classic', name: 'Classic', price: 0),
          IngredientModel(
            id: 'bbqcrust-thick',
            name: 'Thick Crust',
            price: 1.00,
          ),
        ],
      ),
      ProductTypeModel(
        id: 'bbqp-extras',
        name: 'Add Extras',
        message: 'Optional add-ons',
        min: 0,
        max: 3,
        options: [
          IngredientModel(
            id: 'bbqex-cheese',
            name: 'Extra Cheese',
            price: 1.00,
          ),
          IngredientModel(id: 'bbqex-jalapeno', name: 'Jalapeños', price: 0.50),
          IngredientModel(
            id: 'bbqex-onion',
            name: 'Caramelised Onion',
            price: 0.60,
          ),
          IngredientModel(
            id: 'bbqex-pepperoni',
            name: 'Pepperoni',
            price: 1.20,
          ),
        ],
      ),
    ],
  ),

  // ── Tacos (customizable) ──────────────────────────────────────────────────
  ProductModel(
    name: 'Street Tacos Trio',
    description:
        'Three soft corn tortillas with carne asada, cilantro, and salsa.',
    price: 11.99,
    rating: 4.7,
    reviews: 203,
    isNew: false,
    isFeatured: false,
    image:
        'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=300&q=80',
    category: 'Tacos',
    restaurantId: 4,
    isCustomizable: true,
    types: [
      ProductTypeModel(
        id: 'taco-protein',
        name: 'Choose Protein',
        message: 'Required',
        min: 1,
        max: 1,
        options: [
          IngredientModel(id: 'tpro-asada', name: 'Carne Asada', price: 0),
          IngredientModel(
            id: 'tpro-chicken',
            name: 'Grilled Chicken',
            price: 0,
          ),
          IngredientModel(id: 'tpro-shrimp', name: 'Shrimp', price: 1.50),
          IngredientModel(id: 'tpro-veg', name: 'Vegan', price: 0),
        ],
      ),
      ProductTypeModel(
        id: 'taco-salsa',
        name: 'Salsa',
        message: 'Pick your salsa',
        min: 1,
        max: 1,
        options: [
          IngredientModel(id: 'tsal-verde', name: 'Salsa Verde', price: 0),
          IngredientModel(id: 'tsal-roja', name: 'Salsa Roja', price: 0),
          IngredientModel(id: 'tsal-habanero', name: 'Habanero 🔥', price: 0),
        ],
      ),
      ProductTypeModel(
        id: 'taco-extras',
        name: 'Extras',
        message: 'Optional add-ons',
        min: 0,
        max: 4,
        options: [
          IngredientModel(id: 'tex-guac', name: 'Guacamole', price: 1.00),
          IngredientModel(id: 'tex-sour', name: 'Sour Cream', price: 0.60),
          IngredientModel(id: 'tex-cheese', name: 'Queso Fresco', price: 0.80),
          IngredientModel(id: 'tex-pico', name: 'Pico de Gallo', price: 0.50),
        ],
      ),
    ],
  ),
  ProductModel(
    name: 'Fish Tacos Baja Style',
    description: 'Crispy battered cod, slaw, chipotle crema, lime.',
    price: 13.00,
    rating: 4.6,
    reviews: 142,
    isNew: true,
    isFeatured: false,
    image:
        'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=300&q=80',
    category: 'Tacos',
    restaurantId: 11,
    allergens: ['Fish', 'Gluten'],
    isCustomizable: true,
    types: [
      ProductTypeModel(
        id: 'fish-sauce',
        name: 'Sauce',
        message: 'Choose your sauce',
        min: 1,
        max: 1,
        options: [
          IngredientModel(
            id: 'fsauce-chipotle',
            name: 'Chipotle Crema',
            price: 0,
          ),
          IngredientModel(id: 'fsauce-tartar', name: 'Tartar Sauce', price: 0),
          IngredientModel(id: 'fsauce-mango', name: 'Mango Salsa', price: 0.50),
        ],
      ),
      ProductTypeModel(
        id: 'fish-extras',
        name: 'Add Extras',
        message: 'Optional',
        min: 0,
        max: 3,
        options: [
          IngredientModel(id: 'fex-avocado', name: 'Avocado', price: 1.20),
          IngredientModel(id: 'fex-jalap', name: 'Jalapeños', price: 0.50),
          IngredientModel(id: 'fex-cheese', name: 'Cotija Cheese', price: 0.80),
        ],
      ),
    ],
  ),

  // ── Sushi (direct add) ────────────────────────────────────────────────────
  ProductModel(
    name: 'Spicy Tuna Roll (8pc)',
    description: 'Fresh tuna, spicy mayo, cucumber, avocado, sesame.',
    price: 18.00,
    rating: 4.9,
    reviews: 321,
    isNew: true,
    isFeatured: true,
    image:
        'https://images.unsplash.com/photo-1617196034183-421b4040ed20?w=300&q=80',
    category: 'Sushi',
    restaurantId: 2,
    allergens: ['Fish', 'Soy'],
  ),
  ProductModel(
    name: 'Dragon Roll (8pc)',
    description: 'Shrimp tempura topped with avocado and eel sauce.',
    price: 19.50,
    rating: 4.8,
    reviews: 298,
    isNew: false,
    isFeatured: true,
    image:
        'https://images.unsplash.com/photo-1562802378-063ec186a863?w=300&q=80',
    category: 'Sushi',
    restaurantId: 2,
    allergens: ['Shellfish', 'Fish'],
  ),

  // ── Pasta (direct add) ───────────────────────────────────────────────────
  ProductModel(
    name: 'Cacio e Pepe',
    description:
        'Roman classic — spaghetti, Pecorino Romano, and black pepper.',
    price: 15.00,
    rating: 4.9,
    reviews: 389,
    isNew: false,
    isFeatured: true,
    image:
        'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=300&q=80',
    category: 'Pasta',
    restaurantId: 6,
    allergens: ['Gluten', 'Dairy'],
  ),

  // ── Desserts (direct add) ────────────────────────────────────────────────
  ProductModel(
    name: 'Nutella Lava Cake',
    description:
        'Warm chocolate cake with a molten Nutella center. Served with vanilla ice cream.',
    price: 8.50,
    rating: 4.9,
    reviews: 501,
    isNew: false,
    isFeatured: true,
    image:
        'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=300&q=80',
    category: 'Desserts',
    restaurantId: 8,
    allergens: ['Gluten', 'Dairy', 'Nuts', 'Egg'],
  ),

  // ── Drinks (direct add) ──────────────────────────────────────────────────
  ProductModel(
    name: 'Mango Lassi',
    description:
        'Creamy mango and yogurt blended drink with a hint of cardamom.',
    price: 5.50,
    rating: 4.8,
    reviews: 178,
    isNew: false,
    isFeatured: false,
    image:
        'https://images.unsplash.com/photo-1570197788417-0e82375c9371?w=300&q=80',
    category: 'Drinks',
    restaurantId: 10,
    allergens: ['Dairy'],
  ),

  // ── Chicken (direct add) ─────────────────────────────────────────────────
  ProductModel(
    name: 'Nashville Hot Tenders',
    description:
        'Crispy tenders dipped in Nashville cayenne butter. Hot, hotter, hottest.',
    price: 14.50,
    rating: 4.7,
    reviews: 267,
    isNew: true,
    isFeatured: true,
    image:
        'https://images.unsplash.com/photo-1527477396000-e27163b481c2?w=300&q=80',
    category: 'Chicken',
    restaurantId: 7,
    allergens: ['Gluten'],
  ),
];

double get maxProductPrice =>
    products.map((p) => p.price).reduce((a, b) => a > b ? a : b);

const promos = [
  PromoModel(
    title: 'Free Delivery',
    sub: 'All orders this weekend',
    color: primaryColor,
    image:
        'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=600&q=80',
    cta: 'Grab the Deal',
  ),
  PromoModel(
    title: '20% Off Pizza',
    sub: 'Use code NEWUSER',
    color: tertiaryColor,
    image:
        'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=600&q=80',
    cta: 'Order Now',
  ),
  PromoModel(
    title: 'Desserts from Heaven',
    sub: 'Buy 1 Get 1 Extra',
    color: accentAmberLight,
    image:
        'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=600&q=80',
    cta: 'Try it Now!',
  ),
];
