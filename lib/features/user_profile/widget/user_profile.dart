import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/theme/pallete.dart';
import 'package:twitter_clone/models/user_model.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/user_profile/view/edit_profile_view.dart';
import 'package:twitter_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_clone/common/loading_page.dart';
import 'package:twitter_clone/common/error_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:twitter_clone/features/user_profile/widget/follow_count.dart';

class UserProfile extends ConsumerWidget {
  final UserModel user;
  const UserProfile({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    return currentUser == null
        ? const Loader()
        : NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  floating: true,
                  snap: true,
                  title: Row(
                    children: [
                      Text(
                        '@${user.name}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (user.istweetBlue)
                        Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: SvgPicture.asset(
                            AssetsConstants.verifiedIcon,
                            width: 20,
                            height: 20,
                          ),
                        ),
                    ],
                  ),
                  actions: [
                    if (currentUser.uid == user.uid)
                      IconButton(
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _showLogoutMenu(context, ref);
                        },
                      ),
                  ],
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(10),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    user.bio,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      FollowCount(
                                        count: user.following.length,
                                        text: 'Following',
                                      ),
                                      const SizedBox(width: 15),
                                      FollowCount(
                                        count: user.followers.length,
                                        text: 'Followers',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                user.profilePic,
                              ),
                              radius: 40,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildProfileButton(context, ref, currentUser),
                            TextButton(
                              onPressed: () {
                                // Share profile action
                              },
                              style: TextButton.styleFrom(
                                side: const BorderSide(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                              ),
                              child: const Text(
                                'Share Profile',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: Pallete.whiteColor),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: ref.watch(getUsertweetsProvider(user.uid)).when(
                  data: (tweets) {
                    return ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: (BuildContext context, int index) {
                        final tweet = tweets[index];
                        return tweetCard(tweet: tweet);
                      },
                    );
                  },
                  error: (error, st) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () => const Loader(),
                ),
          );
  }

  Widget _buildProfileButton(BuildContext context, WidgetRef ref, UserModel currentUser) {
    return TextButton(
      onPressed: () {
        if (currentUser.uid == user.uid) {
          Navigator.push(context, EditProfileView.route());
        } else {
          ref
              .read(userProfileControllerProvider.notifier)
              .followUser(
                user: user,
                context: context,
                currentUser: currentUser,
              );
        }
      },
      style: TextButton.styleFrom(
        side: const BorderSide(
          color: Colors.white,
          width: 1.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 12.0,
        ),
      ),
      child: Text(
        currentUser.uid == user.uid
            ? 'Edit Profile'
            : currentUser.following.contains(user.uid)
                ? 'Unfollow'
                : 'Follow',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showLogoutMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () {
                Navigator.pop(context);
                ref.read(authControllerProvider.notifier).logout(context);
              },
            ),
          ],
        );
      },
    );
  }
}







/*import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/common/error_page.dart';
import 'package:twitter_clone/common/loading_page.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:twitter_clone/features/user_profile/view/edit_profile_view.dart';
import 'package:twitter_clone/features/user_profile/widget/follow_count.dart';
import 'package:twitter_clone/models/user_model.dart';
import 'package:twitter_clone/theme/pallete.dart';

class UserProfile extends ConsumerWidget {
  final UserModel user;
  const UserProfile({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    return currentUser == null
        ? const Loader()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Profile', style: TextStyle(color: Colors.white)),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _showLogoutMenu(context, ref);
                  },
                ),
              ],
            ),
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Side - Name, Username, Bio
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      user.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (user.istweetBlue)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 3.0),
                                        child: SvgPicture.asset(
                                          AssetsConstants.verifiedIcon,
                                          width: 18,
                                          height: 18,
                                        ),
                                      ),
                                  ],
                                ),
                                Text(
                                  '@${user.name}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Pallete.greyColor,
                                  ),
                                ),
                                Text(
                                  user.bio,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Right Side - Profile Picture
                          CircleAvatar(
                            backgroundImage:
                                CachedNetworkImageProvider(user.profilePic),
                            radius: 35,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (currentUser.uid == user.uid) {
                                Navigator.push(context, EditProfileView.route());
                              } else {
                                ref
                                    .read(userProfileControllerProvider.notifier)
                                    .followUser(
                                      user: user,
                                      context: context,
                                      currentUser: currentUser,
                                    );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Pallete.tealColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                            ),
                            child: Text(
                              currentUser.uid == user.uid
                                  ? 'Edit Profile'
                                  : currentUser.following.contains(user.uid)
                                      ? 'Unfollow'
                                      : 'Follow',
                              style: const TextStyle(
                                color: Pallete.whiteColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Share profile action, not functional for now
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Pallete.greyColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                            ),
                            child: const Text(
                              'Share Profile',
                              style: TextStyle(
                                color: Pallete.whiteColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Divider(color: Pallete.whiteColor),
                  ),
                ];
              },
              body: ref.watch(getUsertweetsProvider(user.uid)).when(
                    data: (tweets) {
                      return ListView.builder(
                        itemCount: tweets.length,
                        itemBuilder: (BuildContext context, int index) {
                          final tweet = tweets[index];
                          return tweetCard(tweet: tweet);
                        },
                      );
                    },
                    error: (error, st) => ErrorText(
                      error: error.toString(),
                    ),
                    loading: () => const Loader(),
                  ),
            ),
          );
  }

  void _showLogoutMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                ref.read(authControllerProvider.notifier).logout(context);
              },
            ),
          ],
        );
      },
    );
  }
}*/

