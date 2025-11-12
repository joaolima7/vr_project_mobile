import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/notification/data/datasources/remote/notification_remote.datasource.dart';
import '../../features/notification/data/repositories/notification_repository_impl.dart';
import '../../features/notification/domain/repositories/notification.repository.dart';
import '../../features/notification/domain/usecases/get_notification_status.usecase.dart';
import '../../features/notification/domain/usecases/send_notification.usecase.dart';
import '../../features/notification/presentation/blocs/notifiction.bloc.dart';
import '../network/dio_config.dart';
import '../network/network_client.dart';
import '../network/network_client_impl.dart';

part 'inject_dependencies.dart';
part 'dependency_injection.network.dart';
part 'dependency_injection.datasources.dart';
part 'dependency_injection.repositories.dart';
part 'dependency_injection.usecases.dart';
part 'dependency_injection.blocs.dart';

final GetIt getIt = GetIt.instance;
