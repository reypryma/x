import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x/model/notification.dart';

import '../core/core.dart';

final notificationAPIProvider = Provider((ref) {
  return NotificationAPI(
        db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appwriteRealtimeProvider),
  );
});

abstract class NotificationAPIInterface {
  FutureEitherVoid createNotification(Notification notification);
  Future<List<Document>> getNotifications(String uid);
  Stream<RealtimeMessage> getLatestNotification();
}

class NotificationAPI implements NotificationAPIInterface {
  final Databases _db;
  final Realtime _realtime;

  NotificationAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

  @override
  FutureEitherVoid createNotification(Notification notification) {
    // TODO: implement createNotification
    throw UnimplementedError();
  }

  @override
  Stream<RealtimeMessage> getLatestNotification() {
    // TODO: implement getLatestNotification
    throw UnimplementedError();
  }

  @override
  Future<List<Document>> getNotifications(String uid) {
    // TODO: implement getNotifications
    throw UnimplementedError();
  }
}
