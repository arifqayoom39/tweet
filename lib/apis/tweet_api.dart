import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/core/providers.dart';
import 'package:twitter_clone/models/tweet_model.dart';

final tweetAPIProvider = Provider((ref) {
  return TweetAPI( // Capitalized class name
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appwriteRealtimeProvider),
  );
});


abstract class ItweetAPI {
  FutureEither<Document> sharetweet(Tweet tweet);
  Future<List<Document>> gettweets();
  Stream<RealtimeMessage> getLatesttweet();
  FutureEither<Document> liketweet(Tweet tweet);
  FutureEither<Document> updateReshareCount(Tweet tweet);
  Future<List<Document>> getRepliesTotweet(Tweet tweet);
  Future<Document> gettweetById(String id);
  Future<List<Document>> getUsertweets(String uid);
  Future<List<Document>> gettweetsByHashtag(String hashtag);
}

class TweetAPI implements ItweetAPI { // Change 'tweetAPI' to 'TweetAPI'
  final Databases _db;
  final Realtime _realtime;
  TweetAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;


  @override
  FutureEither<Document> sharetweet(Tweet tweet) async {
    try {
      print("Attempting to share tweet: ${tweet.toMap()}");
      final document = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollection,
        documentId: ID.unique(),
        data: tweet.toMap(),
      );
      print("tweet shared successfully: ${document.toMap()}");
      return right(document);
    } on AppwriteException catch (e, st) {
      print("AppwriteException occurred while sharing tweet: ${e.message}");
      return left(Failure(e.message ?? 'Some unexpected error occurred', st));
    } catch (e, st) {
      print("Unexpected error occurred while sharing tweet: $e");
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<List<Document>> gettweets() async {
    try {
      print("Fetching tweets...");
      final documents = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollection,
        queries: [
          Query.orderDesc('tweetedAt'),
        ],
      );
      print("tweets fetched successfully: ${documents.documents.length} tweets found.");
      return documents.documents;
    } catch (e) {
      print("Error fetching tweets: $e");
      return [];
    }
  }

  @override
  Stream<RealtimeMessage> getLatesttweet() {
    print("Subscribing to latest tweets...");
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.tweetsCollection}.documents'
    ]).stream;
  }

  @override
  FutureEither<Document> liketweet(Tweet tweet) async {
    try {
      print("Liking tweet with ID: ${tweet.id}");
      final document = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollection,
        documentId: tweet.id,
        data: {'likes': tweet.likes},
      );
      print("tweet liked successfully: ${document.toMap()}");
      return right(document);
    } on AppwriteException catch (e, st) {
      print("AppwriteException occurred while liking tweet: ${e.message}");
      return left(Failure(e.message ?? 'Some unexpected error occurred', st));
    } catch (e, st) {
      print("Unexpected error occurred while liking tweet: $e");
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEither<Document> updateReshareCount(Tweet tweet) async {
    try {
      print("Updating reshare count for tweet with ID: ${tweet.id}");
      final document = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollection,
        documentId: tweet.id,
        data: {'reshareCount': tweet.reshareCount},
      );
      print("Reshare count updated successfully: ${document.toMap()}");
      return right(document);
    } on AppwriteException catch (e, st) {
      print("AppwriteException occurred while updating reshare count: ${e.message}");
      return left(Failure(e.message ?? 'Some unexpected error occurred', st));
    } catch (e, st) {
      print("Unexpected error occurred while updating reshare count: $e");
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<List<Document>> getRepliesTotweet(Tweet tweet) async {
    try {
      print("Fetching replies to tweet with ID: ${tweet.id}");
      final documents = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollection,
        queries: [
          Query.equal('repliedTo', tweet.id),
        ],
      );
      print("Replies fetched successfully: ${documents.documents.length} replies found.");
      return documents.documents;
    } catch (e) {
      print("Error fetching replies: $e");
      return [];
    }
  }

  @override
  Future<Document> gettweetById(String id) async {
    try {
      print("Fetching tweet by ID: $id");
      final document = await _db.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollection,
        documentId: id,
      );
      print("tweet fetched successfully: ${document.toMap()}");
      return document;
    } catch (e) {
      print("Error fetching tweet by ID: $e");
      throw e;
    }
  }

  @override
  Future<List<Document>> getUsertweets(String uid) async {
    try {
      print("Fetching tweets by user with UID: $uid");
      final documents = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollection,
        queries: [
          Query.equal('uid', uid),
        ],
      );
      print("User tweets fetched successfully: ${documents.documents.length} tweets found.");
      return documents.documents;
    } catch (e) {
      print("Error fetching user tweets: $e");
      return [];
    }
  }

  @override
  Future<List<Document>> gettweetsByHashtag(String hashtag) async {
    try {
      print("Fetching tweets by hashtag: $hashtag");
      final documents = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollection,
        queries: [
          Query.search('hashtags', hashtag),
        ],
      );
      print("tweets by hashtag fetched successfully: ${documents.documents.length} tweets found.");
      return documents.documents;
    } catch (e) {
      print("Error fetching tweets by hashtag: $e");
      return [];
    }
  }
}
