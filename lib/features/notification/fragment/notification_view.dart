import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x/common/widgets/loading_widget.dart';
import 'package:x/constants/constants.dart';
import 'package:x/features/auth/controller/auth_controller.dart';
import 'package:x/features/notification/controller/notification_controller.dart';
import 'package:x/features/notification/widget/notification_tile.dart';
import 'package:x/model/notification.dart' as model;

import '../../../common/widgets/error_page.dart';

class NotificationFragment extends ConsumerWidget {
  const NotificationFragment({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: currentUser == null
          ? const LoadingWidget()
          : ref.watch(getNotificationsProvider(currentUser.uid)).when(
                data: (notifications) {
                  return ref.watch(getLatestNotificationProvider).when(
                    data: (data) {
                      if (data.events.contains(
                        'databases.*.collections.${AppwriteConstants.notificationsCollection}.documents.*.create',
                      )) {
                        final latestNotif =
                            model.Notification.fromMap(data.payload);
                        if (latestNotif.uid == currentUser.uid) {
                          notifications.insert(0, latestNotif);
                        }
                      }

                      return ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (BuildContext context, int index) {
                          final notification = notifications[index];
                          return NotificationTile(
                            notification: notification,
                          );
                        },
                      );
                    },
                    error: (error, stackTrace) {
                      print("getNotificationsProvider error $stackTrace");
                      return ErrorText(
                        error: error.toString(),
                      );
                    },
                    loading: () {
                      return ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (BuildContext context, int index) {
                          final notification = notifications[index];
                          return NotificationTile(
                            notification: notification,
                          );
                        },
                      );
                    },
                  );
                },
                error: (error, stackTrace) {
                  print("Notification view error $stackTrace");
                  return ErrorText(
                  error: error.toString(),
                );},
                loading: () {
                  return const LoadingWidget();
                },
              ),
    );
  }
}
