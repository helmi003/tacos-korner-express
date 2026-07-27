import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:takos_corner_express/data/home_data.dart';
import 'package:takos_corner_express/l10n/app_localizations.dart';
import 'package:takos_corner_express/l10n/l10n.dart';
import 'package:takos_corner_express/screens/authentication/forgot_password_screen.dart';
import 'package:takos_corner_express/screens/authentication/login_screen.dart';
import 'package:takos_corner_express/screens/authentication/onboarding_screen.dart';
import 'package:takos_corner_express/screens/authentication/register_screen.dart';
import 'package:takos_corner_express/screens/coming_soon_screen.dart';
import 'package:takos_corner_express/screens/notifications_screen.dart';
import 'package:takos_corner_express/screens/restaurants/restaurant_details_screen.dart';
import 'package:takos_corner_express/screens/settings/account/change_password_screen.dart';
import 'package:takos_corner_express/screens/settings/delivery_zone_screen.dart';
import 'package:takos_corner_express/screens/settings/notification_preferences_screen.dart';
import 'package:takos_corner_express/screens/settings/orders/favorite_screen.dart';
import 'package:takos_corner_express/screens/settings/orders/orders_screen.dart';
import 'package:takos_corner_express/screens/settings/settings_screen.dart';
import 'package:takos_corner_express/screens/settings/support/about_screen.dart';
import 'package:takos_corner_express/screens/settings/support/help_screen.dart';
import 'package:takos_corner_express/screens/splash_screen.dart';
import 'package:takos_corner_express/screens/tabs/tab_screen.dart';
import 'package:takos_corner_express/services/cart_provider.dart';
import 'package:takos_corner_express/services/configuration_manager.dart';
import 'package:takos_corner_express/services/favorites_provider.dart';
import 'package:takos_corner_express/services/language_provider.dart';
import 'package:takos_corner_express/services/theme_provider.dart';
import 'package:takos_corner_express/services/user_provider.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/custom_error_dialog.dart';
import 'package:timeago/timeago.dart' as timeago;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
String? startupError;
late final Future<void> deferredInit;
final _appLinks = AppLinks();

Future<void> _initDeepLinks() async {
  try {
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) _handleDeepLink(initialUri);
  } catch (_) {}
  _appLinks.uriLinkStream.listen(_handleDeepLink, onError: (_) {});
}

void _handleDeepLink(Uri uri) {
  if (uri.scheme != 'takoskorner' || uri.host != 'restaurant') return;
  final idSegment = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : '';
  final id = int.tryParse(idSegment);
  if (id == null) return;
  final matches = restaurants.where((r) => r.id == id);
  if (matches.isEmpty) return;
  navigatorKey.currentState?.push(
    MaterialPageRoute(
      builder: (_) => RestaurantDetailsScreen(restaurant: matches.first),
    ),
  );
}

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      try {
        await dotenv.load(fileName: ".env");
        EnvConfig.validate();
      } catch (e) {
        startupError = e.toString();
      }
      await initializeDateFormatting('en', null);
      timeago.setLocaleMessages('ar', timeago.ArMessages());
      timeago.setLocaleMessages('fr', timeago.FrMessages());
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => LanguageProvider()),
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => CartProvider()),
            ChangeNotifierProvider(create: (_) => UserProvider()),
            ChangeNotifierProvider(create: (_) => FavoritesProvider()),
          ],
          child: const MyApp(),
        ),
      );
      WidgetsBinding.instance.addPostFrameCallback((_) => _initDeepLinks());
    },
    (error, stack) {
      final ctx = navigatorKey.currentState?.overlay?.context;
      if (ctx != null) {
        CustomErrorDialog.show(ctx, error.toString());
      }
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedLocale = context.watch<LanguageProvider>().selectedLanguage;
    final isArabic = context.watch<LanguageProvider>().isArabic;
    final isDark = context.watch<ThemeProvider>().isDark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 600;
        return ScreenUtilInit(
          designSize: isTablet ? const Size(600, 900) : const Size(390, 844),
          builder: (context, child) {
            return MaterialApp(
              navigatorKey: navigatorKey,
              scaffoldMessengerKey: scaffoldMessengerKey,
              title: 'takos_corner_express',
              debugShowCheckedModeBanner: false,
              themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
              theme: lightTheme.copyWith(
                textTheme: lightTheme.textTheme.apply(
                  fontFamily: isArabic ? 'Almarai' : 'Poppins',
                ),
              ),
              darkTheme: darkTheme.copyWith(
                textTheme: darkTheme.textTheme.apply(
                  fontFamily: isArabic ? 'Almarai' : 'Poppins',
                ),
              ),
              home: const SplashScreen(),
              routes: {
                SplashScreen.routeName: (context) => const SplashScreen(),
                OnboardingScreen.routeName: (context) =>
                    const OnboardingScreen(),
                LoginScreen.routeName: (context) => const LoginScreen(),
                RegisterScreen.routeName: (context) => const RegisterScreen(),
                ForgotPasswordScreen.routeName: (context) =>
                    const ForgotPasswordScreen(),
                TabScreen.routeName: (context) => const TabScreen(),
                NotificationPreferencesScreen.routeName: (context) =>
                    const NotificationPreferencesScreen(),
                ChangePasswordScreen.routeName: (context) =>
                    const ChangePasswordScreen(),
                OrdersScreen.routeName: (context) => const OrdersScreen(),
                FavouritesScreen.routeName: (context) =>
                    const FavouritesScreen(),
                NotificationsScreen.routeName: (context) =>
                    const NotificationsScreen(),
                HelpScreen.routeName: (context) => const HelpScreen(),
                AboutScreen.routeName: (context) => const AboutScreen(),
                DeliveryZoneScreen.routeName: (context) =>
                    const DeliveryZoneScreen(),
                SettingsScreen.routeName: (context) => const SettingsScreen(),
                ComingSoonScreen.routeName: (context) {
                  final title =
                      ModalRoute.of(context)!.settings.arguments as String? ??
                      '';
                  return ComingSoonScreen(title: title);
                },
              },
              supportedLocales: L10n.all,
              locale: selectedLocale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
            );
          },
        );
      },
    );
  }
}
