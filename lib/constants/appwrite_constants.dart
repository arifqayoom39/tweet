class AppwriteConstants {
  static const String databaseId = 'databaseId';
  static const String projectId = 'tweet';
  static const String endPoint = 'https://cloud.appwrite.io/v1';

  static const String usersCollection = 'users';
  static const String tweetsCollection = 'tweets';
  static const String notificationsCollection = 'notifications';

  static const String imagesBucket = '650923b438f43cbaba25';

  static String imageUrl(String imageId) =>
      '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}
