import 'package:flutter/material.dart';

class TweetListView extends StatefulWidget {
  const TweetListView({super.key});

  @override
  State<TweetListView> createState() => _TweetListViewState();
}

class _TweetListViewState extends State<TweetListView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Tweet"),
    );
  }
}
