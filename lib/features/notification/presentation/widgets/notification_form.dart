import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/constants/app_constants.dart';
import '../../../../core/components/custom_button.dart';
import '../../../../core/components/custom_text_field.dart';
import '../blocs/notification.event.dart';
import '../blocs/notifiction.bloc.dart';

class NotificationForm extends StatefulWidget {
  const NotificationForm({super.key});

  @override
  State<NotificationForm> createState() => _NotificationFormState();
}

class _NotificationFormState extends State<NotificationForm> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendNotification() {
    final content = _messageController.text.trim();

    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, digite uma mensagem'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    context.read<NotificationBloc>().add(
      SendNotificationEvent(content: content),
    );

    _messageController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nova Notificação',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            CustomTextField(
              controller: _messageController,
              hintText: AppConstants.sendNotificationHint,
              labelText: 'Mensagem',
              maxLines: 3,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendNotification(),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            CustomButton(
              text: AppConstants.sendButtonText,
              icon: Icons.send,
              onPressed: _sendNotification,
            ),
          ],
        ),
      ),
    );
  }
}
