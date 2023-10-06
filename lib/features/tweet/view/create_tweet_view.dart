import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:x/common/common.dart';
import 'package:x/constants/constants.dart';
import 'package:x/features/auth/controller/auth_controller.dart';
import 'package:x/features/tweet/controller/tweet_controller.dart';
import 'package:x/model/user.dart';
import 'package:x/theme/pallete.dart';

class CreateTweetView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => CreateTweetView(),
      );

  const CreateTweetView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateTweetViewState();
}

class _CreateTweetViewState extends ConsumerState<CreateTweetView> {
  final tweetTextController = TextEditingController();
  List<File> images = [];

  void onPickImages() async {
    images = await pickImages();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    tweetTextController.dispose();
  }

  void shareTweet() {
    ref.read(tweetControllerProvider.notifier).shareTweet(
      images: images,
      text: tweetTextController.text,
      context: context,
      repliedTo: '',
      repliedToUserId: '',
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    UserModel? currentUser = ref.watch(currentUserDetailsProvider).value;
    bool isLoading = ref.watch(tweetControllerProvider);

    Widget showAttachmentOption(
        {VoidCallback? onTap, required String assetName}) {
      double paddingSize = MediaQuery.of(context).size.width * .04;
      return Padding(
        padding: EdgeInsets.all(paddingSize).copyWith(
          left: 15,
          right: 15,
        ),
        child: GestureDetector(
          onTap: onTap ?? () {},
          child: SvgPicture.asset(
            assetName,
            width: paddingSize * 1.2,
            height: paddingSize * 1.2,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close, size: 30),
        ),
        actions: [
          RoundedSmallButton(
            onTap: shareTweet,
            label: 'Tweet',
            backgroundColor: Pallete.blueColor,
            textColor: Pallete.whiteColor,
          ),
        ],
      ),
      body: currentUser == null || isLoading
          ? LoadingWidget()
          : SafeArea(
              child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(currentUser.profilePic),
                        radius: 30,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                          child: TextField(
                        controller: tweetTextController,
                        style: const TextStyle(
                          fontSize: 22,
                        ),
                        decoration: const InputDecoration(
                          hintText: "What's happening?",
                          hintStyle: TextStyle(
                              color: Pallete.greyColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                      ))
                    ],
                  ),
                  if (images.isNotEmpty)
                    CarouselSlider(
                        items: images.map((e) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: MarginConstant.marginHorizontal5,
                            child: Image.file(
                              e,
                              fit: BoxFit.cover,
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                            enlargeCenterPage: true,
                            height: 400,
                            enableInfiniteScroll: false))
                ],
              ),
            )),
      bottomNavigationBar: Container(
        padding: PaddingConstant.paddingHorizontal25,
        decoration: const BoxDecoration(
            border:
                Border(top: BorderSide(color: Pallete.greyColor, width: 0.3))),
        child: Row(
          children: [
            showAttachmentOption(
                assetName: AssetsConstants.galleryIcon, onTap: onPickImages),
            showAttachmentOption(assetName: AssetsConstants.gifIcon),
            showAttachmentOption(assetName: AssetsConstants.emojiIcon),
          ],
        ),
      ),
    );
  }
}
