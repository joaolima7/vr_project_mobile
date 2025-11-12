import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/constants/app_constants.dart';
import '../../../../config/theme/app_colors.dart';
import '../blocs/notification.event.dart';
import '../blocs/notification.state.dart';
import '../blocs/notifiction.bloc.dart';
import '../widgets/notification_form.dart';
import '../widgets/notification_list.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
              if (state.isPolling) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocConsumer<NotificationBloc, NotificationState>(
        listener: (context, state) {
          if (state.status == NotificationStateStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Erro desconhecido'),
                backgroundColor: AppColors.error,
                action: SnackBarAction(
                  label: 'OK',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<NotificationBloc>().add(
                      const ClearErrorEvent(),
                    );
                  },
                ),
              ),
            );
          }

          if (state.status == NotificationStateStatus.success && state.notifications.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Notificação enviada com sucesso!'),
                backgroundColor: AppColors.success,
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              const NotificationForm(),
              Expanded(
                child: NotificationList(
                  notifications: state.notifications,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
