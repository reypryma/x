class AppwriteConstants {
  static const String databaseId = '650ac043b551ac054144';
  static const String projectId = '650aa6c4a35400770ff0';
  static const String endPointMobile = 'http://192.168.1.2:885/v1';
  static const String endPointWeb = 'http://127.0.0.1:885/v1';

  static const String usersCollection = '65104dcb048d2a294630';
  static const String tweetsCollection = '651bc52fb19dec766d06';
  static const String notificationsCollection = '651bcb59cad204abe2ad';

  static const String imagesBucket = '651bcd0da2a1ab69d846';

  static String imageUrl(String imageId) =>
      '$endPointWeb/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}
