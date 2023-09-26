import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:x/core/core.dart';
import 'package:x/core/service_locator.dart';

// read only value
final authApiProvider =
    Provider((ref) => AuthAPI(account: ref.watch(appWriteAccountProvider)));

abstract class AuthAPIInterface {
  FutureEither<User> signUp({required String email, required String password});
  FutureEither<Session> login(
      {required String email, required String password});
  Future<User?> currentUserAccount();
  FutureEitherVoid logout();
}

class AuthAPI implements AuthAPIInterface {
  final Account _account;
  AuthAPI({required Account account}) : _account = account;

  @override
  FutureEither<User> signUp(
      {required String email, required String password}) async {
    try {
      final account = await _account.create(
          userId: ID.unique(), email: email, password: password);
      print("Get user $account");
      return right(account);
    } on AppwriteException catch (e, stackTrace) {
      if (kDebugMode) {
        print("sign up error ${e.message}");
      }
      return left(Failure(
          message: e.message ?? "App Write error", stackTrace: stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  @override
  FutureEither<Session> login(
      {required String email, required String password}) async {
    try {
      final session =
          await _account.createEmailSession(email: email, password: password);
      return right(session);
    } on AppwriteException catch (e, stackTrace) {
      if (kDebugMode) {
        print(e.message ?? 'App Write error');
      }
      return left(Failure(
          message: e.message ?? "App Write error", stackTrace: stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  @override
  Future<User?> currentUserAccount() async {
    try {
      final curentUser = await _account.get();
      return curentUser;
    } catch (e) {
      print("Error current user $e");
      return null;
    }
  }

  @override
  FutureEitherVoid logout() async {
    try {
      await _account.deleteSession(
        sessionId: 'current',
      );
      return right(null);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(message: e.message ?? 'Some unexpected error occurred', stackTrace: stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(message: e.toString(),stackTrace:  stackTrace),
      );
    }
  }
}
