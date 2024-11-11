import 'package:flutter/material.dart';
import 'package:privac/core/uikit/src/assets/fonts.gen.dart';
import 'package:privac/core/uikit/uikit.dart';

class UITheme {
  static const _uiColor = UIColorTheme();
  static final _uiText = UITextTheme.defaultTheme();

  static final _textTheme = TextTheme(
    displayLarge: _uiText.h1,
    displayMedium: _uiText.h2,
    displaySmall: _uiText.h3,
    headlineLarge: _uiText.h3,
    headlineMedium: _uiText.h4,
    headlineSmall: _uiText.h5,
    titleLarge: _uiText.h5,
    titleMedium: _uiText.title1,
    titleSmall: _uiText.title2,
    bodyLarge: _uiText.body,
    bodyMedium: _uiText.body,
    bodySmall: _uiText.body,
    labelLarge: _uiText.caption,
    labelMedium: _uiText.caption,
    labelSmall: _uiText.caption,
  ).apply(fontFamily: UIFont.basierCircle);

  static ThemeData light = ThemeData.from(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _uiColor.primary,
      secondary: _uiColor.secondary,
    ),
    textTheme: _textTheme,
  ).copyWith(
    scaffoldBackgroundColor: _uiColor.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      titleTextStyle: _uiText.h5.medium.copyWith(
        color: _uiColor.black,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: _uiColor.white,
      modalBackgroundColor: _uiColor.white,
      shape: const UIBottomSheetBorder(),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _uiColor.neutral.shade50,
      labelStyle: _uiText.title2,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      hintStyle: _uiText.title1.copyWith(color: _uiColor.neutral.shade300),
      prefixIconColor: _uiColor.neutral.shade300,
      enabledBorder: UIOutlinedBorder(
        borderSide: BorderSide(color: _uiColor.neutral.shade100),
      ),
      focusedBorder: UIOutlinedBorder(
        borderSide: BorderSide(color: _uiColor.primary),
      ),
      errorBorder: UIOutlinedBorder(
        borderSide: BorderSide(color: _uiColor.danger),
      ),
    ),
    bottomAppBarTheme: BottomAppBarTheme(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: const Color(0xff7090B0).withOpacity(.33),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedLabelStyle: _uiText.body.copyWith(color: _uiColor.primary),
      unselectedLabelStyle: _uiText.body.copyWith(color: _uiColor.neutral),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
    extensions: [
      _uiColor,
      _uiText.copyWith(
        title2: _uiText.title2.copyWith(color: _uiColor.neutral),
      ),
    ],
  );
}

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
}
