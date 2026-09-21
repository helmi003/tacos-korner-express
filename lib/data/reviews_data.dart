class ReviewModel {
  final int id;
  final int restaurantId;
  final String authorName;
  final int rating;
  final String comment;
  final DateTime date;
  final String? ownerReplyText;
  final DateTime? ownerReplyDate;

  const ReviewModel({
    required this.id,
    required this.restaurantId,
    required this.authorName,
    required this.rating,
    required this.comment,
    required this.date,
    this.ownerReplyText,
    this.ownerReplyDate,
  });
}

final List<ReviewModel> reviewsSeed = [
  // ── Smash & Stack (restaurantId 1) ───────────────────────────────────────
  ReviewModel(
    id: 1,
    restaurantId: 1,
    authorName: 'Mariem K.',
    rating: 5,
    comment:
        'Best smash burger in Tunis, hands down. The double patty with cheddar is unreal.',
    date: DateTime(2026, 7, 20),
    ownerReplyText:
        'Thank you so much, Mariem! We\'re thrilled you loved it — see you again soon!',
    ownerReplyDate: DateTime(2026, 7, 20, 18, 30),
  ),
  ReviewModel(
    id: 2,
    restaurantId: 1,
    authorName: 'Amine T.',
    rating: 4,
    comment: 'Great burgers, fries could be a bit crispier but overall solid.',
    date: DateTime(2026, 7, 17),
  ),
  ReviewModel(
    id: 3,
    restaurantId: 1,
    authorName: 'Sarra B.',
    rating: 2,
    comment: 'Order arrived cold and the fries were soggy this time.',
    date: DateTime(2026, 7, 14),
    ownerReplyText:
        'We\'re really sorry about this experience — this isn\'t the standard we hold ourselves to. We\'ve flagged this with our delivery team and would love to make it right on your next order.',
    ownerReplyDate: DateTime(2026, 7, 14, 20, 10),
  ),
  ReviewModel(
    id: 4,
    restaurantId: 1,
    authorName: 'Yassine H.',
    rating: 5,
    comment: 'The triple smash with bacon is a must-try. Worth every dinar.',
    date: DateTime(2026, 7, 9),
  ),
  ReviewModel(
    id: 5,
    restaurantId: 1,
    authorName: 'Nour E.',
    rating: 3,
    comment: 'Decent but a bit pricey for the portion size.',
    date: DateTime(2026, 6, 30),
  ),
  ReviewModel(
    id: 6,
    restaurantId: 1,
    authorName: 'Wassim D.',
    rating: 4,
    comment: 'Quick delivery, tasty burger, will order again.',
    date: DateTime(2026, 6, 22),
  ),

  // ── Sushi Omakase (restaurantId 2) ───────────────────────────────────────
  ReviewModel(
    id: 7,
    restaurantId: 2,
    authorName: 'Léa M.',
    rating: 5,
    comment: 'Freshest sushi I\'ve had outside Japan. The dragon roll is stunning.',
    date: DateTime(2026, 7, 21),
    ownerReplyText:
        'Arigatou gozaimasu, Léa! Our chef will be delighted to hear this — thank you for the kind words.',
    ownerReplyDate: DateTime(2026, 7, 21, 21, 5),
  ),
  ReviewModel(
    id: 8,
    restaurantId: 2,
    authorName: 'Karim S.',
    rating: 4,
    comment: 'Lovely presentation, a bit slow on a busy Friday night.',
    date: DateTime(2026, 7, 12),
  ),
  ReviewModel(
    id: 9,
    restaurantId: 2,
    authorName: 'Ines R.',
    rating: 5,
    comment: 'Omakase set was incredible, every piece was perfectly balanced.',
    date: DateTime(2026, 7, 3),
  ),
  ReviewModel(
    id: 10,
    restaurantId: 2,
    authorName: 'Omar F.',
    rating: 3,
    comment: 'Good quality but portions felt small for the price.',
    date: DateTime(2026, 6, 25),
  ),
  ReviewModel(
    id: 11,
    restaurantId: 2,
    authorName: 'Salma J.',
    rating: 4,
    comment: 'Spicy tuna roll was excellent, will be back for more.',
    date: DateTime(2026, 6, 15),
  ),

  // ── Luigi's Pizzeria (restaurantId 3) ────────────────────────────────────
  ReviewModel(
    id: 12,
    restaurantId: 3,
    authorName: 'Firas A.',
    rating: 5,
    comment: 'That crust is everything — blistered, chewy, perfect.',
    date: DateTime(2026, 7, 19),
    ownerReplyText:
        'Grazie mille, Firas! We bake every pie with love — glad it shows.',
    ownerReplyDate: DateTime(2026, 7, 19, 19, 45),
  ),
  ReviewModel(
    id: 13,
    restaurantId: 3,
    authorName: 'Rania C.',
    rating: 2,
    comment: 'Pizza was undercooked in the middle, disappointing for the price.',
    date: DateTime(2026, 7, 8),
    ownerReplyText:
        'So sorry to hear this, Rania — that shouldn\'t have left our kitchen. Please reach out so we can send you a fresh one on us.',
    ownerReplyDate: DateTime(2026, 7, 8, 22, 0),
  ),
  ReviewModel(
    id: 14,
    restaurantId: 3,
    authorName: 'Bilel N.',
    rating: 4,
    comment: 'Margherita Classica is simple but done really well.',
    date: DateTime(2026, 6, 28),
  ),
  ReviewModel(
    id: 15,
    restaurantId: 3,
    authorName: 'Dorra L.',
    rating: 5,
    comment: 'Family favorite, the kids ask for it every week!',
    date: DateTime(2026, 6, 18),
  ),
  ReviewModel(
    id: 16,
    restaurantId: 3,
    authorName: 'Hamza Z.',
    rating: 3,
    comment: 'Good pizza, delivery took longer than the estimate.',
    date: DateTime(2026, 6, 5),
  ),

  // ── Pasta Madre (restaurantId 6) ─────────────────────────────────────────
  ReviewModel(
    id: 17,
    restaurantId: 6,
    authorName: 'Emna O.',
    rating: 5,
    comment: 'Cacio e pepe was silky and rich, tastes handmade.',
    date: DateTime(2026, 7, 16),
  ),
  ReviewModel(
    id: 18,
    restaurantId: 6,
    authorName: 'Anis P.',
    rating: 4,
    comment: 'Cozy comfort food, portions are generous.',
    date: DateTime(2026, 7, 6),
  ),
  ReviewModel(
    id: 19,
    restaurantId: 6,
    authorName: 'Chaima V.',
    rating: 2,
    comment: 'Pasta was overcooked and a bit bland tonight.',
    date: DateTime(2026, 6, 27),
  ),
  ReviewModel(
    id: 20,
    restaurantId: 6,
    authorName: 'Skander W.',
    rating: 5,
    comment: 'Best Italian comfort food in the area, consistently great.',
    date: DateTime(2026, 6, 12),
  ),
  ReviewModel(
    id: 21,
    restaurantId: 6,
    authorName: 'Mouna Q.',
    rating: 4,
    comment: 'Lovely sauces, would love more veggie options.',
    date: DateTime(2026, 5, 30),
  ),
];
