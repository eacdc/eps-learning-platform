import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/constant.dart';

class AppTheme {
  /// 🌞 Light Color Scheme
  static final ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primarycolor,
    onPrimary: const Color(0xFF333333),
    primaryContainer: textWhite,
    onPrimaryContainer: const Color(0xFF333333),

    secondary: const Color(0xFF3B9DFF),
    onSecondary: const Color(0xFFF3F3F3),
    secondaryContainer: textWhiteGrey,
    onSecondaryContainer: const Color(0xFF333333),

    error: Colors.redAccent,
    onError: Colors.white,
    errorContainer: Colors.redAccent,
    onErrorContainer: const Color(0xFFF9DEDC),

    outline: const Color(0xFF6F6D73),

    // ✅ replace deprecated background/onBackground
    surface: whitecolor,
    onSurface: const Color(0xFF333333),

    surfaceContainerHighest: const Color(0xFFF3F3F3),
    surfaceVariant: const Color(0xFF57545B),
    onSurfaceVariant: const Color(0xFF757575),

    // new required properties in Material 3
    tertiary: const Color(0xFF7D5260),
    onTertiary: Colors.white,
    tertiaryContainer: const Color(0xFFFFDAD7),
    onTertiaryContainer: const Color(0xFF31111D),

    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: const Color(0xFF1C1B1F),
    onInverseSurface: const Color(0xFFF3F3F3),
    inversePrimary: primarycolor,
  );

  /// 🌙 Dark Color Scheme
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primarycolor,
    onPrimary: whitecolor,
    primaryContainer: whitecolor,
    onPrimaryContainer: Color(0xFF333333),

    secondary: Color(0xFF3B9DFF),
    onSecondary: Color(0xFFF3F3F3),
    secondaryContainer: textBlack,
    onSecondaryContainer: whitecolor,


    error: Colors.redAccent,
    onError: Colors.white,
    errorContainer: Colors.redAccent,
    onErrorContainer: Color(0xFFF9DEDC),

    outline: Color(0xFF938F99),

    // ✅ replace deprecated background/onBackground
    surface: Color(0xFF333333),
    onSurface: Color(0xFFF3F3F3),

    surfaceContainerHighest: Color(0xFF1C1B1F),
    surfaceVariant: Color(0xFF49454F),
    onSurfaceVariant: Color(0xFFCAC4D0),

    // new required properties in Material 3
    tertiary: Color(0xFF7D5260),
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFF633B48),
    onTertiaryContainer: Color(0xFFFFDAD7),

    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFFE6E1E5),
    onInverseSurface: Color(0xFF1C1B1F),
    inversePrimary: primarycolor,

    
  );

  /// 🎨 ThemeData wrappers
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    fontFamily: Constants.fontFamily,
    colorScheme: lightColorScheme,
    dividerColor: textWhiteGrey,
    bottomAppBarTheme: const BottomAppBarTheme(
      color: textWhiteGrey,
      elevation: 4,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: lightColorScheme.surface, // Light theme AppBar color
      foregroundColor: Colors.black, // Title / icons color
      // surfaceTintColor: Colors.transparent,
      //  elevation: 20,
    ),
  );

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    fontFamily: Constants.fontFamily,
    colorScheme: darkColorScheme,
    dividerColor: graydark.withAlpha(100),
    bottomAppBarTheme: const BottomAppBarTheme(color: textBlack, elevation: 4),
    appBarTheme: AppBarTheme(
      backgroundColor: darkColorScheme.surface, // Dark theme AppBar color
      foregroundColor: Colors.white, // Title / icons color
      //surfaceTintColor: Colors.transparent,
      // elevation: 20,
    ),
  );
}


/* theme: ThemeData(
        fontFamily: Constants.fontFamily,
        primaryColor: primarycolor,
        cardColor: primarycolor,
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          color: primarycolor,
          foregroundColor: Colors.white,
         // backgroundColor: whitecolor 
          /* systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarIconBrightness: Brightness.light,
                  ) */
          
        ),
      ), */


//primary: primarycolor,                // Main brand color (buttons, highlights, etc.)
//onPrimary: Color(0xFF333333),         // Text/icon color when drawn ON TOP of primary
//primaryContainer: whitecolor,         // Background container with a variant of primary
//onPrimaryContainer: Color(0xFF333333),// Text/icon color when drawn ON primaryContainer

//secondary: Color(0xFF3B9DFF),         // Secondary brand/accent color
//onSecondary: Color(0xFFF3F3F3),       // Text/icon color ON secondary color
//secondaryContainer: whitecolor,       // A container background for secondary
//nSecondaryContainer: Color(0xFF333333), // Text/icon color on secondary container