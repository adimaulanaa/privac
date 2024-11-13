import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:privac/core/config/dio_config.dart';
import 'package:privac/features/profile/data/datasources/profile_local_source.dart';
import 'package:privac/features/profile/data/repositories/profile_repository.dart';
import 'package:privac/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:privac/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  //! Core
  sl.registerLazySingleton<Dio>(() => createDio());

  //!
  sl.registerLazySingleton<ProfileLocalSource>(
    () => ProfileLocalSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(dataLocalSource: sl<ProfileLocalSource>()),
  );
  sl.registerFactory(() => ProfileBloc(profileRepo: sl<ProfileRepository>()));
}
