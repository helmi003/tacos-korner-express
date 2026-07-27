import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:takos_corner_express/data/home_data.dart';
import 'package:takos_corner_express/widgets/global/custom_snackbar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openMaps(BuildContext context, num lat, num lng) async {
  final googleMapsSearchUrl = dotenv.env['GOOGLE_MAPS_SEARCH_URL'] ?? '';
  final uri = Uri.parse('$googleMapsSearchUrl?api=1&query=$lat,$lng');
  var launched = false;
  try {
    launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    launched = false;
  }
  if (!launched && context.mounted) {
    CustomSnackbar.show(
      context,
      message: "Error opening maps. Please try again.",
      type: SnackbarType.error,
    );
  }
}

Future<void> shareURL(BuildContext context, RestaurantModel restaurant) async {
  final deepLink = 'takoskorner://restaurant/${restaurant.id}';
  final iosUrl = dotenv.env['IOS_APP_STORE_URL'] ?? '';
  final androidUrl = dotenv.env['ANDROID_PLAY_STORE_URL'] ?? '';
  final lines = <String>[
    'Check out ${restaurant.name} on Takos Korner Express!',
    restaurant.address,
    deepLink,
    if (androidUrl.isNotEmpty) 'Android: $androidUrl',
    if (iosUrl.isNotEmpty) 'iOS: $iosUrl',
  ];
  try {
    await SharePlus.instance.share(
      ShareParams(
        text: lines.join('\n'),
        subject: 'Takos Korner Express — ${restaurant.name}',
      ),
    );
  } catch (_) {
    if (context.mounted) {
      CustomSnackbar.show(
        context,
        message: 'Error sharing. Please try again.',
        type: SnackbarType.error,
      );
    }
  }
}

Future<void> openPhone(BuildContext context, String phone) async {
  final uri = Uri.parse('tel:$phone');
  var launched = false;
  try {
    launched = await launchUrl(uri);
  } catch (_) {
    launched = false;
  }
  if (!launched && context.mounted) {
    CustomSnackbar.show(
      context,
      message:
          "There was a problem opening the phone dialer. Please try again.",
      type: SnackbarType.error,
    );
  }
}

Future<void> openEmail(
  BuildContext context,
  String email, {
  String subject = '',
}) async {
  final uri = Uri(
    scheme: 'mailto',
    path: email,
    query: subject.isNotEmpty ? 'subject=$subject' : null,
  );
  var launched = false;
  try {
    launched = await launchUrl(uri);
  } catch (_) {
    launched = false;
  }
  if (!launched && context.mounted) {
    CustomSnackbar.show(
      context,
      message: "There was a problem opening your email app. Please try again.",
      type: SnackbarType.error,
    );
  }
}

Future<void> shareApp(BuildContext context) async {
  final iosUrl = dotenv.env['IOS_APP_STORE_URL'] ?? '';
  final androidUrl = dotenv.env['ANDROID_PLAY_STORE_URL'] ?? '';
  final lines = <String>[
    "Check out Tako's Korner Express — order your favourite food fast!",
    if (androidUrl.isNotEmpty) 'Android: $androidUrl',
    if (iosUrl.isNotEmpty) 'iOS: $iosUrl',
  ];
  try {
    await SharePlus.instance.share(
      ShareParams(text: lines.join('\n'), subject: "Tako's Korner Express"),
    );
  } catch (_) {
    if (context.mounted) {
      CustomSnackbar.show(
        context,
        message: 'Error sharing. Please try again.',
        type: SnackbarType.error,
      );
    }
  }
}
