import 'package:flutter/material.dart';

import '../dimens.dart';

// ignore: avoid_classes_with_only_static_members
/// Base of darkTheme
class MaterialDarkTheme {
  /// Get Theme Data
  static ThemeData data(Color primaryColor) => ThemeData.dark().copyWith(
        primaryColor: primaryColor,
//        textTheme: text,
        inputDecorationTheme: inputDecoration,
      );

  /// Card theme
  static CardTheme card = CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.dp8),
        side: BorderSide.none,
      ));

  /// Text Theme
  static TextTheme text = const TextTheme(
    // Use for body text
    titleLarge: TextStyle(
      fontSize: Dimens.dp12,
    ),
    titleMedium: TextStyle(
      fontSize: Dimens.dp12,
    ),
    // Use for heading text
    titleSmall: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: Dimens.dp20,
    ),
    // Use for title text
  );

  /// Input Decoration Theme
  static InputDecorationTheme inputDecoration = InputDecorationTheme(
    border: OutlineInputBorder(
      // borderSide: BorderSide(color: AppColors.blueColor),
      borderRadius: BorderRadius.circular(Dimens.dp4),
    ),
    enabledBorder: OutlineInputBorder(
      // borderSide: BorderSide(color: AppColors.blueColor),
      borderRadius: BorderRadius.circular(Dimens.dp8),
    ),
    focusedBorder: OutlineInputBorder(
      // borderSide: BorderSide(color: AppColors.blueColor),
      borderRadius: BorderRadius.circular(Dimens.dp8),
    ),
    errorBorder: OutlineInputBorder(
      // borderSide: BorderSide(color: AppColors.redColor, width: 1),
      borderRadius: BorderRadius.circular(Dimens.dp8),
    ),
  );
}
