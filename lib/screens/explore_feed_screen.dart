import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/common_header.dart';

class ExploreFeedScreen extends StatefulWidget {
  const ExploreFeedScreen({super.key});

  @override
  State<ExploreFeedScreen> createState() => _ExploreFeedScreenState();
}

class _ExploreFeedScreenState extends State<ExploreFeedScreen> {
  List<String> videoList = [];
  bool isLoading = true;

  late PageController _pageController;

  int currentIndex = 0;

  /// 🔥 AD EVERY 4 VIDEOS
  bool isAdIndex(int index) {
    return index != 0 && index % 5 == 4;
  }

  int getRealVideoIndex(int index) {
    return index - (index ~/ 5);
  }

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    fetchVideos();
  }

  Future<void> fetchVideos() async {
    try {
      final response = await http.get(Uri.parse(
          "https://d2l5nalr80r9zx.cloudfront.net/explore_videos.json"));

      final data = jsonDecode(response.body);

      final prefs = await SharedPreferences.getInstance();
      final lastVideo =
          prefs.getString("last_explore_video");

      int startIndex = 0;

      videoList = data
          .map<String>((item) => item["url"].toString())
          .toList();

      /// ✅ RESUME LAST WATCHED VIDEO
      if (lastVideo != null) {
        final foundIndex = videoList.indexWhere(
          (video) => video == lastVideo,
        );

        if (foundIndex != -1) {
          startIndex = foundIndex;
        }
      }

      /// ✅ CREATE CONTROLLER WITH SAVED POSITION
      _pageController =
          PageController(initialPage: startIndex);

      setState(() {
        currentIndex = startIndex;
        isLoading = false;
      });
    } catch (e) {
      print("JSON ERROR: $e");

      setState(() {
        isLoading = false;
      });
    }
  }

  /// 🔥 META STYLE AD
  Widget buildMetaAd() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
        height:
            MediaQuery.of(context).size.height * 0.72,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
            image: NetworkImage(
              "https://images.unsplash.com/photo-1520607162513-77705c0f0d4a?q=80&w=1200&auto=format&fit=crop",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.45),
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            const Positioned(
              top: 18,
              left: 18,
              child: Text(
                "Sponsored",
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),

            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 24),
                child: Text(
                  "Trending Products & Viral Brands",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 30,
              left: 24,
              right: 24,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                ),
                onPressed: () async {
                  final uri = Uri.parse(
                    "https://www.facebook.com",
                  );

                  await launchUrl(
                    uri,
                    mode:
                        LaunchMode.externalApplication,
                  );
                },
                child: const Text(
                  "Learn More",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (videoList.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text("No videos found"),
        ),
      );
    }

    final totalItems =
        videoList.length + (videoList.length ~/ 4);

    return Scaffold(
      backgroundColor: Colors.white,

      /// ✅ FIXED HEADER
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: const CommonHeader(),
      ),

      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        itemCount: totalItems,

        onPageChanged: (index) async {
          if (isAdIndex(index)) return;

          final realIndex =
              getRealVideoIndex(index);

          currentIndex = realIndex;

          /// ✅ SAVE LAST WATCHED VIDEO
          final prefs =
              await SharedPreferences.getInstance();

          prefs.setString(
            "last_explore_video",
            videoList[realIndex],
          );

          setState(() {});
        },

        itemBuilder: (context, index) {
          /// 🔥 SHOW AD EVERY 4 VIDEOS
          if (isAdIndex(index)) {
            return buildMetaAd();
          }

          final realIndex =
              getRealVideoIndex(index);

          return ExploreVideoItem(
            videoUrl: videoList[realIndex],
            isActive:
                realIndex == currentIndex,
          );
        },
      ),
    );
  }
}

class ExploreVideoItem extends StatefulWidget {
  final String videoUrl;
  final bool isActive;

  const ExploreVideoItem({
    super.key,
    required this.videoUrl,
    required this.isActive,
  });

  @override
  State<ExploreVideoItem> createState() =>
      _ExploreVideoItemState();
}

class _ExploreVideoItemState
    extends State<ExploreVideoItem> {
  late VideoPlayerController _controller;

  bool isLoading = true;
  bool hasError = false;
  bool isPlaying = true;

  @override
  void initState() {
    super.initState();

    _controller =
        VideoPlayerController.network(widget.videoUrl)
          ..initialize().then((_) {
            if (!mounted) return;

            setState(() {
              isLoading = false;
            });

            if (widget.isActive) {
              _controller.play();
            }

            _controller.setLooping(true);
          }).catchError((error) {
            setState(() {
              hasError = true;
              isLoading = false;
            });
          });
  }

  @override
  void didUpdateWidget(
      covariant ExploreVideoItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive) {
      _controller.play();
      isPlaying = true;
    } else {
      _controller.pause();
    }
  }

  void togglePlay() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        isPlaying = false;
      } else {
        _controller.play();
        isPlaying = true;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: togglePlay,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16),
          height:
              MediaQuery.of(context).size.height * 0.72,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              hasError
                  ? const Center(
                      child: Text(
                        "Video failed to load",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                  : _controller.value.isInitialized
                      ? SizedBox.expand(
                          child:
                              VideoPlayer(_controller),
                        )
                      : Container(
                          color: Colors.black,
                        ),

              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),

              /// ▶️ PLAY ICON
              if (!_controller.value.isPlaying)
                const Center(
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
