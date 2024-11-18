import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:privac/core/config/config_resources.dart';
import 'package:privac/core/uikit/src/uikit.dart';
import 'package:privac/features/dashboard/presentation/bloc/bloc.dart';
import 'package:privac/features/onboarding.dart';
import 'package:privac/dependency_injection.dart' as di;
import 'package:privac/features/profile/presentation/bloc/profile_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Panggil fungsi setupDependencyInjection untuk registrasi dependency
  await di.init();
  final GetIt getIt = GetIt.instance;
  // runApp(const MyApp());
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(
          create: (context) => getIt<ProfileBloc>(),
        ),
        BlocProvider<DashboardBloc>(
          create: (context) => getIt<DashboardBloc>(),
        ),
        // Tambahkan provider lain jika diperlukan
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return UIKit(
      builder: (context, child) => MaterialApp(
        theme: ThemeData(
          fontFamily: 'Gilroy', // Mengatur font default untuk aplikasi
        ),
        title: StringResources.nameApp,
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
