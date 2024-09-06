import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/error_page.dart';
import 'package:twitter_clone/common/loading_page.dart';
import 'package:twitter_clone/features/explore/controller/explore_controller.dart';
import 'package:twitter_clone/features/explore/widgets/search_tile.dart';
import 'package:twitter_clone/theme/pallete.dart';

class ExploreView extends ConsumerStatefulWidget {
  const ExploreView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  final searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBarTextFieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide.none,
    );

    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0, bottom: 10.0),
          child: SizedBox(
            height: 50,
            child: TextField(
              controller: searchController,
              onSubmitted: (value) {
                setState(() {
                  isShowUsers = true;
                });
              },
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white, // Set the entered text color to white
              ),
              cursorColor: Pallete.blueColor,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
                fillColor: Pallete.searchBarColor,
                filled: true,
                enabledBorder: appBarTextFieldBorder,
                focusedBorder: appBarTextFieldBorder,
                hintText: 'Search tweet',
                hintStyle: TextStyle(
                  color: Pallete.greyColor.withOpacity(0.8),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Pallete.greyColor),
                  onPressed: () {
                    setState(() {
                      isShowUsers = true;
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: isShowUsers
            ? ref.watch(searchUserProvider(searchController.text)).when(
                  data: (users) {
                    if (users.isEmpty) {
                      return const Center(
                        child: Text(
                          'No users found',
                          style: TextStyle(color: Pallete.greyColor),
                        ),
                      );
                    }
                    return ListView.separated(
                      itemCount: users.length,
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        color: Pallete.searchBarColor,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        final user = users[index];
                        return SearchTile(userModel: user);
                      },
                    );
                  },
                  error: (error, st) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () => const Loader(),
                )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search,
                      size: 80,
                      color: Pallete.greyColor.withOpacity(0.5),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Search for users to explore',
                      style: TextStyle(
                        fontSize: 18,
                        color: Pallete.greyColor,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
