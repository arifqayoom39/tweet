import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/tweet/views/create_tweet_view.dart';
import 'package:twitter_clone/features/user_profile/view/user_profile_view.dart';
import 'package:twitter_clone/theme/pallete.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';

class HomeView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const HomeView(),
      );
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  int _page = 0;
  final appBar = UIConstants.appBar();

  // Hold the UserProfileView lazily
  Widget? userProfileView;

  void onPageChange(int index) {
    if (index == 2) {
      onCreatetweet();
    } else {
      setState(() {
        _page = index;
        if (index == 4 && userProfileView == null) {
          // Initialize UserProfileView only when the profile tab is selected
          final currentUser = ref.read(currentUserDetailsProvider).value;
          if (currentUser != null) {
            userProfileView = UserProfileView(userModel: currentUser);
          }
        }
      });
    }
  }

  onCreatetweet() {
    Navigator.push(context, CreatetweetScreen.route());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _page == 0 ? appBar : null,
      body: IndexedStack(
        index: _page,
        children: [
          UIConstants.bottomTabBarPages[0], // Home
          UIConstants.bottomTabBarPages[1], // Search
          Container(), // Empty container for the middle tab (Create tweet)
          UIConstants.bottomTabBarPages[2], // Notifications
          userProfileView ?? Container(), // Profile, initialized lazily
        ],
      ),
      // Removed the SideDrawer property from here
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _page,
        onTap: onPageChange,
        backgroundColor: Pallete.backgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              _page == 0 ? Icons.home_filled : Icons.home_outlined,
              color: Pallete.whiteColor,
            ),
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: Pallete.whiteColor,
            ),
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
              color: Pallete.whiteColor,
              size: 35, // Highlight "Create tweet" action
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _page == 3 ? Icons.notifications : Icons.notifications_none,
              color: Pallete.whiteColor,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _page == 4 ? Icons.person : Icons.person_outline,
              color: Pallete.whiteColor,
            ),
          ),
        ],
      ),
    );
  }
}
