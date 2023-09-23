class AppwriteConstants {
  static const String databaseId = '650ac043b551ac054144';
  static const String projectId = '650aa6c4a35400770ff0';
  static const String endPoint = 'http://192.168.1.40:885/v1';

  static const String usersCollection = '63cb8ae73960973b0635';
  static const String tweetsCollection = '63cbd6781a8ce89dcb95';
  static const String notificationsCollection = '63cd5ff88b08e40a11bc';

  static const String imagesBucket = '63cbdab48cdbccb6b34e';

  static String imageUrl(String imageId) =>
      '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}
