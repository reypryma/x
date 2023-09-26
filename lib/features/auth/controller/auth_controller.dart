import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x/common/widgets/utils_widget.dart';
import 'package:x/features/auth/view/login_view.dart';
import 'package:x/features/auth/view/signup_view.dart';
import 'package:x/features/home/view/home_view.dart';
import 'package:x/model/user.dart';
import 'package:x/repository/auth_api.dart';
import 'package:x/repository/user_api.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    ref.watch(authApiProvider),
    userAPI: ref.watch(userAPIProvider),
  );
});

final currentUserProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;

  AuthController(this._authAPI, {required UserAPI userAPI}) : _userAPI = userAPI, super(false);

  void signUp(
      {required String email,
      required String password,
      required BuildContext context}) async {
    state = true;
    final res = await _authAPI.signUp(email: email, password: password);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) async {
      UserModel userModel = UserModel(
          email: email,
          name: getNameFromEmail(email),
          followers: const [],
          following: const [],
          profilePic: '',
          bannerPic: '',
          bio: '',
          uid: r.$id,
          isTwitterBlue: false);
      final resSaveUserData = await _userAPI.saveUserData(userModel);
      resSaveUserData.fold(
        (l) {
          print('error resSaveUserData ${l.stackTrace}');
          showSnackBar(context, l.message);
        },
        (r) {
              showSnackBar(context, 'Accounted created! Please login.');
              Navigator.push(context, LoginView.route());
            }
      );
    });
  }

  void login(
      {required String email,
      required String password,
      required BuildContext context}) async {
    state = true;
    final res = await _authAPI.login(email: email, password: password);
    state = false;

    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Successfully Login');
      Navigator.push(context, HomeView.route());
    });
  }

  Future<User?> currentUser() async => _authAPI.currentUserAccount();

  void logout(BuildContext context) async {
    final res = await _authAPI.logout();
    res.fold((l) => null, (r) {
      Navigator.pushAndRemoveUntil(
        context,
        SignUpView.route(),
            (route) => false,
      );
    });
  }
}
