import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UIKit extends StatelessWidget {
  const UIKit({required this.builder, super.key});

  static const designWidth = 375.0;
  static const designHeight = 812.0;

  final Widget Function(BuildContext context, Widget? child) builder;
  // final Widget child;

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.sizeOf(context);
    // final isTablet = size.shortestSide >= 600;
    // if (isTablet) {
    //   final scaleHeight = size.height / designHeight;
    //   final scaleWidth = size.width / designWidth;
    //   final scale = min(scaleHeight, scaleWidth);
    //   size = Size(designWidth * scale, designHeight * scale);
    // }

    // return MediaQuery(
    // data: MediaQueryData(size: size),
    return ScreenUtilInit(
      designSize: const Size(designWidth, designHeight),
      splitScreenMode: true,
      minTextAdapt: true,
      builder: builder,
      useInheritedMediaQuery: true,
      // child: child,
      // ),
    );
  }
}
