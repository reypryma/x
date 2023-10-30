import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x/core/core.dart';
import 'package:x/core/enum/notification_type_enum.dart';
import 'package:x/features/auth/controller/auth_controller.dart';
import 'package:x/features/notification/controller/notification_controller.dart';
import 'package:x/model/tweet.dart';
import 'package:x/model/user.dart';
import 'package:x/repository/storage_api.dart';
import 'package:x/repository/tweet_api.dart';

import '../../../common/common.dart';

final tweetControllerProvider = StateNotifierProvider<TweetController, bool>(
  (ref) {
    return TweetController(
      ref: ref,
      tweetAPI: ref.watch(tweetAPIProvider),
      storageAPI: ref.watch(storageAPIProvider),
      notificationController:
          ref.watch(notificationControllerProvider.notifier),
    );
  },
);

final getTweetsProvider = FutureProvider((ref) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweets();
});


final getRepliesToTweetsProvider = FutureProvider.family((ref, Tweet tweet) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getRepliesToTweet(tweet);
});

final getTweetByIdProvider = FutureProvider.family((ref, String id) async {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweetById(id);
});

final getTweetsByHashtagProvider = FutureProvider.family((ref, String hashtag) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweetsByHashtag(hashtag);
});

//family has data type immutable
final getLatestTweetProvider = StreamProvider((ref) {
  final tweetAPI = ref.watch(tweetAPIProvider);
  if (kDebugMode) {
    print("getLatestTweetProvider ${tweetAPI.getLatestTweet().toList()}");
  }
  return tweetAPI.getLatestTweet();
});

class TweetController extends StateNotifier<bool> {
  final TweetAPI _tweetAPI;
  final StorageAPI _storageAPI;
  final NotificationController _notificationController;
  final Ref _ref;
  TweetController({
    required Ref ref,
    required TweetAPI tweetAPI,
    required StorageAPI storageAPI,
    required NotificationController notificationController,
  })  : _ref = ref,
        _tweetAPI = tweetAPI,
        _storageAPI = storageAPI,
        _notificationController = notificationController,
        super(false);

  Future<List<Tweet>> getTweets() async {
      try {
        final tweetList = await _tweetAPI.getTweets();
        return tweetList.map((tweet) => Tweet.fromMap(tweet.data)).toList();
      } catch (e) {
        if (kDebugMode) {
          print("Stack get tweets error $e");
        }
        rethrow;
      }
  }

  Future<Tweet> getTweetById(String id) async {
    final tweet = await _tweetAPI.getTweetById(id);
    return Tweet.fromMap(tweet.data);
  }



  void shareTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repliedToUserId,
  }) {
    if (text.isEmpty) {
      showSnackBar(context, 'Please enter text');
      return;
    }
    if (images.isNotEmpty) {
      _shareImageTweet(
        images: images,
        text: text,
        context: context,
        repliedTo: repliedTo,
        repliedToUserId: repliedToUserId,
      );
    } else {
      _shareTextTweet(
        text: text,
        context: context,
        repliedTo: repliedTo,
        repliedToUserId: repliedToUserId,
      );
    }
  }

  void _shareImageTweet(
      {required List<File> images,
      required String text,
      required BuildContext context,
      required String repliedTo,
      required String repliedToUserId}) async {
    state = true;
    final hashtags = _getHashtagsFromText(text);
    String link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    final imageLinks = await _storageAPI.uploadImage(images);
    Tweet tweet = Tweet(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: imageLinks,
      uid: user.uid,
      tweetType: TweetType.image,
      tweetedAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: '',
      reshareCount: 0,
      retweetedBy: '',
      repliedTo: repliedTo,
    );
    final res = await _tweetAPI.shareTweet(tweet);

    res.fold((l) => showSnackBar(context, l.message), (r) async {
      showSnackBar(context, "Success Create tweet");
      if (repliedToUserId.isNotEmpty) {
        await _notificationController.createNotification(
          text: '${user.name} replied to your tweet!',
          postId: r.$id,
          notificationType: NotificationType.reply,
          uid: repliedToUserId,
        );
      }
    });
    state = false;
  }

  void _shareTextTweet({
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repliedToUserId,
  }) async {
    state = true;
    final hashtags = _getHashtagsFromText(text);
    String link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;

    Tweet tweet = Tweet(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: const [],
      uid: user.uid,
      tweetType: TweetType.text,
      tweetedAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: '',
      reshareCount: 0,
      retweetedBy: '',
      repliedTo: repliedTo,
    );

    final res = await _tweetAPI.shareTweet(tweet);
    res.fold((l) {
      if (kDebugMode) {
        print("Error share tweet. ${l.stackTrace}");
      }
      showSnackBar(context, l.message);
    }, (r) {
      if (repliedToUserId.isNotEmpty) {}
    });
    state = false;
  }

  Future<List<Tweet>> getTweetsByHashtag(String hashtag) async {
    final documents = await _tweetAPI.getTweetsByHashtag(hashtag);
    return documents.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  List<String> _getHashtagsFromText(String text) {
    return text.split(' ').where((word) => word.startsWith('#')).toList();
  }

  String _getLinkFromText(String text) {
    return text.split(' ').firstWhere(
          (word) => word.startsWith('https://') || word.startsWith('www.'),
          orElse: () => '',
        );
  }

  Future likeTweet(Tweet tweet, UserModel user) async {
    List<String> likes = tweet.likes;
    String textLike = user.name;

    if (tweet.likes.contains(user.uid)) {
      likes.remove(user.uid);
      textLike += "Unlike your tweet";
    } else {
      likes.add(user.uid);
      textLike += "Like your tweet";
    }

    tweet = tweet.copyWith(likes: likes);
    final res = await _tweetAPI.likeTweet(tweet);
    res.fold((l) => null, (r) {
      _notificationController.createNotification(
        text: textLike,
        postId: tweet.id,
        notificationType: NotificationType.like,
        uid: tweet.uid,
      );
    });
  }

  Future<List<Tweet>> getRepliesToTweet(Tweet tweet) async {
    final documents = await _tweetAPI.getRepliesToTweet(tweet);
    return documents.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  void reshareTweet(
      Tweet tweet,
      UserModel currentUser,
      BuildContext context,
      ) async {
    tweet = tweet.copyWith(
      retweetedBy: currentUser.name,
      likes: [],
      commentIds: [],
      reshareCount: tweet.reshareCount + 1,
    );

    final res = await _tweetAPI.updateReShareCount(tweet);
    res.fold(
          (l) => showSnackBar(context, l.message),
          (r) async {
        tweet = tweet.copyWith(
          id: ID.unique(),
          reshareCount: 0,
          tweetedAt: DateTime.now(),
        );
        final res2 = await _tweetAPI.shareTweet(tweet);
        res2.fold(
              (l) => showSnackBar(context, l.message),
              (r) {
            _notificationController.createNotification(
              text: '${currentUser.name} reshared your tweet!',
              postId: tweet.id,
              notificationType: NotificationType.retweet,
              uid: tweet.uid,
            );
            showSnackBar(context, 'Retweeted!');
          },
        );
      },
    );
  }
}
