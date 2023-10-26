
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
        builder: (context) => UserProfileView(user: userModel),
      );

  final UserModel user;

  const UserProfileView({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel copyOfUser = user;

    return Scaffold(
      body: UserProfileWidget(user: copyOfUser,)
    );
  }
}
