import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UITextTheme extends ThemeExtension<UITextTheme> {
  const UITextTheme({
    required this.h1,
    required this.h2,
    required this.h3,
    required this.h4,
    required this.h5,
    required this.title1,
    required this.title2,
    required this.body,
    required this.caption,
  });

  factory UITextTheme.defaultTheme() {
    return UITextTheme(
      h1: TextStyle(fontSize: 42.sp, height: 1.4),
      h2: TextStyle(fontSize: 35.sp, height: 1.4),
      h3: TextStyle(fontSize: 29.sp, height: 1.4),
      h4: TextStyle(fontSize: 24.sp, height: 1.4),
      h5: TextStyle(fontSize: 20.sp, height: 1.4),
      title1: TextStyle(fontSize: 16.sp, height: 1.4),
      title2: TextStyle(fontSize: 14.sp, height: 1.4),
      body: TextStyle(fontSize: 12.sp, height: 1.4),
      caption: TextStyle(fontSize: 10.sp, height: 1.4),
    );
  }

  // ignore: avoid_multiple_declarations_per_line
  final TextStyle h1, h2, h3, h4, h5, title1, title2, body, caption;

  @override
  ThemeExtension<UITextTheme> copyWith({
    TextStyle? h1,
    TextStyle? h2,
    TextStyle? h3,
    TextStyle? h4,
    TextStyle? h5,
    TextStyle? title1,
    TextStyle? title2,
    TextStyle? body,
    TextStyle? caption,
  }) {
    return UITextTheme(
      h1: h1 ?? this.h1,
      h2: h2 ?? this.h2,
      h3: h3 ?? this.h3,
      h4: h4 ?? this.h4,
      h5: h5 ?? this.h5,
      title1: title1 ?? this.title1,
      title2: title2 ?? this.title2,
      body: body ?? this.body,
      caption: caption ?? this.caption,
    );
  }

  @override
  ThemeExtension<UITextTheme> lerp(
    covariant ThemeExtension<UITextTheme>? other,
    double t,
  ) {
    if (other is! UITextTheme) return this;
    return copyWith(
      h1: TextStyle.lerp(h1, other.h1, t),
      h2: TextStyle.lerp(h2, other.h2, t),
      h3: TextStyle.lerp(h3, other.h3, t),
      h4: TextStyle.lerp(h4, other.h4, t),
      h5: TextStyle.lerp(h5, other.h5, t),
      title1: TextStyle.lerp(title1, other.title1, t),
      title2: TextStyle.lerp(title2, other.title2, t),
      body: TextStyle.lerp(body, other.body, t),
      caption: TextStyle.lerp(caption, other.caption, t),
    );
  }
}

extension TextThemeExtension on BuildContext {
  UITextTheme get uiText {
    return Theme.of(this).extension<UITextTheme>() ??
        UITextTheme.defaultTheme();
  }
}

extension TextWightExtension on TextStyle {
  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);
  TextStyle get white => copyWith(color: Colors.white);
}
