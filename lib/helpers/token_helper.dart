// import 'package:flutter/widgets.dart';
// import 'package:takos_corner_express/models/http_exceptions.dart';
// import 'package:takos_corner_express/services/authentication_service.dart';
// import 'package:provider/provider.dart';
// import 'package:takos_corner_express/l10n/app_localizations.dart';

// Future<String> getToken(BuildContext context) async {
//   final authProvider = context.read<AuthenticationService>();
//   final sessionExpiredMsg = AppLocalizations.of(context)!.session_expired;
//   final token = await authProvider.getValidAccessToken();
//   if (token == null) {
//     throw CustomHttpException(sessionExpiredMsg);
//   }
//   return token;
// }

// Future<Map<String, String>> getTokenWithHeader(BuildContext context) async {
//   final authProvider = context.read<AuthenticationService>();
//   final langCode = Localizations.localeOf(context).languageCode;
//   final sessionExpiredMsg = AppLocalizations.of(context)!.session_expired;
//   final token = await authProvider.getValidAccessToken();
//   if (token == null) {
//     throw CustomHttpException(sessionExpiredMsg);
//   }
//   return {
//     'Content-Type': 'application/json',
//     'Accept': 'application/json',
//     'X-Client-Type': 'mobile',
//     'Cookie': 'access_token=$token',
//     'Accept-Language': langCode,
//   };
// }

// Future<Map<String, String>> getMultipartHeaders(BuildContext context) async {
//   final authProvider = context.read<AuthenticationService>();
//   final langCode = Localizations.localeOf(context).languageCode;
//   final sessionExpiredMsg = AppLocalizations.of(context)!.session_expired;
//   final token = await authProvider.getValidAccessToken();
//   if (token == null) {
//     throw CustomHttpException(sessionExpiredMsg);
//   }
//   return {
//     'Accept': 'application/json',
//     'X-Client-Type': 'mobile',
//     'Cookie': 'access_token=$token',
//     'Accept-Language': langCode,
//   };
// }
