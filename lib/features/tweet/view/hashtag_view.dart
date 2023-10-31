import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x/common/common.dart';
import 'package:x/constants/appwrite_constants.dart';
import 'package:x/features/tweet/controller/tweet_controller.dart';
import 'package:x/features/tweet/widget/tweet_card.dart';
import 'package:x/model/tweet.dart';

class HashtagView extends ConsumerWidget {
  static route(String hashtag) => MaterialPageRoute(
        builder: (context) {
          return HashtagView(
            hashTag: hashtag,
          );
        },
      );

  final String hashTag;

  const HashtagView({Key? key, required this.hashTag}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hashTag),
      ),
        body: ref.watch(getTweetsByHashtagProvider(hashTag)).when(
          data: (tweets) {
            return ref.watch(getLatestTweetProvider).when(
                data: (data) {
                  if (data.events.contains(
                    'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.create',
                  )) {
                    tweets.insert(0, Tweet.fromMap(data.payload));
                  } else if (data.events.contains(
                    'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.update',
                  )) {
                    if (kDebugMode) {
                      print("data events: ${data.events[0]}");
                    }
                    final startingPoint =
                    data.events[0].lastIndexOf('documents.');
                    final endPoint = data.events[0].lastIndexOf('.update');

                    if (kDebugMode) {
                      print("starting point $startingPoint endpoint $endPoint");
                    }

                    final tweetId =
                    data.events[0].substring(startingPoint + 10, endPoint);
                    if (kDebugMode) {
                      print('get tweet id $tweetId');
                    }

                    var tweet =
                        tweets.where((element) => element.id == tweetId).first;

                    final tweetIndex = tweets.indexOf(tweet);
                    tweets.removeWhere((element) => element.id == tweetId);

                    tweet = Tweet.fromMap(data.payload);
                    tweets.insert(tweetIndex, tweet);
                  } else {
                    if (kDebugMode) {
                      print('dataevents1');
                    }
                    if (kDebugMode) {
                      print("data events: ${data.events[0]}");
                    }
                    final startingPoint =
                    data.events[0].lastIndexOf('documents.');
                    final endPoint = data.events[0].lastIndexOf('.update');

                    if (kDebugMode) {
                      print("starting point $startingPoint endpoint $endPoint");
                    }
                  }

                  // print("View tweets view data2}");
                  return ListView.builder(
                    itemCount: tweets.length,
                    itemBuilder: (BuildContext context, int index) {
                      final tweet = tweets[index];
                      return TweetCard(tweet: tweet);
                    },
                  );
                },
                error: (error, stackTrace) => ErrorText(
                  error: "$error $stackTrace",
                ),
                loading: () {
                  return ListView.builder(
                    itemCount: tweets.length,
                    itemBuilder: (BuildContext context, int index) {
                      final tweet = tweets[index];
                      return TweetCard(tweet: tweet);
                    },
                  );
                });
          },
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const LoadingWidget(),
        ),
    );
  }
}
