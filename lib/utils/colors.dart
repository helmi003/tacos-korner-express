import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ── Brand / Primary ──────────────────────────────────────────────────────────
const Color primaryColor    = Color(0xFFEC1D23); // Red
const Color primaryDark     = Color(0xFFC01019); // Dark Red
const Color primaryLight    = Color(0xFFFF6B70); // Light Red
const Color primaryBGColor  = Color(0xFFFFF0F0); // Light Red tint (bg use)

// ── Secondary ────────────────────────────────────────────────────────────────
const Color secondaryColor  = Color(0xFF2596BE); // Blue
const Color secondaryDark   = Color(0xFF1A7A9E); // Dark Blue

// ── Accent ───────────────────────────────────────────────────────────────────
const Color accentAmber     = Color(0xFFF59E0B);
const Color accentAmberDark = Color(0xFFD97706);
const Color accentBlue      = Color(0xFF2596BE);
const Color accentBlueBg    = Color(0xFFEFF6FF);
const Color accentGreen     = Color(0xFF10B981);
const Color accentGreenBg   = Color(0xFFECFDF5);
const Color accentPurple    = Color(0xFFA855F7);
const Color accentPurpleBg  = Color(0xFFF3E8FF);
const Color accentOrange    = Color(0xFFF59E0B);
const Color accentOrangeBg  = Color(0xFFFFF5E6);
const Color accentRed       = Color(0xFFEC1D23);
const Color accentRedBg     = Color(0xFFFDF4F3);
const Color accentRedDark   = Color(0xFFC01019);

// ── Text ─────────────────────────────────────────────────────────────────────
const Color textMain        = Color(0xFF1A1A2E);
const Color textBody        = Color(0xFF4A5568);
const Color textMuted       = Color(0xFF9CA3AF);
const Color textMutedLight  = Color(0xFFBEC5CC);
const Color textLight       = Color(0xFFF1F5F9);

// ── Light Mode UI ─────────────────────────────────────────────────────────────
const Color uiBackgroundLight = Color(0xFFF0F2F5);
const Color uiCardLight       = Color(0xFFFFFFFF);
const Color uiBorderLight     = Color(0xFFE5E7EB);
const Color uiCardGrayLight   = Color(0xFFEFEFEA);

// ── Dark Mode UI ──────────────────────────────────────────────────────────────
const Color uiBackgroundDark  = Color(0xFF0F172A);
const Color uiCardDark        = Color(0xFF1E293B);
const Color uiBorderDark      = Color(0xFF334155);
const Color uiCardGrayDark    = Color(0xFF1A2035);

// ── Status Colors ─────────────────────────────────────────────────────────────
const Color success   = Color(0xFF10B981);
const Color successBg = Color(0xFFECFDF5);
const Color warning   = Color(0xFFF59E0B);
const Color warningBg = Color(0xFFFFFBEB);
const Color danger    = Color(0xFFEF4444);
const Color dangerBg  = Color(0xFFFEF2F2);
const Color info      = Color(0xFF2596BE);
const Color infoBg    = Color(0xFFE0F2FE);

// ── Shadows ───────────────────────────────────────────────────────────────────
const List<BoxShadow> lightShadows = [
  BoxShadow(color: Color(0x14000000), offset: Offset(0, 4), blurRadius: 20),
];
const List<BoxShadow> darkShadows = [
  BoxShadow(color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 0),
];

final BoxBorder borderDark  = Border.all(color: uiBorderDark,  width: 0.5.w);
final BoxBorder borderLight = Border.all(color: uiBorderLight, width: 0.5.w);

// ── Gradients ─────────────────────────────────────────────────────────────────
const LinearGradient primaryGradient = LinearGradient(
  colors: [primaryColor, primaryDark],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient secondaryGradient = LinearGradient(
  colors: [secondaryColor, secondaryDark],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient amberGradient = LinearGradient(
  colors: [accentAmber, accentAmberDark],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient greenGradient = LinearGradient(
  colors: [accentGreen, Color(0xFF059669)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient gradientDark = LinearGradient(
  colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient emergencyGradient = LinearGradient(
  colors: [accentRed, accentRedDark],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// ── Theme Definitions ─────────────────────────────────────────────────────────
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: uiBackgroundLight,
  cardColor: uiCardLight,
  textTheme: const TextTheme(bodyMedium: TextStyle(color: textMain)),
  colorScheme: const ColorScheme.light(
    primary: primaryColor,
    secondary: secondaryColor,
    surface: uiCardLight,
    error: danger,
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: uiBackgroundDark,
  cardColor: uiCardDark,
  textTheme: const TextTheme(bodyMedium: TextStyle(color: textLight)),
  colorScheme: const ColorScheme.dark(
    primary: primaryColor,
    secondary: secondaryColor,
    surface: uiCardDark,
    error: danger,
  ),
);

// ── ThemeColors Extension ─────────────────────────────────────────────────────
extension ThemeColors on BuildContext {
  bool get _isDark => Theme.of(this).brightness == Brightness.dark;

  Color get backgroundColor => _isDark ? uiBackgroundDark : uiBackgroundLight;
  Color get primary         => primaryColor;
  Color get cardColor       => _isDark ? uiCardDark     : uiCardLight;
  Color get cardGrayColor   => _isDark ? uiCardGrayDark : uiCardGrayLight;
  Color get borderColor     => _isDark ? uiBorderDark   : uiBorderLight;
  Color get textColor       => _isDark ? textLight      : textMain;

  List<BoxShadow> get shadows => _isDark ? darkShadows : lightShadows;
  BoxBorder       get border  => _isDark ? borderDark  : borderLight;
}
