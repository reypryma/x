import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x/common/common.dart';
import 'package:x/features/auth/controller/auth_controller.dart';
import 'package:x/features/profile/controller/profile_controller.dart';
import 'package:x/model/user.dart';
import 'package:x/theme/theme.dart';

class EditProfileView extends ConsumerStatefulWidget {
  const EditProfileView({
    Key? key,
  }) : super(key: key);

  static route() => MaterialPageRoute(
        builder: (context) => const EditProfileView(),
      );

  @override
  ConsumerState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  late TextEditingController nameController;
  late TextEditingController bioController;

  File? bannerFile;
  File? profileFile;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
      text: ref.read(currentUserDetailsProvider).value?.name ?? '',
    );
    bioController = TextEditingController(
      text: ref.read(currentUserDetailsProvider).value?.bio ?? '',
    );
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    bioController.dispose();
  }

  void selectBannerImage() async {
    final banner = await pickImage();
    if (banner != null) {
      setState(() {
        bannerFile = banner;
      });
    }
  }

  void selectProfileImage() async {
    final profileImage = await pickImage();
    if (profileImage != null) {
      setState(() {
        profileFile = profileImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserDetailsProvider).value;
    final isLoading = ref.watch(userProfileControllerProvider);

    Widget getBannerWidget(UserModel user) {
      if (kIsWeb) {
        if (user.bannerPic.isNotEmpty) {
          return Image.network(
            user.bannerPic,
            fit: BoxFit.fitWidth,
          );
        }
        if (bannerFile != null) {
          return Image.network(
            bannerFile!.path,
            fit: BoxFit.fitWidth,
          );
        } else {
          return Container(
            color: Pallete.blueColor,
          );
        }
      } else {
        if (bannerFile != null) {
          return Image.file(
            bannerFile!,
            fit: BoxFit.fitWidth,
          );
        } else {
          return Container(
            color: Pallete.blueColor,
          );
        }
      }
    }

    Widget getProfileImageWidget(UserModel user) {
      if (kIsWeb) {
        return CircleAvatar(
          backgroundImage: NetworkImage(profileFile?.path ?? user.profilePic),
          radius: 40,
        );
      } else {
        if (profileFile != null) {
          return CircleAvatar(
            backgroundImage: FileImage(profileFile!),
            radius: 40,
          );
        } else {
          return CircleAvatar(
            backgroundImage: NetworkImage(user.profilePic),
            radius: 40,
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: false,
        actions: [
          TextButton(
              onPressed: () async {
                ref
                    .read(userProfileControllerProvider.notifier)
                    .updateUserProfile(
                      userModel: user!.copyWith(
                        bio: bioController.text,
                        name: nameController.text,
                      ),
                      context: context,
                      bannerFile: bannerFile,
                      profileFile: profileFile,
                    );
              },
              child: const Text('Save'))
        ],
      ),
      body: isLoading || user == null
          ? const LoadingWidget()
          : Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width * .15,
                  child: Stack(
                    children: [
                      GestureDetector(
                          onTap: selectBannerImage,
                          child: Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.width * .1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: getBannerWidget(user),
                          )),
                      Positioned(
                          bottom: MediaQuery.of(context).size.width * .05 - 30,
                          left: 20,
                          child: GestureDetector(
                            onTap: selectProfileImage,
                              child: getProfileImageWidget(user))),
                    ],
                  ),
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Name',
                    contentPadding: EdgeInsets.all(18),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: bioController,
                  decoration: const InputDecoration(
                    hintText: 'Bio',
                    contentPadding: EdgeInsets.all(18),
                  ),
                  maxLines: 4,
                ),
              ],
            ),
    );
  }
}
