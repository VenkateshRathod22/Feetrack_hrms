import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

// Current application theme.
bool get _isDark => Get.isDarkMode;

// =========================================================
// PRIMARY COLORS
// =========================================================

Color get primaryColor =>
    _isDark ? const Color(0xFF8AB4FF) : const Color(0xFF021A45);

Color get tertiaryColor =>
    _isDark ? const Color(0xFF8AB4FF) : const Color(0xFF0052D9);

Color get secondaryColor =>
    _isDark ? const Color(0xFF5EEAD4) : const Color(0xFF0D9488);

Color get backgroundLight =>
    _isDark ? const Color(0xCC0E1420) : const Color(0xFFF4F5F7);

// =========================================================
// BACKGROUND AND SURFACE COLORS
// =========================================================

Color get appBackground =>
    _isDark ? const Color(0xFF0E1420) : const Color(0xFFF4F5F7);

Color get surfaceColor => _isDark ? const Color(0xFF171F2D) : Colors.white;

Color get cardColor => _isDark ? const Color(0xFF1B2637) : Colors.white;

Color get inputBackgroundColor =>
    _isDark ? const Color(0xFF202B3B) : const Color(0xFFF7F8FA);

Color get borderColor =>
    _isDark ? const Color(0xFF354257) : const Color(0xFFE2E8F0);

Color get dividerColor =>
    _isDark ? const Color(0xFF303B4D) : const Color(0xFFE2E8F0);

// Keep these literal colors for places that specifically require black/white.
Color get black => _isDark ? Colors.white : Colors.black;
Color get white => _isDark ? const Color(0xCC0E1420) : Colors.white;

// =========================================================
// TEXT COLORS
// =========================================================

Color get greyDart2 =>
    _isDark ? const Color(0xFFD0D9E8) : const Color(0xFF434654);

Color get greyDart =>
    _isDark ? const Color(0xFFB8C5D9) : const Color(0xFF73777F);

Color get greyDart3 =>
    _isDark ? const Color(0xFFB8C5D9) : const Color(0xFF475569);

Color get greyText =>
    _isDark ? const Color(0xFFA8B4C8) : const Color(0xFF43474E);

Color get greyText2 =>
    _isDark ? const Color(0xFFA8B4C8) : const Color(0xFF434750);

Color get blackText1 =>
    _isDark ? const Color(0xFFE8EDF5) : const Color(0xFF334155);

Color get blackText2 =>
    _isDark ? const Color(0xFFE8EDF5) : const Color(0xFF171717);

Color get blackText3 =>
    _isDark ? const Color(0xFFE8EDF5) : const Color(0xFF191C1E);

Color get blackText4 =>
    _isDark ? const Color(0xFFE8EDF5) : const Color(0xFF1E293B);

Color get textPrimary =>
    _isDark ? const Color(0xFFE8EDF5) : const Color(0xFF000000);

Color get textSecondary =>
    _isDark ? const Color(0xFFA8B4C8) : const Color(0xFF838383);

// =========================================================
// BLUE COLORS
// =========================================================

Color get blueLight3 =>
    _isDark ? const Color(0xFF8AB4FF) : const Color(0xFF003DA6);

Color get blueDark2 =>
    _isDark ? const Color(0xFFB8C9E8) : const Color(0xFF36446E);

Color get blueDark1 =>
    _isDark ? const Color(0xFF8AB4FF) : const Color(0xFF1E40AF);

Color get textBlue =>
    _isDark ? const Color(0xFF8AB4FF) : const Color(0xFF003B73);

Color get defaultColor => tertiaryColor;

// =========================================================
// PURPLE COLORS
// =========================================================

Color get purpleLight =>
    _isDark ? const Color(0xFF39304D) : const Color(0xFFEADDFF);

Color get purple => const Color(0xFF484AD6);

Color get purple2 =>
    _isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA);

Color get deepPurple => _isDark ? const Color(0xFFB39DDB) : Colors.deepPurple;

// =========================================================
// GREY COLORS
// =========================================================

Color get grey => _isDark ? const Color(0xFFA0A8B5) : const Color(0xFF999999);

Color get greyLight =>
    _isDark ? const Color(0xFF252D3A) : const Color(0xFFF6F3F2);

Color get greyLight1 =>
    _isDark ? const Color(0xFF202C3D) : const Color(0xFFEFF6FF);

Color get greyLight2 =>
    _isDark ? const Color(0xFF364255) : const Color(0xFFC3C6D1);

Color get greyLight3 =>
    _isDark ? const Color(0xFF29313E) : const Color(0xFFEBE7E7);

Color get greyLight4 =>
    _isDark ? const Color(0xFF202B3B) : const Color(0xFFF1F5F9);

Color get greyLight5 =>
    _isDark ? const Color(0xFFA8B4C8) : const Color(0xFF94A3B8);

Color get greyLight6 =>
    _isDark ? const Color(0xFF394458) : const Color(0xFFC3C6D7);

Color get greyLight7 =>
    _isDark ? const Color(0xFF202733) : const Color(0xFFF3F4F6);

Color get greyLight8 =>
    _isDark ? const Color(0xFFA8B4C8) : const Color(0xFF64748B);

// =========================================================
// PINK COLORS
// =========================================================

Color get pinLight =>
    _isDark ? const Color(0xFF342731) : const Color(0xFFFBF1F2);

Color get pinkLight2 =>
    _isDark ? const Color(0xFF3B302B) : const Color(0xFFFFEDD5);

// =========================================================
// GREEN COLORS
// =========================================================

Color get green => _isDark ? const Color(0xFF6EE7B7) : const Color(0xFF006C49);

Color get green2 => _isDark ? const Color(0xFF4ADE80) : const Color(0xFF0E9A41);

Color get greenDark =>
    _isDark ? const Color(0xFF5EEAD4) : const Color(0xFF006A61);

Color get greenDark1 => greenDark;

Color get greenDark2 =>
    _isDark ? const Color(0xFF86EFAC) : const Color(0xFF1E7E34);

Color get greenLight =>
    _isDark ? const Color(0xFF86EFAC) : const Color(0xFF108548);

// =========================================================
// YELLOW AND ORANGE COLORS
// =========================================================

Color get yellow => _isDark ? const Color(0xFFFBBF24) : const Color(0xFFF59E0B);

Color get goldColor => const Color(0xFFFFB400);

Color get organ => const Color(0xFFF97316);

// =========================================================
// RED COLORS
// =========================================================

Color get red => _isDark ? const Color(0xFFFF8A80) : Colors.red;

Color get red1 => _isDark ? const Color(0xFFFF8FAB) : const Color(0xFFE11D48);

Color get redDark =>
    _isDark ? const Color(0xFFFF8A80) : const Color(0xFFBA1A1A);

// =========================================================
// INPUT COLORS
// =========================================================

Color get textBox =>
    _isDark ? const Color(0xFF283448) : Colors.grey.withValues(alpha: 0.30);

// =========================================================
// ATTENDANCE STATUS COLORS
// =========================================================

Color get notPunchIn =>
    _isDark ? const Color(0xFF8AB4FF) : const Color(0xFF2563EB);

Color get punchIn =>
    _isDark ? const Color(0xFFFBBF24) : const Color(0xFFF59E0B);

Color get punchOut =>
    _isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A);

Color get shortLeave =>
    _isDark ? const Color(0xFFFB923C) : const Color(0xFFF97316);

Color get halfDay =>
    _isDark ? const Color(0xFF38BDF8) : const Color(0xFF0EA5E9);

Color get absent => _isDark ? const Color(0xFFF87171) : const Color(0xFFEF4444);

Color get leave => _isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA);

Color get holiday =>
    _isDark ? const Color(0xFF4ADE80) : const Color(0xFF0E9A41);

Color get weekOff =>
    _isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);

// =========================================================
// ATTENDANCE STATUS COLORS
// =========================================================

Color get shimmerBase =>
    _isDark ? const Color(0xFF2A2A2A) : const Color(0xFFEBEBF4);

Color get shimmerHighlight =>
    _isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF4F4F4);

// const Color primaryColor = const Color(0xFF021A45);
// Color tertiaryColor = Color(0xFF0052D9);

// Color secondaryColor = const Color(0xFF0D9488);
// Color backgroundDark = const Color(0xff231F20);
// Color backgroundLight = const Color(0xFFF4F5F7);

// //black
// const Color black = Colors.black;

// //* white Colors
// Color white = Colors.white;
// Color whiteSmoke = const Color(0xFFF5ECED);

// //* Blue Colors

// Color blueLight3 = const Color(0xFF003DA6);
// Color blueDark2 = const Color(0xFF36446E);
// Color blueDark1 = const Color(0xFF1E40AF);

// //* purple Colors
// Color purpleLight = const Color(0xFFEADDFF);
// Color purple = const Color(0xFF484AD6);
// Color purple2 = const Color(0xFF9333EA);
// Color deepPurple = Colors.deepPurple;

// //* Grey Colors
// Color grey = const Color(0xFF999999);
// Color greyLight = const Color(0xFFF6F3F2);
// Color greyLight1 = const Color(0xFFEFF6FF);
// Color greyLight2 = const Color(0xFFC3C6D1);
// Color greyLight3 = const Color(0xFFEBE7E7);
// Color greyLight4 = const Color(0xFFF1F5F9);
// Color greyLight5 = const Color(0xFF94A3B8);
// Color greyLight6 = const Color(0xFFC3C6D7);
// Color greyLight7 = const Color(0xFFF3F4F6);
// Color greyLight8 = const Color(0xFF64748B);
// Color greyDart = const Color(0xFF73777F);
// Color greyDart2 = const Color(0xFF434654);
// Color greyDart3 = const Color(0xFF475569);

// //* pink color
// Color pinLight = const Color(0xFFFBF1F2);
// Color pinkLight2 = const Color(0xFFFFEDD5);

// //* Green colors
// const Color green = Color(0xFF006C49);
// const Color green2 = Color(0xFF0E9A41);
// const Color greenDark = Color(0xFF006A61);
// const Color greenDark1 = Color(0xFF006A61);
// const Color greenDark2 = Color(0xFF1E7E34);
// const Color greenLight = Color(0xFF108548);

// //* Yellow colors
// const Color yellow = Color(0xFFF59E0B);
// const Color goldColor = Color(0xFFFFB400);

// //* Organ colors
// const Color organ = Color(0xFFF97316);

// //* red colorsp
// const Color red = Colors.red;
// const Color red1 = Color(0xFFE11D48);
// const Color redDark = Color(0xFFBA1A1A);

// //* Textbox colors
// Color textBox = Colors.grey.withValues(alpha: 0.30);
// const Color textBlue = Color(0xff003B73);

// //* Text Colors
// Color greyText = const Color(0xFF43474E);
// Color greyText2 = const Color(0xFF434750);

// Color blackText1 = const Color(0xFF334155);
// Color blackText2 = const Color(0xFF171717);
// Color blackText3 = const Color(0xFF191C1E);
// Color blackText4 = const Color(0xFF1E293B);

// const Color textPrimary = Color(0xff000000);
// const Color textSecondary = Color(0xff838383);

// //* Status color
// const Color notPunchIn = Color(0xFF2563EB); // Blue

// const Color punchIn = Color(0xFFF59E0B); // Orange

// const Color punchOut = Color(0xFF16A34A); // Green

// const Color shortLeave = Color(0xFFF97316); // Purple

// const Color halfDay = Color(0xFF0EA5E9); // Sky Blue

// const Color absent = Color(0xFFEF4444); // Red

// Color leave = purple2; // Primary Blue

// const Color holiday = green2; // Teal

// const Color weekOff = Color(0xFF6B7280); // Gray

// const Color defaultColor = Color(0xFF0052D9);

Map<int, Color> color = const {
  50: Color.fromRGBO(255, 244, 149, .1),
  100: Color.fromRGBO(255, 244, 149, .2),
  200: Color.fromRGBO(255, 244, 149, .3),
  300: Color.fromRGBO(255, 244, 149, .4),
  400: Color.fromRGBO(255, 244, 149, .5),
  500: Color.fromRGBO(255, 244, 149, .6),
  600: Color.fromRGBO(255, 244, 149, .7),
  700: Color.fromRGBO(255, 244, 149, .8),
  800: Color.fromRGBO(255, 244, 149, .9),
  900: Color.fromRGBO(255, 244, 149, 1),
};
MaterialColor colorCustom = MaterialColor(0XFFFFF495, color);

class CustomTheme {
  static ThemeData light = ThemeData(
    fontFamily: "Montserrat",
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundLight,
    hintColor: Colors.grey[700],
    primarySwatch: colorCustom,
    canvasColor: secondaryColor,
    primaryColorLight: secondaryColor,
    splashColor: secondaryColor,
    shadowColor: Colors.grey[600],
    cardColor: Colors.grey[100],
    primaryColor: primaryColor,
    dividerColor: Colors.grey[600],
    primaryColorDark: Colors.black,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.black,
      error: const Color(0xFFCF6679),
      onError: const Color(0xFFCF6679),
      background: backgroundLight,
      onBackground: Colors.black,
      surface: backgroundLight,
      onSurface: Colors.black,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      actionsIconTheme: IconThemeData(
        color: black,
      ),
      iconTheme: IconThemeData(
        color: black,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: primaryColor,
        // Status bar brightness (optional)
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    ),
    typography: Typography.material2021(),
    textTheme: TextTheme(
      // Buttons / labels
      labelLarge: GoogleFonts.openSans(
        fontWeight: FontWeight.w800,
        color: textSecondary,
        fontSize: 14,
      ),
      labelMedium: GoogleFonts.openSans(
        fontWeight: FontWeight.w700,
      ),
      labelSmall: GoogleFonts.openSans(
        fontWeight: FontWeight.w500,
      ),

      // Large headings (screen titles)
      headlineLarge: GoogleFonts.montserrat(
        fontWeight: FontWeight.w800,
      ),

      headlineMedium: GoogleFonts.montserrat(
        fontWeight: FontWeight.w700,
      ),

      headlineSmall: GoogleFonts.montserrat(
        fontWeight: FontWeight.w600,
      ),

      // Big display text / hero banners
      displayLarge: GoogleFonts.montserrat(
        fontWeight: FontWeight.w900,
      ),

      displayMedium: GoogleFonts.montserrat(
        fontWeight: FontWeight.w700,
      ),

      displaySmall: GoogleFonts.montserrat(
        fontWeight: FontWeight.w600,
      ),

      // AppBar / section titles
      titleLarge: GoogleFonts.montserrat(
        fontWeight: FontWeight.w800,
      ),

      titleMedium: GoogleFonts.montserrat(
        fontWeight: FontWeight.w700,
      ),

      titleSmall: GoogleFonts.montserrat(
        fontWeight: FontWeight.w600,
      ),

      // Main app content
      bodyLarge: GoogleFonts.manrope(
        fontWeight: FontWeight.w600,
      ),

      bodyMedium: GoogleFonts.manrope(
        fontWeight: FontWeight.w500,
      ),

      bodySmall: GoogleFonts.manrope(
        fontWeight: FontWeight.w400,
      ),
    ),
  );

  static ThemeData dark = ThemeData(
    fontFamily: "Montserrat",
    brightness: Brightness.dark,
    useMaterial3: true,

    // Background Colors
    scaffoldBackgroundColor: const Color(0xFF0E1420),
    canvasColor: const Color(0xFF171F2D),
    cardColor: const Color(0xFF1B2637),

    // Primary and Accent Colors
    primaryColor: const Color(0xFF8AB4FF),
    primaryColorLight: const Color(0xFF5EEAD4),
    primaryColorDark: const Color(0xFFF1F5F9),

    splashColor: const Color(0x225EEAD4),
    shadowColor: Colors.black.withValues(alpha: 0.25),
    dividerColor: const Color(0xFF303B4D),
    hintColor: const Color(0xFF8B97AB),

    // Material 3 Color Scheme
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF8AB4FF),
      onPrimary: Color(0xFF102544),
      secondary: Color(0xFF5EEAD4),
      onSecondary: Color(0xFF063B35),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      surface: Color(0xFF171F2D),
      onSurface: Color(0xFFE8EDF5),
    ),

    // App Bar
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0E1420),
      foregroundColor: Color(0xFFE8EDF5),
      elevation: 0,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
      actionsIconTheme: IconThemeData(
        color: Color(0xFFE8EDF5),
      ),
      iconTheme: IconThemeData(
        color: Color(0xFFE8EDF5),
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Color(0xFF0E1420),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),

    // General Icons
    iconTheme: const IconThemeData(
      color: Color(0xFFB8C5D9),
    ),

    // Dividers
    dividerTheme: const DividerThemeData(
      color: Color(0xFF303B4D),
      thickness: 1,
      space: 1,
    ),

    // Input Fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1B2637),
      hintStyle: GoogleFonts.manrope(
        color: const Color(0xFF8B97AB),
        fontSize: 13,
      ),
      labelStyle: GoogleFonts.manrope(
        color: const Color(0xFFB8C5D9),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF354257),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF354257),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF8AB4FF),
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFFFB4AB),
        ),
      ),
    ),

    // Elevated Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF8AB4FF),
        foregroundColor: const Color(0xFF102544),
        disabledBackgroundColor: const Color(0xFF293448),
        disabledForegroundColor: const Color(0xFF8490A4),
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.montserrat(
          fontWeight: FontWeight.w700,
        ),
      ),
    ),

    // Outlined Buttons
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF8AB4FF),
        side: const BorderSide(
          color: Color(0xFF526B91),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    // Bottom Navigation
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF171F2D),
      selectedItemColor: Color(0xFF8AB4FF),
      unselectedItemColor: Color(0xFF8B97AB),
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),

    // Material Typography
    typography: Typography.material2021(),

    textTheme: TextTheme(
      // Buttons and Labels
      labelLarge: GoogleFonts.openSans(
        fontWeight: FontWeight.w700,
        color: const Color(0xFFE8EDF5),
        fontSize: 14,
      ),
      labelMedium: GoogleFonts.openSans(
        fontWeight: FontWeight.w600,
        color: const Color(0xFFD0D9E8),
      ),
      labelSmall: GoogleFonts.openSans(
        fontWeight: FontWeight.w500,
        color: const Color(0xFFA8B4C8),
      ),

      // Main Headings
      headlineLarge: GoogleFonts.montserrat(
        fontWeight: FontWeight.w800,
        color: const Color(0xFFF8FAFC),
      ),
      headlineMedium: GoogleFonts.montserrat(
        fontWeight: FontWeight.w700,
        color: const Color(0xFFF1F5F9),
      ),
      headlineSmall: GoogleFonts.montserrat(
        fontWeight: FontWeight.w600,
        color: const Color(0xFFE8EDF5),
      ),

      // Display Text
      displayLarge: GoogleFonts.montserrat(
        fontWeight: FontWeight.w900,
        color: const Color(0xFFF8FAFC),
      ),
      displayMedium: GoogleFonts.montserrat(
        fontWeight: FontWeight.w700,
        color: const Color(0xFFF1F5F9),
      ),
      displaySmall: GoogleFonts.montserrat(
        fontWeight: FontWeight.w600,
        color: const Color(0xFFE8EDF5),
      ),

      // App Bar and Section Titles
      titleLarge: GoogleFonts.montserrat(
        fontWeight: FontWeight.w800,
        color: const Color(0xFFF1F5F9),
      ),
      titleMedium: GoogleFonts.montserrat(
        fontWeight: FontWeight.w700,
        color: const Color(0xFFE8EDF5),
      ),
      titleSmall: GoogleFonts.montserrat(
        fontWeight: FontWeight.w600,
        color: const Color(0xFFD0D9E8),
      ),

      // Main Content
      bodyLarge: GoogleFonts.manrope(
        fontWeight: FontWeight.w600,
        color: const Color(0xFFE8EDF5),
      ),
      bodyMedium: GoogleFonts.manrope(
        fontWeight: FontWeight.w500,
        color: const Color(0xFFD0D9E8),
      ),
      bodySmall: GoogleFonts.manrope(
        fontWeight: FontWeight.w400,
        color: const Color(0xFFA8B4C8),
      ),
    ),
  );
}
