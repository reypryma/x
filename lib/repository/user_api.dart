import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:x/constants/appwrite_constants.dart';
import 'package:x/core/core.dart';
import 'package:x/core/service_locator.dart';
import 'package:x/model/user.dart';

final userAPIProvider = Provider((ref) {
  return UserAPI(db: ref.watch(appwriteDatabaseProvider));
});

abstract class UserAPIInterface {
  FutureEitherVoid saveUserData(UserModel userModel);
  Future<Document> getUserData(String uid);
  Future<List<Document>> searchUserByName(String name);
  FutureEitherVoid updateUserData(User userModel);
  Stream<RealtimeMessage> getLatestUserProfileData();
  FutureEitherVoid followUser(User user);
  FutureEitherVoid addToFollowing(User user);
}

class UserAPI extends UserAPIInterface {
  final Databases _db;

  UserAPI({required Databases db}) : _db = db;

  @override
  FutureEitherVoid addToFollowing(User user) {
    // TODO: implement addToFollowing
    throw UnimplementedError();
  }

  @override
  FutureEitherVoid followUser(User user) {
    // TODO: implement followUser
    throw UnimplementedError();
  }

  @override
  Stream<RealtimeMessage> getLatestUserProfileData() {
    // TODO: implement getLatestUserProfileData
    throw UnimplementedError();
  }

  @override
  Future<Document> getUserData(String uid) {
    // TODO: implement getUserData
    throw UnimplementedError();
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
  Future<List<Document>> searchUserByName(String name) {
    // TODO: implement searchUserByName
    throw UnimplementedError();
  }

  @override
  FutureEitherVoid updateUserData(User userModel) {
    // TODO: implement updateUserData
    throw UnimplementedError();
  }
}
