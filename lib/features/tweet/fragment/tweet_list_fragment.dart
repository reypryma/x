import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x/common/common.dart';
import 'package:x/constants/constants.dart';
import 'package:x/features/auth/controller/auth_controller.dart';
import 'package:x/features/tweet/controller/tweet_controller.dart';
import 'package:x/features/tweet/widget/tweet_card.dart';
import 'package:x/model/tweet.dart';

class TweetListFragment extends ConsumerWidget {
  const TweetListFragment({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // UserModel? userData = ref.watch(currentUserDetailsProvider).value;
    //currentUserAccountProvider
    return ref.watch(currentUserDetailsProvider).when(data: (user) {
      return ref.watch(getTweetsProvider).when(
          data: (tweets) {
            // print("View tweets view data1 $tweets");
            return ref.watch(getLatestTweetProvider).when(
                data: (data) {
                  if (data.events.contains(
                    'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.create',
                  )) {
                    tweets.insert(0, Tweet.fromMap(data.payload));
                  } else if (data.events.contains(
                    'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.update',
                  )) {
                    print("data events: " + data.events[0]);
                    final startingPoint =
                        data.events[0].lastIndexOf('documents.');
                    final endPoint = data.events[0].lastIndexOf('.update');

                    print("starting point $startingPoint endpoint $endPoint");

                    final tweetId =
                        data.events[0].substring(startingPoint + 10, endPoint);
                    print('get tweet id $tweetId');

                    var tweet =
                        tweets.where((element) => element.id == tweetId).first;

                    final tweetIndex = tweets.indexOf(tweet);
                    tweets.removeWhere((element) => element.id == tweetId);

                    tweet = Tweet.fromMap(data.payload);
                    tweets.insert(tweetIndex, tweet);
                  } else {
                    print('dataevents1');
                    print("data events: " + data.events[0]);
                    final startingPoint =
                    data.events[0].lastIndexOf('documents.');
                    final endPoint = data.events[0].lastIndexOf('.update');

                    print("starting point $startingPoint endpoint $endPoint");
                  }

                  // print("View tweets view data2}");
                  return ListView.builder(
                    itemCount: tweets.length,
                    itemBuilder: (BuildContext context, int index) {
                      // print("View tweets view data3");
                      final tweet = tweets[index];
                      return TweetCard(tweet: tweet);
                    },
                  );
                },
                error: (error, stackTrace) => ErrorText(
                      error: "$error $stackTrace",
                    ),
                loading: () {
                  return user == null ? SizedBox() : ListView.builder(
                    itemCount: tweets.length,
                    itemBuilder: (BuildContext context, int index) {
                      final tweet = tweets[index];
                      return TweetCard(tweet: tweet);
                    },
                  );
                });
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () {
            return const LoadingWidget();
          });
    }, error: (Object error, StackTrace stackTrace) {
      return ErrorText(
        error: "$error $stackTrace",
      );
    }, loading: () {
      return const LoadingWidget();
    });
  }
}
