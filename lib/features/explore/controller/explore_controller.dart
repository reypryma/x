import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x/model/user.dart';
import 'package:x/repository/user_api.dart';

final exploreControllerProvider = StateNotifierProvider((ref) {
  return ExploreController(userAPI: ref.watch(userAPIProvider));
});

final searchUserProvider = FutureProvider.family((ref, String name) async {
  final exploreController = ref.watch(exploreControllerProvider.notifier);
  return exploreController.searchUser(name);
});

class ExploreController extends StateNotifier<bool> {
  final UserAPI _userAPI;

  ExploreController({required UserAPI userAPI})
      : _userAPI = userAPI,
        super(false);

  Future<List<UserModel>> searchUser(String name) async {
    final getUsers = await _userAPI.searchUserByName(name);
    return getUsers.map((e) => UserModel.fromMap(e.data)).toList();
  }
}
