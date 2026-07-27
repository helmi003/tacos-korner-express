import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ── Brand / Primary ──────────────────────────────────────────────────────────
const Color primaryColor = Color(0xFFEC1D23); // Red
const Color primaryDark = Color(0xFFC01019); // Dark Red
const Color primaryLight = Color(0xFFFF6B70); // Light Red
const Color primaryBgLight = Color(0xFFFFF0F0); // Light Red tint (bg use)
const Color primaryBgDark = Color(0xFF2D0608); // Dark Red tint (bg use)

// ── Secondary ────────────────────────────────────────────────────────────────
const Color secondaryColor = Color(0xFFA67B36); // Gold
const Color secondaryDark = Color(0xFF725427); // Dark Gold
const Color secondaryLight = Color(0xFFFFBE59); // Light Gold

// ── Tertiary ─────────────────────────────────────────────────────────────────
const Color tertiaryColor = Color(0xFF2596BE); // Blue
const Color tertiaryDark = Color(0xFF1A7A9E); // Dark Blue

// ── Accent (Light Mode) ────────────────────────────────────────────────────
const Color accentAmberLight = Color(0xFFF59E0B);
const Color accentBlueLight = Color(0xFF2596BE);
const Color accentGreenLight = Color(0xFF10B981);
const Color accentPurpleLight = Color(0xFFA855F7);
const Color accentOrangeLight = Color(0xFFF59E0B);
const Color accentRedLight = Color(0xFFEC1D23);

// ── Accent (Dark Mode) ─────────────────────────────────────────────────────
const Color accentAmberDark = Color(0xFFFBBF24);
const Color accentBlueDark = Color(0xFF5CB0CE);
const Color accentGreenDark = Color(0xFF34D399);
const Color accentPurpleDark = Color(0xFFC084FC);
const Color accentOrangeDark = Color(0xFFFBBF24);
const Color accentRedDark = primaryLight;

/// Fixed darker-amber shade for gradients/decorative use — not theme-reactive.
const Color accentAmberShade = Color(0xFFD97706);

// ── Accent Backgrounds (Light Mode) ────────────────────────────────────────
const Color accentBlueBgLight = Color(0xFFEFF6FF);
const Color accentGreenBgLight = Color(0xFFECFDF5);
const Color accentPurpleBgLight = Color(0xFFF3E8FF);
const Color accentOrangeBgLight = Color(0xFFFFF5E6);
const Color accentRedBgLight = Color(0xFFFDF4F3);

// ── Accent Backgrounds (Dark Mode) ─────────────────────────────────────────
const Color accentBlueBgDark = Color(0xFF0B1E2E);
const Color accentGreenBgDark = Color(0xFF042E1A);
const Color accentPurpleBgDark = Color(0xFF1A0D2E);
const Color accentOrangeBgDark = Color(0xFF2E1800);
const Color accentRedBgDark = Color(0xFF2D0608);

// ── Text (Light Mode) ─────────────────────────────────────────────────────────
const Color textMain = Color(0xFF1A1A2E);
const Color textBody = Color(0xFF4A5568);
const Color textMuted = Color(0xFF9CA3AF);
const Color textMutedLight = Color(0xFFBEC5CC);
const Color textLight = Color(0xFFF1F5F9);

// ── Text (Dark Mode) ──────────────────────────────────────────────────────────
const Color textBodyDark = Color(0xFFCBD5E1);
const Color textMutedDark = Color(0xFF64748B);
const Color textMutedLightDark = Color(0xFF475569);

// ── Light Mode UI ─────────────────────────────────────────────────────────────
const Color uiBackgroundLight = Color(0xFFF0F2F5);
const Color uiCardLight = Color(0xFFFFFFFF);
const Color uiBorderLight = Color(0xFFE5E7EB);
const Color uiCardGrayLight = Color(0xFFEFEFEA);
const Color uiCardBlueLight = Color(0xFFEAF2FB);

// ── Dark Mode UI ──────────────────────────────────────────────────────────────
const Color uiBackgroundDark = Color(0xFF0F172A);
const Color uiCardDark = Color(0xFF1E293B);
const Color uiBorderDark = Color(0xFF334155);
const Color uiCardGrayDark = Color(0xFF1A2035);
const Color uiCardBlueDark = Color(0xFF16233D);

// ── Status Colors ─────────────────────────────────────────────────────────────
const Color success = Color(0xFF10B981);
const Color successBg = Color(0xFFECFDF5);
const Color successBgDark = Color(0xFF042E1A);
const Color warning = Color(0xFFF59E0B);
const Color warningBg = Color(0xFFFFFBEB);
const Color warningBgDark = Color(0xFF2E1E00);
const Color danger = Color(0xFFEF4444);
const Color dangerBg = Color(0xFFFEF2F2);
const Color dangerBgDark = Color(0xFF2D0A0A);
const Color info = Color(0xFF2596BE);
const Color infoBg = Color(0xFFE0F2FE);
const Color infoBgDark = Color(0xFF0B1E2E);

// ── Shadows ───────────────────────────────────────────────────────────────────
const List<BoxShadow> lightShadows = [
  BoxShadow(color: Color(0x14000000), offset: Offset(0, 4), blurRadius: 20),
];
const List<BoxShadow> darkShadows = [
  BoxShadow(color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 0),
];

final BoxBorder borderDark = Border.all(color: uiBorderDark, width: 0.5.w);
final BoxBorder borderLight = Border.all(color: uiBorderLight, width: 0.5.w);

// ── Gradients ─────────────────────────────────────────────────────────────────
const LinearGradient primaryGradient = LinearGradient(
  colors: [primaryColor, primaryDark],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient secondaryGradient = LinearGradient(
  colors: [tertiaryColor, tertiaryDark],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient amberGradient = LinearGradient(
  colors: [accentAmberLight, accentAmberShade],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient greenGradient = LinearGradient(
  colors: [accentGreenLight, Color(0xFF059669)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient gradientDark = LinearGradient(
  colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient emergencyGradient = LinearGradient(
  colors: [accentRedLight, primaryDark],
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

  // ── Core ─────────────────────────────────────────────────────────────────
  bool get isDark => _isDark;
  Color get backgroundColor => _isDark ? uiBackgroundDark : uiBackgroundLight;
  Color get primary => isDark ? primaryDark : primaryColor;
  Color get secondary => isDark ? secondaryDark : secondaryColor;
  Color get tertiary => isDark ? tertiaryDark : tertiaryColor;
  Color get cardColor => _isDark ? uiCardDark : uiCardLight;
  Color get cardGrayColor => _isDark ? uiCardGrayDark : uiCardGrayLight;
  Color get cardBlueColor => _isDark ? uiCardBlueDark : uiCardBlueLight;
  Color get borderColor => _isDark ? uiBorderDark : uiBorderLight;
  Color get textColor => _isDark ? textLight : textMain;
  Color get textBodyColor => _isDark ? textBodyDark : textBody;
  Color get textMutedColor => _isDark ? textMutedDark : textMuted;
  Color get textMutedLightColor =>
      _isDark ? textMutedLightDark : textMutedLight;
  List<BoxShadow> get shadows => _isDark ? darkShadows : lightShadows;
  BoxBorder get border => _isDark ? borderDark : borderLight;

  // ── Accent (solid) ────────────────────────────────────────────────────────
  Color get accentAmber => _isDark ? accentAmberDark : accentAmberLight;
  Color get accentBlue => _isDark ? accentBlueDark : accentBlueLight;
  Color get accentGreen => _isDark ? accentGreenDark : accentGreenLight;
  Color get accentPurple => _isDark ? accentPurpleDark : accentPurpleLight;
  Color get accentOrange => _isDark ? accentOrangeDark : accentOrangeLight;
  Color get accentRed => _isDark ? accentRedDark : accentRedLight;

  // ── Accent backgrounds ────────────────────────────────────────────────────
  Color get primaryBgColor => _isDark ? primaryBgDark : primaryBgLight;
  Color get accentGreenBgColor =>
      _isDark ? accentGreenBgDark : accentGreenBgLight;
  Color get accentBlueBgColor => _isDark ? accentBlueBgDark : accentBlueBgLight;
  Color get accentPurpleBgColor =>
      _isDark ? accentPurpleBgDark : accentPurpleBgLight;
  Color get accentOrangeBgColor =>
      _isDark ? accentOrangeBgDark : accentOrangeBgLight;
  Color get accentRedBgColor => _isDark ? accentRedBgDark : accentRedBgLight;

  // ── Status backgrounds ────────────────────────────────────────────────────
  Color get dangerBgColor => _isDark ? dangerBgDark : dangerBg;
  Color get successBgColor => _isDark ? successBgDark : successBg;
  Color get warningBgColor => _isDark ? warningBgDark : warningBg;
  Color get infoBgColor => _isDark ? infoBgDark : infoBg;

  // ── Misc ──────────────────────────────────────────────────────────────────
  /// Dashed receipt divider — slightly warm grey in light mode.
  Color get receiptDividerColor =>
      _isDark ? uiBorderDark : const Color(0xFFD0D0C8);
}
