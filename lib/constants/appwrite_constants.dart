class AppwriteConstants {
  static const String databaseId = '64293d218fa920a297a1';
  static const String projectId = '64293b9272744e97c9d2';
  static const String endPoint = 'https://cloud.appwrite.io/v1';

  static const String usersCollection = '66d473b6001e036007aa';
  static const String tweetsCollection = '66d478760004fbfce369';
  static const String notificationsCollection = '66d48dbd0029c287510f';

  static const String imagesBucket = '650923b438f43cbaba25';

  static String imageUrl(String imageId) =>
      '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}
