import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:x/features/explore/fragment/explore_fragment.dart';
import 'package:x/features/notification/fragment/notification_view.dart';
import 'package:x/features/tweet/fragment/tweet_list_fragment.dart';
import 'package:x/theme/pallete.dart';

import 'constants.dart';


class UIConstants {
  static AppBar appBar() {
    return AppBar(
      title: SvgPicture.asset(
        AssetsConstants.twitterLogo,
        colorFilter: const ColorFilter.mode(Pallete.blueColor, BlendMode.srcIn),
        height: 30,
      ),
      centerTitle: true,
    );
  }

  static const List<Widget> bottomTabBarPages = [
    TweetListFragment(),
    ExploreFragment(),
    NotificationFragment(),
  ];
}
