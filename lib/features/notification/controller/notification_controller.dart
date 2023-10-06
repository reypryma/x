

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x/core/enum/notification_type_enum.dart';
import 'package:x/model/notification.dart';
import 'package:x/repository/notification_api.dart';


final notificationControllerProvider =
    StateNotifierProvider<NotificationController, bool>((ref) {
  return NotificationController(
    ref.watch(notificationAPIProvider),
  );
});

class NotificationController extends StateNotifier<bool> {
  final NotificationAPI _notificationAPI;
  NotificationController(this._notificationAPI): super(false);
  

  void createNotification({
    required String text,
    required String postId,
    required NotificationType notificationType,
    required String uid,
  }) async {
    final notification = Notification(
      text: text,
      postId: postId,
      id: '',
      uid: uid,
      notificationType: notificationType,
    );
    final res = await _notificationAPI.createNotification(notification);
    res.fold((l) => null, (r) => null);
  }

}