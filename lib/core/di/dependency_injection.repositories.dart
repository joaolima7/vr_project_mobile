part of 'dependencies_imports.dart';

void setupRepositoryDependencies(GetIt sl) {
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
      remoteDataSource: sl(),
      uuid: sl(),
    ),
  );
}
