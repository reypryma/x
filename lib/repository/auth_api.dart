import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:x/core/core.dart';
import 'package:x/core/service_locator.dart';

// read only value
final authApiProvider =
    Provider((ref) => AuthAPI(account: ref.watch(appWriteAccountProvider)));

abstract class AuthAPIInterface {
  FutureEither<User> signUp({required String email, required String password});
}

class AuthAPI implements AuthAPIInterface {
  final Account _account;
  AuthAPI({required Account account}) : _account = account;

  @override
  FutureEither<User> signUp(
      {required String email, required String password}) async {
        print("Signup test");
    try {
      final account = await _account.create(
          userId: ID.unique(), email: email, password: password);
      return right(account);
    } on AppwriteException catch (e, stackTrace) {
      print(e.message ?? 'App Write error');
      return left(Failure(
          message: e.message ?? "App Write error", stackTrace: stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(message: e.toString(), stackTrace: stackTrace));
    }
  }
}
