import 'package:flutter/material.dart';
import 'package:takos_corner_express/data/reviews_data.dart';

class ReviewsProvider extends ChangeNotifier {
  final List<ReviewModel> _reviews = List.of(reviewsSeed);
  int _nextId = reviewsSeed.isEmpty
      ? 1
      : reviewsSeed.map((r) => r.id).reduce((a, b) => a > b ? a : b) + 1;

  List<ReviewModel> reviewsFor(int restaurantId) {
    final list = _reviews.where((r) => r.restaurantId == restaurantId).toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  int countFor(int restaurantId) => reviewsFor(restaurantId).length;

  double averageFor(int restaurantId) {
    final list = reviewsFor(restaurantId);
    if (list.isEmpty) return 0;
    return list.map((r) => r.rating).reduce((a, b) => a + b) / list.length;
  }

  /// Index 0 = count of 1-star reviews ... index 4 = count of 5-star reviews.
  List<int> breakdownFor(int restaurantId) {
    final counts = List.filled(5, 0);
    for (final r in reviewsFor(restaurantId)) {
      counts[r.rating.clamp(1, 5) - 1]++;
    }
    return counts;
  }

  void addReview({
    required int restaurantId,
    required String authorName,
    required int rating,
    required String comment,
  }) {
    _reviews.add(
      ReviewModel(
        id: _nextId++,
        restaurantId: restaurantId,
        authorName: authorName,
        rating: rating,
        comment: comment,
        date: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
