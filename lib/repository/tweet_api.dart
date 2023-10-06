import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:x/constants/appwrite_constants.dart';
import 'package:x/core/core.dart';
import 'package:x/model/tweet.dart';


final tweetAPIProvider = Provider((ref) {
  return TweetAPI(db: ref.watch(appwriteDatabaseProvider), realtime: ref.watch(appwriteRealtimeProvider));
});


abstract class TweetAPIInterface {
  FutureEither<Document> shareTweet(Tweet tweet);
  Future<List<Document>> getTweets();
  Stream<RealtimeMessage> getLatestTweet();
  FutureEither<Document> likeTweet(Tweet tweet);
  FutureEither<Document> updateReshareCount(Tweet tweet);
  Future<List<Document>> getRepliesToTweet(Tweet tweet);
  Future<Document> getTweetById(String id);
  Future<List<Document>> getUserTweets(String uid);
  Future<List<Document>> getTweetsByHashtag(String hashtag);
}

class TweetAPI implements TweetAPIInterface {
  final Databases _db;
  final Realtime _realtime;

  TweetAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

  @override
  Stream<RealtimeMessage> getLatestTweet() {
    // TODO: implement getLatestTweet
    throw UnimplementedError();
  }

  @override
  Future<List<Document>> getRepliesToTweet(Tweet tweet) {
    // TODO: implement getRepliesToTweet
    throw UnimplementedError();
  }

  @override
  Future<Document> getTweetById(String id) {
    // TODO: implement getTweetById
    throw UnimplementedError();
  }

  @override
  Future<List<Document>> getTweets() {
    // TODO: implement getTweets
    throw UnimplementedError();
  }

  @override
  Future<List<Document>> getTweetsByHashtag(String hashtag) {
    // TODO: implement getTweetsByHashtag
    throw UnimplementedError();
  }

  @override
  Future<List<Document>> getUserTweets(String uid) {
    // TODO: implement getUserTweets
    throw UnimplementedError();
  }

  @override
  FutureEither<Document> likeTweet(Tweet tweet) {
    // TODO: implement likeTweet
    throw UnimplementedError();
  }

  @override
  FutureEither<Document> shareTweet(Tweet tweet) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollection,
        documentId: ID.unique(),
        data: tweet.toMap(),
      );
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          message: e.message ?? 'Some unexpected error occurred', stackTrace: st,
        ),
      );
    } catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    }
  }

  @override
  FutureEither<Document> updateReshareCount(Tweet tweet) {
    // TODO: implement updateReshareCount
    throw UnimplementedError();
  }
}
