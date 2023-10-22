import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x/common/common.dart';
import 'package:x/features/explore/controller/explore_controller.dart';
import 'package:x/features/explore/widgets/search_tile.dart';
import 'package:x/model/user.dart';
import 'package:x/theme/pallete.dart';

class ExploreFragment extends ConsumerStatefulWidget {
  const ExploreFragment({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ExploreFragmentState();
}

class _ExploreFragmentState extends ConsumerState<ExploreFragment> {
  final searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBarTextFieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(
        color: Pallete.searchBarColor,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 50,
          child: TextField(
            controller: searchController,
            onSubmitted: (value) {
              setState(() {
                isShowUsers = true;
              });
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10).copyWith(
                left: 20,
              ),
              fillColor: Pallete.searchBarColor,
              filled: true,
              enabledBorder: appBarTextFieldBorder,
              focusedBorder: appBarTextFieldBorder,
              hintText: 'Search Twitter',
            ),
          ),
        ),
      ),
      body: isShowUsers
          ? ref.watch(searchUserProvider(searchController.text)).when(
        data: (users) {
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              final user = users[index];
              return SearchTile(user);
            },
          );
        },
        error: (error, st) => ErrorText(
          error: error.toString(),
        ),
        loading: () => const LoadingWidget(),
      )
          : const SizedBox(),
    );
  }
}
