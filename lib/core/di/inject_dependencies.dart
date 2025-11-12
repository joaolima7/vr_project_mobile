part of 'dependencies_imports.dart';

Future<void> initializeDependencies() async {
  setupNetworkDependencies(getIt);
  setupDataSourceDependencies(getIt);
  setupRepositoryDependencies(getIt);
  setupUseCaseDependencies(getIt);
  setupBlocDependencies(getIt);
}
