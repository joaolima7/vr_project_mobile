part of 'dependencies_imports.dart';

void setupUseCaseDependencies(GetIt sl) {
  sl.registerLazySingleton<SendNotificationUseCase>(
    () => SendNotificationUseCase(repository: sl()),
  );

  sl.registerLazySingleton<GetNotificationStatusUseCase>(
    () => GetNotificationStatusUseCase(repository: sl()),
  );
}
