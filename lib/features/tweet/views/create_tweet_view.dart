import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/common/loading_page.dart';
import 'package:twitter_clone/common/rounded_small_button.dart';
import 'package:twitter_clone/constants/assets_constants.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/theme/pallete.dart';

class CreatetweetScreen extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const CreatetweetScreen(),
      );
  const CreatetweetScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreatetweetScreenState();
}

class _CreatetweetScreenState extends ConsumerState<CreatetweetScreen> {
  final tweetTextController = TextEditingController();
  List<File> images = [];

  @override
  void dispose() {
    tweetTextController.dispose();
    super.dispose();
  }

  void sharetweet() {
    ref.read(tweetControllerProvider.notifier).shareTweet(
          images: images,
          text: tweetTextController.text,
          context: context,
          repliedTo: '',
          repliedToUserId: '',
        );
    Navigator.pop(context);
  }

  void onPickImages() async {
    images = await pickImages();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final isLoading = ref.watch(tweetControllerProvider);

    return Scaffold(
      appBar: AppBar(
  leading: IconButton(
    onPressed: () => Navigator.pop(context),
    icon: const Icon(Icons.close, size: 24),
  ),
  actions: [
    Padding(
      padding: const EdgeInsets.only(right: 8.0), // Adds padding from the right side
      child: RoundedSmallButton(
        onTap: sharetweet,
        label: 'tweet',
        backgroundColor: Pallete.blueColor,
        textColor: Pallete.whiteColor,
        fontSize: 14, // Smaller font size
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3), // Smaller padding
      ),
    ),
  ],
),

      body: isLoading || currentUser == null
          ? const Loader()
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(currentUser.profilePic),
                          radius: 20, // Smaller profile picture
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: tweetTextController,
                            style: const TextStyle(
                              fontSize: 16, // Smaller text size
                            ),
                            decoration: const InputDecoration(
                              hintText: "What's happening?",
                              hintStyle: TextStyle(
                                color: Pallete.greyColor,
                                fontSize: 16, // Smaller hint text size
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 8.0), // Smaller padding inside the text field
                            ),
                            maxLines: null,
                          ),
                        ),
                      ],
                    ),
                    if (images.isNotEmpty)
                      CarouselSlider(
                        items: images.map(
                          (file) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Image.file(file, fit: BoxFit.cover),
                            );
                          },
                        ).toList(),
                        options: CarouselOptions(
                          height: 250, // Smaller carousel height
                          enableInfiniteScroll: false,
                        ),
                      ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Pallete.greyColor,
              width: 0.3,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: onPickImages,
              child: SvgPicture.asset(
                AssetsConstants.galleryIcon,
                width: 24, // Smaller icon size
                height: 24, // Smaller icon size
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: SvgPicture.asset(
                AssetsConstants.gifIcon,
                width: 24, // Smaller icon size
                height: 24, // Smaller icon size
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: SvgPicture.asset(
                AssetsConstants.emojiIcon,
                width: 24, // Smaller icon size
                height: 24, // Smaller icon size
              ),
            ),
          ],
        ),
      ),
    );
  }
}
