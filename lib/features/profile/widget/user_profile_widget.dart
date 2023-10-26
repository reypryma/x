import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:x/common/common.dart';
import 'package:x/constants/constants.dart';
import 'package:x/features/auth/controller/auth_controller.dart';
import 'package:x/features/profile/controller/profile_controller.dart';
import 'package:x/features/tweet/controller/tweet_controller.dart';
import 'package:x/features/tweet/widget/tweet_card.dart';
import 'package:x/model/tweet.dart';
import 'package:x/model/user.dart';
import 'package:x/theme/pallete.dart';

import 'follow_count.dart';

class UserProfileWidget extends ConsumerWidget {
  final UserModel user;

  const UserProfileWidget({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    return currentUser == null
        ? const LoadingWidget()
        : NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 150,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(children: [
                    //take all space
                    Positioned.fill(
                        child: user.bannerPic.isEmpty
                            ? Container(
                                color: Pallete.blueColor,
                              )
                            : Image.network(user.bannerPic)),
                    Positioned(
                      bottom: 0,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(user.profilePic),
                        radius: 45,
                      ),
                    ),
                    Container(
                        alignment: Alignment.bottomRight,
                        margin: const EdgeInsets.all(20),
                        child: OutlinedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                              color: Pallete.whiteColor,
                            ),
                          )),
                          child: const Text(
                            "Edit Profile",
                            style: TextStyle(
                              color: Pallete.whiteColor,
                            ),
                          ),
                        ))
                  ]),
                ),
                SliverPadding(
                  padding: PaddingConstant.paddingAll16,
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Row(
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (user.isTwitterBlue)
                              Padding(
                                padding: const EdgeInsets.only(left: 3.0),
                                child: SvgPicture.asset(
                                  AssetsConstants.verifiedIcon,
                                ),
                              ),
                          ],
                        ),
                        Text(
                          '@${user.name}',
                          style: const TextStyle(
                            fontSize: 17,
                            color: Pallete.greyColor,
                          ),
                        ),
                        Text(
                          user.bio,
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            FollowCount(
                              count: user.following.length,
                              text: 'Following',
                            ),
                            const SizedBox(width: 15),
                            FollowCount(
                              count: user.followers.length,
                              text: 'Followers',
                            ),
                            const SizedBox(height: 2),
                            const Divider(color: Pallete.redColor, thickness: 20, height: 10),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: ref.watch(getUserTweetsProvider(user.uid)).when(
                  data: (tweets) {
                    // can make it realtime by copying code
                    // from twitter_reply_view
                    return ref.watch(getLatestTweetProvider).when(
                      data: (data) {
                        final latestTweet = Tweet.fromMap(data.payload);

                        bool isTweetAlreadyPresent = false;
                        for (final tweetModel in tweets) {
                          if (tweetModel.id == latestTweet.id) {
                            isTweetAlreadyPresent = true;
                            break;
                          }
                        }

                        if (!isTweetAlreadyPresent) {
                          if (data.events.contains(
                            'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.create',
                          )) {
                            tweets.insert(0, Tweet.fromMap(data.payload));
                          } else if (data.events.contains(
                            'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.update',
                          )) {
                            // get id of original tweet
                            final startingPoint =
                            data.events[0].lastIndexOf('documents.');
                            final endPoint =
                            data.events[0].lastIndexOf('.update');
                            final tweetId = data.events[0]
                                .substring(startingPoint + 10, endPoint);

                            var tweet = tweets
                                .where((element) => element.id == tweetId)
                                .first;

                            final tweetIndex = tweets.indexOf(tweet);
                            tweets.removeWhere(
                                    (element) => element.id == tweetId);

                            tweet = Tweet.fromMap(data.payload);
                            tweets.insert(tweetIndex, tweet);
                          }
                        }

                        return ListView.builder(
                          itemCount: tweets.length,
                          itemBuilder: (BuildContext context, int index) {
                            final tweet = tweets[index];
                            return TweetCard(tweet: tweet);
                          },
                        );
                      }, error: (Object error, StackTrace stackTrace) {
                        return ErrorText(
                          error: error.toString(),
                        );
                      }, loading: () {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: tweets.length,
                          itemBuilder: (BuildContext context, int index) {
                            final tweet = tweets[index];
                            return TweetCard(tweet: tweet);
                          },
                        ),
                      );
                    },
                    );
                  },
                  error: (error, st) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () => const LoadingWidget(),
                ),
          );
  }
}
