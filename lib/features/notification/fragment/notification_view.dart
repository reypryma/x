import 'package:flutter/material.dart';

class NotificationFragment extends StatefulWidget {
  const NotificationFragment({super.key});

  @override
  State<NotificationFragment> createState() => _NotificationFragmentState();
}

class _NotificationFragmentState extends State<NotificationFragment> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Notiffication"),
    );
  }
}
