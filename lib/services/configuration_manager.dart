import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:takos_corner_express/models/http_exceptions.dart';

class EnvConfig {
  static late final String apiUrl;

  static void validate() {
    apiUrl = dotenv.env['API_URL'] ?? '';

    final missing = <String>[];
    if (apiUrl.isEmpty) missing.add('API_URL');

    if (missing.isNotEmpty) {
      throw CustomHttpException(
        'Missing environment variables: ${missing.join(", ")}. Please check your .env file.',
      );
    }
  }
}
