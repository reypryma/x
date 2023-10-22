import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:x/constants/appwrite_constants.dart';
import 'package:x/core/core.dart';
import 'package:x/core/service_locator.dart';
import 'package:x/model/user.dart';

final userAPIProvider = Provider((ref) {
  return UserAPI(
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appwriteRealtimeProvider),
  );
});

abstract class UserAPIInterface {
  FutureEitherVoid saveUserData(UserModel userModel);

  Future<Document> getUserData(String uid);

  Future<List<Document>> searchUserByName(String name);

  FutureEitherVoid updateUserData(UserModel userModel);

  Stream<RealtimeMessage> getLatestUserProfileData();

  FutureEitherVoid followUser(UserModel user);

  FutureEitherVoid addToFollowing(UserModel user);
}

class UserAPI extends UserAPIInterface {
  final Databases _db;
  final Realtime _realtime;

  UserAPI({
    required Databases db,
    required Realtime realtime,
  })  : _realtime = realtime,
        _db = db;

  @override
  FutureEitherVoid addToFollowing(UserModel user) {
    // TODO: implement addToFollowing
    throw UnimplementedError();
  }

  @override
  FutureEitherVoid followUser(UserModel user) {
    // TODO: implement followUser
    throw UnimplementedError();
  }

  @override
  Stream<RealtimeMessage> getLatestUserProfileData() {
    throw UnimplementedError();
  }

  @override
  Future<Document> getUserData(String uid) async {
    print('got the getUserData in API: $uid');
    return await _db.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        documentId: uid);
  }

  @override
  FutureEitherVoid saveUserData(UserModel userModel) async {
    try {
      print('got the saved user data ${userModel}');
      await _db.createDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.usersCollection,
          documentId: userModel.uid!,
          data: userModel.toMap());
      return right(null);
    } on AppwriteException catch (e, st) {
      print('vailed  create data user $e with ${st.toString()}');
      return left(
        Failure(message: e.message!, stackTrace: st),
      );
    } catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    }
  }

  @override
  Future<List<Document>> searchUserByName(String name) async {
      final documents = await _db.listDocuments(databaseId: AppwriteConstants.databaseId, collectionId: AppwriteConstants.usersCollection,
        queries: [
          Query.search('name', name),
        ]
      );
      return documents.documents;
  }

  @override
  FutureEitherVoid updateUserData(UserModel userModel) async{
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        documentId: userModel.uid!,
        data: userModel.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(message: e.message!, stackTrace: st),
      );
    } catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    }
  }
}
