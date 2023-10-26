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
    authAPI: ref.watch(authAPIProvider),
    userAPI: ref.watch(userAPIProvider),
  );
});

// final currentUserAccountProvider = FutureProvider((ref) {
//   final authController = ref.watch(authControllerProvider.notifier);
//   print("currentUserAccountProvider: ### Gettt ${authController} it is");
//
//   // print("currentUserProvider: ${authController.currentUser().email}  id: ${authController.currentUser().$id}");
//
//   // UserModel user = ref.watch(currentUserDetailsProvider);
//   return authController.currentUser();
// });

final currentUserDetailsProvider = FutureProvider((ref) {
  final userFirstFetch = ref.watch(authControllerProvider.notifier).usermodel;
  String? currentUserId;
  if(userFirstFetch != null){
    currentUserId = userFirstFetch.$id;
    ref.watch(currentUserAccountProvider).value;
  }else{
    currentUserId = ref.watch(currentUserAccountProvider).value!.$id;
  }
  final userDetails = ref.watch(userDetailsProvider(currentUserId));
  return userDetails.value;
});

final userDetailsProvider = FutureProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;

  User? usermodel;

  AuthController({
    required AuthAPI authAPI,
    required UserAPI userAPI,
  })  : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false);
  // state = isLoading

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signUp(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
          (l) => showSnackBar(context, l.message),
          (r) async {
        UserModel userModel = UserModel(
          email: email,
          name: getNameFromEmail(email),
          followers: const [],
          following: const [],
          profilePic: '',
          bannerPic: '',
          uid: r.$id,
          bio: '',
          isTwitterBlue: false,
        );
        final res2 = await _userAPI.saveUserData(userModel);
        res2.fold((l) => showSnackBar(context, l.message), (r) {
          showSnackBar(context, 'Accounted created! Please login.');
          Navigator.push(context, LoginView.route());
        });
      },
    );
  }

  void login(
      {required String email,
        required String password,
        required BuildContext context}) async {
    state = true;
    final res = await _authAPI.login(email: email, password: password);
    state = false;

    res.fold((l) => showSnackBar(context, l.message), (r) async {
      usermodel = await currentUser();
      if (!context.mounted) return;
      if(usermodel != null){
        showSnackBar(context, 'Successfully Login');
        Navigator.push(context, HomeView.route());
      }else{
        showSnackBar(context, 'Failed Login');
      }
    });
  }

  Future<User?> currentUser() async {
    return await _authAPI.currentUserAccount();
  }

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

  Future<UserModel> getUserData(String uid) async {
    final document = await _userAPI.getUserData(uid);
    print("get user data from auth controller \n ${document.data}");
    final updatedUser = UserModel.fromMap(document.data);
    return updatedUser;
  }
}

