part of 'dependencies_imports.dart';

void setupNetworkDependencies(GetIt sl) {
  sl.registerLazySingleton<Dio>(() => DioConfig.create());

  sl.registerLazySingleton<NetworkClient>(
    () => NetworkClientImpl(dio: sl()),
  );
}
