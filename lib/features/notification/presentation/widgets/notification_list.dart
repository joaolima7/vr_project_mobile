import 'package:flutter/material.dart';
import '../../../../config/constants/app_constants.dart';
import '../../../../config/theme/app_colors.dart';
import '../../domain/entities/notification.entity.dart';
import 'notification_item.dart';

class NotificationList extends StatelessWidget {
  final List<NotificationEntity> notifications;

  const NotificationList({
    super.key,
    required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off,
              size: 64,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 16),
            Text(
              AppConstants.emptyListMessage,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(
        top: AppConstants.paddingSmall,
        bottom: AppConstants.paddingMedium,
      ),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return NotificationItem(notification: notifications[index]);
      },
    );
  }
}
