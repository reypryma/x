import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x/common/common.dart';
import 'package:x/features/tweet/controller/tweet_controller.dart';
import 'package:x/features/tweet/widget/tweet_card.dart';

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
            return ListView.builder(
              itemCount: tweets.length,
              itemBuilder: (BuildContext context, int index) {
                final tweet = tweets[index];
                return TweetCard(tweet: tweet);
              },
            );
          },
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const LoadingWidget(),
        ),
    );
  }
}
