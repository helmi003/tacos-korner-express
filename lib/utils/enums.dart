import 'package:flutter/widgets.dart';
import 'package:solar_icons/solar_icons.dart';

enum AuthProvider { email, google, facebook, apple }

enum RestaurantsView { cards, map }

enum SearchScope { all, restaurants, products }

enum PriceSort { any, lowToHigh, highToLow }

enum NameSort { any, aToZ, zToA }

enum Gender { male, female, other, preferNotToSay }

extension GenderX on Gender {
  String get label => switch (this) {
    Gender.male => 'Male',
    Gender.female => 'Female',
    Gender.other => 'Other',
    Gender.preferNotToSay => 'Prefer not to say',
  };

  IconData get icon => switch (this) {
    Gender.male => SolarIconsOutline.userCircle,
    Gender.female => SolarIconsOutline.userCircle,
    Gender.other => SolarIconsOutline.usersGroupTwoRounded,
    Gender.preferNotToSay => SolarIconsOutline.incognito,
  };
}

enum OrdersView { active, past }
