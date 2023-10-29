import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x/common/widgets/error_page.dart';
import 'package:x/constants/appwrite_constants.dart';
import 'package:x/features/profile/controller/profile_controller.dart';
import 'package:x/features/profile/widget/user_profile_widget.dart';
import 'package:x/model/user.dart';

class UserProfileView extends ConsumerWidget {
  static route(UserModel userModel) => MaterialPageRoute(
    builder: (context) => UserProfileView(
      userModel: userModel,
    ),
  );
  final UserModel userModel;
  const UserProfileView({
    super.key,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel copyOfUser = userModel;

    return Scaffold(
      body: ref.watch(getLatestUserProfileDataProvider).when(
        data: (data) {
          if (data.events.contains(
            'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.usersCollection}.documents.${copyOfUser.uid}.update',
          ) || data.events.contains(
            'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.usersCollection}.documents.${copyOfUser.uid}.create',
          )
          ) {
            copyOfUser = UserModel.fromMap(data.payload);
          }
          return UserProfileWidget(user: copyOfUser);
        },
        error: (error, st) => ErrorText(
          error: error.toString(),
        ),
        loading: () {
          return UserProfileWidget(user: copyOfUser);
        },
      ),
    );
  }
}