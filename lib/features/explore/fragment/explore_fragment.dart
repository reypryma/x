import 'package:flutter/material.dart';

class ExploreFragment extends StatefulWidget {
  const ExploreFragment({super.key});

  @override
  State<ExploreFragment> createState() => _ExploreFragmentState();
}

class _ExploreFragmentState extends State<ExploreFragment> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Explore"),
    );
  }
}
