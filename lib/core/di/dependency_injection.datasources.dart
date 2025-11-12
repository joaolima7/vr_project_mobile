part of 'dependencies_imports.dart';

void setupDataSourceDependencies(GetIt sl) {
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(client: sl()),
  );
}
