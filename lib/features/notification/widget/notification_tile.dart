import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:x/constants/assets_constants.dart';
import 'package:x/core/enum/notification_type_enum.dart';
import 'package:x/model/notification.dart' as model;
import 'package:x/theme/pallete.dart';

class NotificationTile extends StatelessWidget {
  final model.Notification notification;
  const NotificationTile({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: notification.notificationType == NotificationType.follow
          ? const Icon(
        Icons.person,
        color: Pallete.blueColor,
      )
          : notification.notificationType == NotificationType.like
          ? SvgPicture.asset(
        AssetsConstants.likeFilledIcon,
        colorFilter: const ColorFilter.mode(Pallete.redColor, BlendMode.srcIn),
        height: 20,
      )
          : notification.notificationType == NotificationType.retweet
          ? SvgPicture.asset(
        AssetsConstants.retweetIcon,
        colorFilter: const ColorFilter.mode(Pallete.whiteColor, BlendMode.srcIn),
        height: 20,
      )
          : null,
      title: Text(notification.text),
    );
  }
}