import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x/common/common.dart';
import 'package:x/core/enum/notification_type_enum.dart';
import 'package:x/features/notification/controller/notification_controller.dart';
import 'package:x/model/tweet.dart';
import 'package:x/model/user.dart';
import 'package:x/repository/storage_api.dart';
import 'package:x/repository/tweet_api.dart';
import 'package:x/repository/user_api.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  return UserProfileController(
    tweetAPI: ref.watch(tweetAPIProvider),
    storageAPI: ref.watch(storageAPIProvider),
    userAPI: ref.watch(userAPIProvider),
    notificationController: ref.watch(notificationControllerProvider.notifier),
  );
});

final getUserTweetsProvider = FutureProvider.family((ref, String uid) async {
  final userProfileController =
      ref.watch(userProfileControllerProvider.notifier);
  return userProfileController.getUserTweets(uid);
});

final getLatestUserProfileDataProvider = StreamProvider((ref) {
  final userAPI = ref.watch(userAPIProvider);
  print("getLatestUserProfileDataProvider" + userAPI.getLatestUserProfileData().toList().toString());
  return userAPI.getLatestUserProfileData();
});

class UserProfileController extends StateNotifier<bool> {
  final TweetAPI _tweetAPI;
  final StorageAPI _storageAPI;
  final UserAPI _userAPI;
  final NotificationController _notificationController;

  UserProfileController({
    required TweetAPI tweetAPI,
    required StorageAPI storageAPI,
    required UserAPI userAPI,
    required NotificationController notificationController,
  })  : _tweetAPI = tweetAPI,
        _storageAPI = storageAPI,
        _userAPI = userAPI,
        _notificationController = notificationController,
        super(false);

  Future<List<Tweet>> getUserTweets(String uid) async {
    final tweets = await _tweetAPI.getUserTweets(uid);
    return tweets.map((e) => Tweet.fromMap(e.data)).toList();
  }

  void updateUserProfile({
    required UserModel userModel,
    required BuildContext context,
    required File? bannerFile,
    required File? profileFile,
  }) async {
    state = true;
    if (bannerFile != null) {
      final bannerUrl = await _storageAPI.uploadImage([bannerFile]);
      userModel = userModel.copyWith(
        bannerPic: bannerUrl[0],
      );
    }

    if (profileFile != null) {
      final profileUrl = await _storageAPI.uploadImage([profileFile]);
      userModel = userModel.copyWith(
        profilePic: profileUrl[0],
      );
    }

    final res = await _userAPI.updateUserData(userModel);
    state = false;
    res.fold(
          (l) => showSnackBar(context, l.message),
          (r) => Navigator.pop(context),
    );
  }

  void followUser({
    required UserModel user,
    required BuildContext context,
    required UserModel currentUser,
  }) async {
    bool isFollowing = false;
    // already following
    if (currentUser.following.contains(user.uid)) {
      user.followers.remove(currentUser.uid);
      currentUser.following.remove(user.uid);
      isFollowing = false;
    } else {
      user.followers.add(currentUser.uid);
      currentUser.following.add(user.uid);
      isFollowing = true;
    }

    user = user.copyWith(followers: user.followers);
    currentUser = currentUser.copyWith(
      following: currentUser.following,
    );

    final res = await _userAPI.followUser(user);
    res.fold((l){
      print("Error followUser _userAPI.followUser ${l.stackTrace}");
      showSnackBar(context, l.message);
    }, (r) async {
      final res2 = await _userAPI.addToFollowing(currentUser);
      res2.fold((l) {showSnackBar(context, l.message);}, (r) async {
        var textFollow = "${currentUser.name} ";

        isFollowing ? textFollow += "Following you" : textFollow += "Unfollow you";

        await _notificationController.createNotification(
          text: textFollow,
          postId: '',
          notificationType: NotificationType.follow,
          uid: user.uid,
        );
      });
    });
  }
}
