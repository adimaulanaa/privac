import 'package:flutter/material.dart';
import 'package:privac/core/config/config_resources.dart';
import 'package:privac/core/uikit/src/theme/theme.dart';
import 'package:privac/core/uikit/src/uikit.dart';
import 'package:privac/features/onboarding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return UIKit(
      builder: (context, child) => MaterialApp(
        title: StringResources.nameApp,
        theme: UITheme.light,
        initialRoute: '/onboarding',
        // getPages: AppPages.routes,
        // unknownRoute: AppPages.routes.first,
        debugShowCheckedModeBanner: false, // Menyembunyikan banner debug
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1),
            ),
            child: child ?? const SizedBox.shrink(),
          );
        },
        routes: {
          '/onboarding': (context) =>
              const Onboarding(), // Ganti dengan widget Onboarding
          // Definisikan rute lain di sini jika diperlukan
        },
      ),
    );
  }
}

