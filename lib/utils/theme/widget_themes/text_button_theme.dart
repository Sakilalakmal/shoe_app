import 'package:flutter/material.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';


class TTextButtonTheme {
   
  TTextButtonTheme._(); // To avoid creating instances

  /* -- Light Theme -- */
  static final lightTextButtonTheme = TextButtonThemeData(
   
    style: TextButton.styleFrom(
      foregroundColor: Color(0xFF4B68FF), // Brand Blue (main action color)
      textStyle: const TextStyle(
        fontSize: TSizes.fontSizeMd,
        fontWeight: FontWeight.w600, // modern semi-bold
      ),
      padding: const EdgeInsets.symmetric(
        vertical: TSizes.buttonHeight / 2, // balanced padding
        horizontal: TSizes.buttonRadius,   // horizontal spacing
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
      ),
    ),
  );

  /* -- Dark Theme -- */
  static final darkTextButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Color(0xFF4B68FF), // Keep blue consistent in dark mode
      textStyle: const TextStyle(
        fontSize: TSizes.fontSizeMd,
        fontWeight: FontWeight.w600,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: TSizes.buttonHeight / 2,
        horizontal: TSizes.buttonRadius,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
      ),
    ),
  );
}
