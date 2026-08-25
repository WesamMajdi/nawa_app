import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color surface = Color(0xFF0E1511);
  static const Color surfaceDim = Color(0xFF0E1511);
  static const Color surfaceBright = Color(0xFF343B37);
  static const Color surfaceContainerLowest = Color(0xFF09100C);
  static const Color surfaceContainerLow = Color(0xFF161D19);
  static const Color surfaceContainer = Color(0xFF1A211D);
  static const Color surfaceContainerHigh = Color(0xFF252C28);
  static const Color surfaceContainerHighest = Color(0xFF2F3632);
  static const Color onSurface = Color(0xFFDDE4DE);
  static const Color onSurfaceVariant = Color(0xFFBBCAC0);
  static const Color inverseSurface = Color(0xFFDDE4DE);
  static const Color inverseOnSurface = Color(0xFF2B322E);
  static const Color outline = Color(0xFF86948B);
  static const Color outlineVariant = Color(0xFF3C4A42);

  static const Color primary = Color(0xFF50DEA9);
  static const Color onPrimary = Color(0xFF003826);
  static const Color primaryContainer = Color(0xFF12B886);
  static const Color onPrimaryContainer = Color(0xFF00412D);
  static const Color inversePrimary = Color(0xFF006C4D);
  static const Color primaryFixed = Color(0xFF70FBC4);
  static const Color primaryFixedDim = Color(0xFF50DEA9);
  static const Color onPrimaryFixed = Color(0xFF002115);
  static const Color onPrimaryFixedVariant = Color(0xFF005139);

  static const Color secondary = Color(0xFF55DF96);
  static const Color onSecondary = Color(0xFF00391F);
  static const Color secondaryContainer = Color(0xFF00AC69);
  static const Color onSecondaryContainer = Color(0xFF00361E);
  static const Color secondaryFixed = Color(0xFF74FCB0);
  static const Color secondaryFixedDim = Color(0xFF55DF96);
  static const Color onSecondaryFixed = Color(0xFF002110);
  static const Color onSecondaryFixedVariant = Color(0xFF005230);

  static const Color tertiary = Color(0xFFFFB3AD);
  static const Color onTertiary = Color(0xFF640C0F);
  static const Color tertiaryContainer = Color(0xFFF97D75);
  static const Color onTertiaryContainer = Color(0xFF6F1616);
  static const Color tertiaryFixed = Color(0xFFFFDAD6);
  static const Color tertiaryFixedDim = Color(0xFFFFB3AD);
  static const Color onTertiaryFixed = Color(0xFF410003);
  static const Color onTertiaryFixedVariant = Color(0xFF832523);

  static const Color error = Color(0xFFFFB4AB);
  static const Color onError = Color(0xFF690005);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onErrorContainer = Color(0xFFFFDAD6);

  static const Color background = Color(0xFF0E1511);
  static const Color onBackground = Color(0xFFDDE4DE);
  static const Color surfaceVariant = Color(0xFF2F3632);
  static const Color surfaceTint = Color(0xFF50DEA9);
}

class AppTypography {
  AppTypography._();

  static const String fontArabic = 'IBM Plex Sans Arabic';
  static const String fontMono = 'JetBrains Mono';

  static const TextStyle headlineXL = TextStyle(
    fontFamily: fontArabic,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 44 / 32,
  );

  static const TextStyle headlineLG = TextStyle(
    fontFamily: fontArabic,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 32 / 24,
  );

  static const TextStyle headlineMD = TextStyle(
    fontFamily: fontArabic,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
  );

  static const TextStyle bodyLG = TextStyle(
    fontFamily: fontArabic,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 28 / 18,
  );

  static const TextStyle bodyMD = TextStyle(
    fontFamily: fontArabic,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
  );

  static const TextStyle labelMD = TextStyle(
    fontFamily: fontMono,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
  );

  static const TextStyle codeSM = TextStyle(
    fontFamily: fontMono,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 18 / 13,
  );
}

class AppSpacing {
  AppSpacing._();

  static const double unit = 8;
  static const double containerMargin = 20;
  static const double gutter = 16;
  static const double stackSM = 8;
  static const double stackMD = 16;
  static const double stackLG = 24;
}

class AppRadius {
  AppRadius._();

  static const double sm = 4;
  static const double md = 8;
  static const double lg = 16;
  static const double xl = 24;
  static const double full = 9999;
}
