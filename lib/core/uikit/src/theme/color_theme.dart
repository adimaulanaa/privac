// ignore_for_file: avoid_multiple_declarations_per_line

import 'package:flutter/material.dart';

enum UIColor {
  primary,
  secondary,
  black,
  white,
  success,
  danger,
  warning,
  neutral;

  MaterialColor of(BuildContext context) {
    switch (this) {
      case UIColor.primary:
        return context.uiColor.primary;
      case UIColor.secondary:
        return context.uiColor.secondary;
      case UIColor.black:
        return context.uiColor.black;
      case UIColor.white:
        return context.uiColor.white;
      case UIColor.success:
        return context.uiColor.success;
      case UIColor.danger:
        return context.uiColor.danger;
      case UIColor.warning:
        return context.uiColor.warning;
      case UIColor.neutral:
        return context.uiColor.neutral;
    }
  }
}

class UIColorTheme extends ThemeExtension<UIColorTheme> {
  const UIColorTheme({
    this.primary = const MaterialColor(
      0xFFEA5B26,
      {
        50: Color(0xFFFCEBE5),
        100: Color(0xFFF9CEBE),
        200: Color(0xFFF5AD93),
        300: Color(0xFFF08C67),
        400: Color(0xFFED7447),
        500: Color(0xFFEA5B26),
        600: Color(0xFFE75322),
        700: Color(0xFFE4491C),
        800: Color(0xFFE14017),
        900: Color(0xFFDB2F0D),
      },
    ),
    this.secondary = const MaterialColor(
      0xFFFECD3A,
      {
        50: Color(0xFFFFF9E7),
        100: Color(0xFFFFF0C4),
        200: Color(0xFFFFE69D),
        300: Color(0xFFFEDC75),
        400: Color(0xFFFED558),
        500: Color(0xFFFECD3A),
        600: Color(0xFFFEC834),
        700: Color(0xFFFEC12C),
        800: Color(0xFFFEBA25),
        900: Color(0xFFFDAE18),
      },
    ),
    this.success = const MaterialColor(
      0xff22c55e,
      {
        50: Color(0xffe9f9ef),
        100: Color(0xffbaedcd),
        200: Color(0xff99e4b5),
        300: Color(0xff6bd893),
        400: Color(0xff4ed17e),
        500: Color(0xff22c55e),
        600: Color(0xff1fb356),
        700: Color(0xff188c43),
        800: Color(0xff136c34),
        900: Color(0xff0e5327),
      },
    ),
    this.warning = const MaterialColor(
      0xfff59e0b,
      {
        50: Color(0xfffef5e7),
        100: Color(0xfffce1b3),
        200: Color(0xfffad28f),
        300: Color(0xfff8be5c),
        400: Color(0xfff7b13c),
        500: Color(0xfff59e0b),
        600: Color(0xffdf900a),
        700: Color(0xffae7008),
        800: Color(0xff875706),
        900: Color(0xff674205),
      },
    ),
    this.danger = const MaterialColor(
      0xffef4444,
      {
        50: Color(0xfffdecec),
        100: Color(0xfffac5c5),
        200: Color(0xfff8a9a9),
        300: Color(0xfff48282),
        400: Color(0xfff26969),
        500: Color(0xffef4444),
        600: Color(0xffd93e3e),
        700: Color(0xffaa3030),
        800: Color(0xff832525),
        900: Color(0xff641d1d),
      },
    ),
    this.neutral = const MaterialColor(
      0xff777986,
      {
        50: Color(0xfff1f2f3),
        100: Color(0xffd5d5d9),
        200: Color(0xffc0c1c7),
        300: Color(0xffa4a5ae),
        400: Color(0xff92949e),
        500: Color(0xff777986),
        600: Color(0xff6c6e7a),
        700: Color(0xff54565f),
        800: Color(0xff41434a),
        900: Color(0xff323338),
      },
    ),
    this.black = const MaterialColor(
      0xff12141b,
      {
        50: Color(0xff282a3a),
        100: Color(0xff282a3a),
        200: Color(0xff282a3a),
        300: Color(0xff282a3a),
        400: Color(0xff1c1d29),
        500: Color(0xff12141b),
        600: Color(0xff12141b),
        700: Color(0xff12141b),
        800: Color(0xff12141b),
        900: Color(0xff12141b),
      },
    ),
    this.white = const MaterialColor(
      0xfff7f7f7,
      {
        50: Color(0xfffefefe),
        100: Color(0xfffefefe),
        200: Color(0xfffefefe),
        300: Color(0xfffefefe),
        400: Color(0xfffdfdfd),
        500: Color(0xfff7f7f7),
        600: Color(0xfff7f7f7),
        700: Color(0xfff7f7f7),
        800: Color(0xfff7f7f7),
        900: Color(0xfff7f7f7),
      },
    ),
  });

  final MaterialColor primary,
      secondary,
      success,
      warning,
      danger,
      neutral,
      black,
      white;

  @override
  ThemeExtension<UIColorTheme> copyWith({
    MaterialColor? primary,
    MaterialColor? secondary,
    MaterialColor? success,
    MaterialColor? warning,
    MaterialColor? danger,
    MaterialColor? neutral,
    MaterialColor? black,
    MaterialColor? white,
  }) {
    return UIColorTheme(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      neutral: neutral ?? this.neutral,
      black: black ?? this.black,
      white: white ?? this.white,
    );
  }

  @override
  ThemeExtension<UIColorTheme> lerp(
    covariant ThemeExtension<UIColorTheme>? other,
    double t,
  ) {
    if (other is! UIColorTheme) return this;
    return UIColorTheme(
      primary: _lerp(primary, other.primary, t),
      secondary: _lerp(secondary, other.secondary, t),
      success: _lerp(success, other.success, t),
      warning: _lerp(warning, other.warning, t),
      danger: _lerp(danger, other.danger, t),
      neutral: _lerp(neutral, other.neutral, t),
      black: _lerp(black, other.black, t),
      white: _lerp(white, other.white, t),
    );
  }

  static MaterialColor _lerp(
    MaterialColor a,
    MaterialColor b,
    double t,
  ) {
    return MaterialColor(
      Color.lerp(a.shade500, b.shade500, t)!.value,
      <int, Color>{
        50: Color.lerp(a.shade50, b.shade50, t)!,
        100: Color.lerp(a.shade100, b.shade100, t)!,
        200: Color.lerp(a.shade200, b.shade200, t)!,
        300: Color.lerp(a.shade300, b.shade300, t)!,
        400: Color.lerp(a.shade400, b.shade400, t)!,
        500: Color.lerp(a.shade500, b.shade500, t)!,
        600: Color.lerp(a.shade600, b.shade600, t)!,
        700: Color.lerp(a.shade700, b.shade700, t)!,
        800: Color.lerp(a.shade800, b.shade800, t)!,
        900: Color.lerp(a.shade900, b.shade900, t)!,
      },
    );
  }
}

extension ColorThemeExtension on BuildContext {
  UIColorTheme get uiColor {
    return Theme.of(this).extension<UIColorTheme>() ?? const UIColorTheme();
  }

  Color colorMode({required Color light, required Color dark}) {
    return Theme.of(this).brightness == Brightness.dark ? dark : light;
  }
}
