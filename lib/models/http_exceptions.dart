import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:takos_corner_express/l10n/app_localizations.dart';
import 'package:takos_corner_express/widgets/global/custom_snackbar.dart';

class CustomHttpException implements Exception {
  final String message;
  CustomHttpException(this.message);

  @override
  String toString() => message;
}

Future<T> handleErrors<T>(
  BuildContext context,
  Future<T> Function() operation,
) async {
  try {
    return await operation();
  } on SocketException catch (e) {
    if (kDebugMode) debugPrint("SocketException: $e");
    throw CustomHttpException(AppLocalizations.of(context)!.no_internet_access);
  } on FormatException catch (e) {
    if (kDebugMode) debugPrint("FormatException: $e");
    throw CustomHttpException(
      AppLocalizations.of(context)!.data_processing_error,
    );
  } on StateError catch (e) {
    if (kDebugMode) debugPrint("StateError: $e");
    throw CustomHttpException(AppLocalizations.of(context)!.unknown_error);
  } catch (exception) {
    if (kDebugMode) debugPrint("Unknown error: $exception");
    if (exception is CustomHttpException) rethrow;
    throw CustomHttpException(AppLocalizations.of(context)!.unknown_error);
  }
}

bool _isLoggingOut = false;

String extractApiMessage(
  Map<String, dynamic> body, {
  String fallback = 'Une erreur est survenue',
}) {
  return (body['error'] as Map?)?['message']?.toString() ??
      body['detail']?.toString() ??
      fallback;
}

Future<Never> handleHttpResponseError(
  BuildContext context,
  int statusCode,
  Map<String, dynamic> body, {
  bool autoLogoutOnAuthError = true,
  Future<void> Function(BuildContext ctx)? onLogout,
}) async {
  if (statusCode == 401 && autoLogoutOnAuthError) {
    if (context.mounted && !_isLoggingOut) {
      _isLoggingOut = true;
      if (onLogout != null) await onLogout(context);
      if (context.mounted) {
        CustomSnackbar.show(
          context,
          message: 'Votre session a expiré. Veuillez vous reconnecter.',
          type: SnackbarType.error,
        );
      }
      _isLoggingOut = false;
    }
    throw CustomHttpException('Votre session a expiré. Veuillez vous reconnecter.');
  } else {
    throw CustomHttpException(extractApiMessage(body));
  }
}
