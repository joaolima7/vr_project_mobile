import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vr_project_mobile/core/di/dependencies_imports.dart';
import 'config/theme/app_theme.dart';
import 'features/notification/presentation/blocs/notifiction.bloc.dart';
import 'features/notification/presentation/screens/notification_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VR Notifications',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: BlocProvider(
        create: (_) => getIt<NotificationBloc>(),
        child: const NotificationScreen(),
      ),
    );
  }
}
