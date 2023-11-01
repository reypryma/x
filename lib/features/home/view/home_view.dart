import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:x/constants/constants.dart';
import 'package:x/features/home/widgets/side_drawer.dart';
import 'package:x/features/tweet/view/create_tweet_view.dart';
import 'package:x/theme/theme.dart';

class HomeView extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomeView());

  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _appBar = UIConstants.appBar();
  int _page = 0;

  void onPageChange(int index) {
    setState(() {
      _page = index;
    });
  }

  onCreateTweet(){
    Navigator.push(context, CreateTweetView.route());
  }

  BottomNavigationBarItem bottomNavigationBarItem(bool isSelected,
      {required String filledIcon, required String outlineIcon}) {
    return BottomNavigationBarItem(
        icon: SvgPicture.asset(
      isSelected ? filledIcon : outlineIcon,
      colorFilter: const ColorFilter.mode(Pallete.whiteColor, BlendMode.srcIn),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _page == 0 ? _appBar : null,
      drawer: const SideDrawer(),
      body: IndexedStack(
        index: _page,
        children: UIConstants.bottomTabBarPages,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onCreateTweet,
        child: const Icon(
          Icons.add,
          color: Pallete.whiteColor,
          size: 28,
        ),
      ),
      bottomNavigationBar: CupertinoTabBar(
        height: MediaQuery.of(context).size.height * 0.05,
        onTap: onPageChange,
        currentIndex: _page,
        backgroundColor: Pallete.backgroundColor,
        items: [
          bottomNavigationBarItem(_page == 0, filledIcon: AssetsConstants.homeFilledIcon, outlineIcon: AssetsConstants.homeOutlinedIcon),
          bottomNavigationBarItem(false, filledIcon: AssetsConstants.searchIcon, outlineIcon: AssetsConstants.searchIcon,),
          bottomNavigationBarItem(_page == 2, filledIcon: AssetsConstants.notifFilledIcon, outlineIcon: AssetsConstants.notifOutlinedIcon,),
        ],
      ),
    );
  }
}
