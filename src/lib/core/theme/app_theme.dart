// src/lib/core/theme/app_theme.dart
// NailMuse brand theme: colours and fonts (see STYLE_GUIDE.md section 10).
// Fonts (Lora, Poppins) are bundled as files in assets/fonts, so no extra package is needed.

import 'package:flutter/material.dart';

/// Brand colours. Use these names in screens, never raw hex values.
class AppColors {
  // Brand colours (team choice)
  static const nightBordeaux = Color(0xFF5B0015); // primary: app bar, main buttons
  static const coolHorizon = Color(0xFF80AEE8); // accent: selected items (use Bordeaux text on it)
  static const ivoryMist = Color(0xFFF7F2E0); // screen background
  // Helper colours
  static const skyTint = Color(0xFFDCE8F8); // chips, photo boxes (light Horizon)
  static const ink = Color(0xFF2A1A1D); // body text
  static const border = Color(0xFFD9D2BC); // borders, dividers
  static const sage = Color(0xFF3F6B4C); // success
  static const error = Color(0xFFC62828); // error
}

class AppTheme {
  static const _heading = 'Lora';
  static const _body = 'Poppins';

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.nightBordeaux,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.nightBordeaux,
      onPrimary: Colors.white,
      secondary: AppColors.coolHorizon,
      onSecondary: AppColors.nightBordeaux,
      secondaryContainer: AppColors.skyTint,
      onSecondaryContainer: AppColors.nightBordeaux,
      surface: AppColors.ivoryMist,
      onSurface: AppColors.ink,
      error: AppColors.error,
      onError: Colors.white,
    );

    final base = ThemeData(brightness: Brightness.light).textTheme;
    final body = base.apply(
      fontFamily: _body,
      bodyColor: AppColors.ink,
      displayColor: AppColors.ink,
    );
    TextStyle? lora(TextStyle? s, FontWeight w) =>
        s?.copyWith(fontFamily: _heading, fontWeight: w);
    final textTheme = body.copyWith(
      displayLarge: lora(body.displayLarge, FontWeight.w700),
      displayMedium: lora(body.displayMedium, FontWeight.w700),
      displaySmall: lora(body.displaySmall, FontWeight.w600),
      headlineLarge: lora(body.headlineLarge, FontWeight.w700),
      headlineMedium: lora(body.headlineMedium, FontWeight.w600),
      headlineSmall: lora(body.headlineSmall, FontWeight.w600),
      titleLarge: lora(body.titleLarge, FontWeight.w600),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.ivoryMist,
      fontFamily: _body,
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.nightBordeaux,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontFamily: _heading,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.nightBordeaux,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
          textStyle:
              const TextStyle(fontFamily: _body, fontWeight: FontWeight.w500),
        ),
      ),
      chipTheme: const ChipThemeData(
        backgroundColor: AppColors.skyTint,
        selectedColor: AppColors.coolHorizon,
        labelStyle: TextStyle(fontFamily: _body, color: AppColors.nightBordeaux),
        secondaryLabelStyle:
            TextStyle(fontFamily: _body, color: AppColors.nightBordeaux),
        shape: StadiumBorder(),
        side: BorderSide(color: AppColors.border),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}
