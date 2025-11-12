part of 'dependencies_imports.dart';

void setupBlocDependencies(GetIt sl) {
  sl.registerFactory<NotificationBloc>(
    () => NotificationBloc(
      sendNotificationUseCase: sl(),
      getNotificationStatusUseCase: sl(),
    ),
  );
}
