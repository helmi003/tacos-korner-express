enum OrderStatus { preparing, onTheWay, delivered, cancelled }

class OrderModel {
  final String id;
  final String restaurantName;
  final String restaurantImage;
  final String itemsSummary;
  final double total;
  final OrderStatus status;
  final String date;
  const OrderModel({
    required this.id,
    required this.restaurantName,
    required this.restaurantImage,
    required this.itemsSummary,
    required this.total,
    required this.status,
    required this.date,
  });

  bool get isActive =>
      status == OrderStatus.preparing || status == OrderStatus.onTheWay;
}

const orders = [
  OrderModel(
    id: 'TK-2847',
    restaurantName: 'Smash & Stack',
    restaurantImage:
        'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=200&q=80',
    itemsSummary: '2x Classic Smash Burger, 1x Mango Lassi',
    total: 32.48,
    status: OrderStatus.onTheWay,
    date: 'Today, 12:40 PM',
  ),
  OrderModel(
    id: 'TK-2831',
    restaurantName: "Luigi's Pizzeria",
    restaurantImage:
        'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=200&q=80',
    itemsSummary: '1x Margherita Classica',
    total: 14.00,
    status: OrderStatus.preparing,
    date: 'Today, 11:15 AM',
  ),
  OrderModel(
    id: 'TK-2790',
    restaurantName: 'Sushi Omakase',
    restaurantImage:
        'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=200&q=80',
    itemsSummary: '1x Spicy Tuna Roll, 1x Dragon Roll',
    total: 37.50,
    status: OrderStatus.delivered,
    date: 'Yesterday, 7:20 PM',
  ),
  OrderModel(
    id: 'TK-2755',
    restaurantName: 'Taco Loco',
    restaurantImage:
        'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=200&q=80',
    itemsSummary: '1x Street Tacos Trio',
    total: 11.99,
    status: OrderStatus.delivered,
    date: '3 days ago',
  ),
  OrderModel(
    id: 'TK-2701',
    restaurantName: 'Dessert Lab',
    restaurantImage:
        'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=200&q=80',
    itemsSummary: '2x Nutella Lava Cake',
    total: 17.00,
    status: OrderStatus.cancelled,
    date: '1 week ago',
  ),
];
