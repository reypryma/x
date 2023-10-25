import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x/features/notification/controller/notification_controller.dart';
import 'package:x/model/tweet.dart';
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
}
