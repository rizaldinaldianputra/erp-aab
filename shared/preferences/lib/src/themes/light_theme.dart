// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';

import '../dimens.dart';

// ignore: avoid_classes_with_only_static_members
/// Base of Light Theme
class MaterialLightTheme {
  /// Color primary
  static const Color primaryColor = Color(0xFF4F8CF6);
  static const Color primaryLightColor = Color(0xFF4F8CF6);
  static const Color textColor = Color(0xFF3C3C3C);
  static const Color disabledColor = Color(0xFF838383);

  /// Get theme data
  static ThemeData data = ThemeData.light().copyWith(
    primaryColor: primaryColor,
    primaryColorLight: primaryLightColor,
    textTheme: text,
    bottomNavigationBarTheme: bottomNav,
    disabledColor: disabledColor,
    bottomSheetTheme: bottomSheet,
    colorScheme: colorScheme,
    floatingActionButtonTheme: fab,
    appBarTheme: appBar,
  );

  /// Color scheme
  ///
  static ColorScheme colorScheme = const ColorScheme.light(
    primary: primaryColor,
    onPrimary: Colors.white,
  );

  /// Floating Action Button
  static FloatingActionButtonThemeData fab =
      const FloatingActionButtonThemeData(
    backgroundColor: primaryColor,
  );

  /// Card theme
  static CardTheme card = CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.dp8),
        side: BorderSide.none,
      ));

  /// AppBar Theme
  static AppBarTheme appBar = AppBarTheme(
    titleTextStyle: text.titleMedium?.copyWith(
      color: primaryColor,
    ),
    foregroundColor: primaryColor,
    backgroundColor: Colors.white,
    elevation: 2,
    shadowColor: disabledColor.withOpacity(0.2),
  );

  static TabBarTheme tabBar = const TabBarTheme(
    labelColor: primaryColor,
  );

  /// Text Theme
  static TextTheme text = const TextTheme(
    // Use for regular text
    titleLarge: TextStyle(
      fontSize: Dimens.dp14,
      color: textColor,
      fontWeight: FontWeight.normal,
    ),
    titleMedium: TextStyle(
      fontSize: Dimens.dp14,
      color: textColor,
      fontWeight: FontWeight.normal,
    ),
    // Use for TitleText
    titleSmall: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: Dimens.dp20,
      color: textColor,
    ),
    // Use for SubTitleText2
  );

  static BottomNavigationBarThemeData bottomNav =
      const BottomNavigationBarThemeData(
    unselectedItemColor: Color(0xFFB9B9B9),
  );

  static BottomSheetThemeData bottomSheet = const BottomSheetThemeData(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Dimens.dp16))),
  );
}
