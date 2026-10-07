import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = const Color(0xFF021A45);
Color tertiaryColor = Color(0xFF0052D9);

Color secondaryColor = const Color(0xFF0D9488);
Color backgroundDark = const Color(0xff231F20);
Color backgroundLight = const Color(0xFFF4F5F7);

//black
const Color black = Colors.black;

//* white Colors
Color white = Colors.white;
Color whiteSmoke = const Color(0xFFF5ECED);

//* Blue Colors

Color blueLight3 = const Color(0xFF003DA6);
Color blueDark2 = const Color(0xFF36446E);
Color blueDark1 = const Color(0xFF1E40AF);

//* purple Colors
Color purpleLight = const Color(0xFFEADDFF);
Color purple = const Color(0xFF484AD6);
Color purple2 = const Color(0xFF9333EA);
Color deepPurple = Colors.deepPurple;

//* Grey Colors
Color grey = const Color(0xFF999999);
Color greyLight = const Color(0xFFF6F3F2);
Color greyLight1 = const Color(0xFFEFF6FF);
Color greyLight2 = const Color(0xFFC3C6D1);
Color greyLight3 = const Color(0xFFEBE7E7);
Color greyLight4 = const Color(0xFFF1F5F9);
Color greyLight5 = const Color(0xFF94A3B8);
Color greyLight6 = const Color(0xFFC3C6D7);
Color greyLight7 = const Color(0xFFF3F4F6);
Color greyLight8 = const Color(0xFF64748B);
Color greyDart = const Color(0xFF73777F);
Color greyDart2 = const Color(0xFF434654);
Color greyDart3 = const Color(0xFF475569);

//* pink color
Color pinLight = const Color(0xFFFBF1F2);
Color pinkLight2 = const Color(0xFFFFEDD5);

//* Green colors
const Color green = Color(0xFF006C49);
const Color green2 = Color(0xFF0E9A41);
const Color greenDark = Color(0xFF006A61);
const Color greenDark1 = Color(0xFF006A61);
const Color greenDark2 = Color(0xFF1E7E34);
const Color greenLight = Color(0xFF108548);

//* Yellow colors
const Color yellow = Color(0xFFF59E0B);
const Color goldColor = Color(0xFFFFB400);

//* Organ colors
const Color organ = Color(0xFFF97316);

//* red colorsp
const Color red = Colors.red;
const Color red1 = Color(0xFFE11D48);
const Color redDark = Color(0xFFBA1A1A);

//* Textbox colors
Color textBox = Colors.grey.withValues(alpha: 0.30);
const Color textBlue = Color(0xff003B73);

//* Text Colors
Color greyText = const Color(0xFF43474E);
Color greyText2 = const Color(0xFF434750);

Color blackText1 = const Color(0xFF334155);
Color blackText2 = const Color(0xFF171717);
Color blackText3 = const Color(0xFF191C1E);
Color blackText4 = const Color(0xFF1E293B);

const Color textPrimary = Color(0xff000000);
const Color textSecondary = Color(0xff838383);

//* Status color
const Color notPunchIn = Color(0xFF2563EB); // Blue

const Color punchIn = Color(0xFFF59E0B); // Orange

const Color punchOut = Color(0xFF16A34A); // Green

const Color shortLeave = Color(0xFFF97316); // Purple

const Color halfDay = Color(0xFF0EA5E9); // Sky Blue

const Color absent = Color(0xFFEF4444); // Red

Color leave = purple2; // Primary Blue

const Color holiday = green2; // Teal

const Color weekOff = Color(0xFF6B7280); // Gray

const Color defaultColor = Color(0xFF0052D9);

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
    appBarTheme: const AppBarTheme(
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
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundDark,
    hintColor: Colors.grey[700],
    primarySwatch: colorCustom,
    canvasColor: secondaryColor,
    primaryColorLight: secondaryColor,
    splashColor: secondaryColor,
    shadowColor: Colors.black45,
    cardColor: Colors.grey[800],
    primaryColor: primaryColor,
    dividerColor: Colors.grey[200],
    primaryColorDark: Colors.white,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.black,
      error: const Color(0xFFCF6679),
      onError: const Color(0xFFCF6679),
      background: backgroundDark,
      onBackground: Colors.white,
      surface: backgroundDark,
      onSurface: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      actionsIconTheme: IconThemeData(
        color: backgroundLight,
      ),
      iconTheme: IconThemeData(
        color: backgroundLight,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: primaryColor,
        // Status bar brightness (optional)
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    ),
    typography: Typography.material2021(),
    textTheme: TextTheme(
      labelLarge: GoogleFonts.openSans(
        fontWeight: FontWeight.w400,
        color: textSecondary,
        fontSize: 14.0,
      ),
      headlineLarge: GoogleFonts.openSans(),
      headlineMedium: GoogleFonts.openSans(),
      headlineSmall: GoogleFonts.openSans(),
      displayLarge: GoogleFonts.openSans(),
      displayMedium: GoogleFonts.openSans(),
      displaySmall: GoogleFonts.openSans(),
      titleLarge: GoogleFonts.openSans(),
      titleMedium: GoogleFonts.openSans(),
      titleSmall: GoogleFonts.openSans(),
      bodyLarge: GoogleFonts.openSans(),
      bodyMedium: GoogleFonts.openSans(),
      bodySmall: GoogleFonts.openSans(),
    ),
  );
}
