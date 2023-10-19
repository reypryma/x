import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x/features/tweet/widget/tweet_card.dart';
import 'package:x/model/tweet.dart';

class TwitterReplyScreen extends ConsumerWidget {
  static route(Tweet tweet) => MaterialPageRoute(builder:
  (context) => TwitterReplyScreen(tweet: tweet)
  );

  const TwitterReplyScreen({
    Key? key,
    required this.tweet
  }) : super(key: key);
  final Tweet tweet;


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tweet'),
      ),
      body: Column(
        children: [
          TweetCard(tweet: tweet)
        ],
      ),
      bottomNavigationBar: TextField(
        onSubmitted: (value) {

        },
        decoration: const InputDecoration(
          hintText: 'Tweet your reply',
        ),
      ),
    );
  }
}
