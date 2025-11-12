import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../config/theme/app_colors.dart';
import '../../domain/entities/notification.entity.dart';

class NotificationItem extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationItem({
    super.key,
    required this.notification,
  });

  Color _getStatusColor() {
    switch (notification.status) {
      case NotificationStatus.success:
        return AppColors.statusSuccess;
      case NotificationStatus.failure:
        return AppColors.statusError;
      case NotificationStatus.pending:
        return AppColors.statusPending;
      case NotificationStatus.queued:
        return AppColors.statusQueued;
    }
  }

  IconData _getStatusIcon() {
    switch (notification.status) {
      case NotificationStatus.success:
        return Icons.check_circle;
      case NotificationStatus.failure:
        return Icons.error;
      case NotificationStatus.pending:
        return Icons.hourglass_empty;
      case NotificationStatus.queued:
        return Icons.schedule;
    }
  }

  String _getStatusText() {
    switch (notification.status) {
      case NotificationStatus.success:
        return 'Processado com Sucesso';
      case NotificationStatus.failure:
        return 'Falha no Processamento';
      case NotificationStatus.pending:
        return 'Aguardando Processamento';
      case NotificationStatus.queued:
        return 'Enfileirado';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final statusIcon = _getStatusIcon();
    final statusText = _getStatusText();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  statusIcon,
                  color: statusColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
                if (notification.status == NotificationStatus.pending)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              notification.messageContent,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  DateFormat('dd/MM/yyyy HH:mm').format(notification.createdAt),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                Text(
                  'ID: ${notification.messageId.substring(0, 8)}...',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
