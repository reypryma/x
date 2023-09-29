import 'package:flutter/material.dart';

class TweetListFragment extends StatefulWidget {
  const TweetListFragment({super.key});

  @override
  State<TweetListFragment> createState() => _TweetListFragmentState();
}

class _TweetListFragmentState extends State<TweetListFragment> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Tweet"),
    );
  }
}
