import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../models/banner_model.dart';

class CourseCard extends StatefulWidget {
  final BannerModel banner;
  final bool isActive;
  final VoidCallback? onExplore;

  const CourseCard({
    super.key,
    required this.banner,
    required this.isActive,
    this.onExplore,
  });

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();

    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    // Only initialize video banners.
    if (widget.banner.sliderType != 'video') {
      return;
    }

    final videoUrl = widget.banner.videoFile;

    // Your API currently has video_file = null
    // for the video banner.
    if (videoUrl == null || videoUrl.isEmpty) {
      return;
    }

    try {
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
      );

      _videoController = controller;

      await controller.initialize();

      if (!mounted) {
        controller.dispose();
        return;
      }

      controller.setLooping(true);

      // Video should play ONLY if this card is currently active.
      if (widget.isActive) {
        controller.play();
      }

      setState(() {});
    } catch (e) {
      debugPrint('Video initialization error: $e');
    }
  }

  @override
  void didUpdateWidget(covariant CourseCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    final videoController = _videoController;

    if (videoController == null ||
        !videoController.value.isInitialized) {
      return;
    }

    // Card became active.
    if (widget.isActive && !oldWidget.isActive) {
      videoController.play();
    }

    // Card became inactive.
    if (!widget.isActive && oldWidget.isActive) {
      videoController.pause();
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banner.sliderType == 'video') {
      return _buildVideoCard();
    }

    return _buildImageCard();
  }

  // ---------------------------------------------------------------------------
  // IMAGE BANNER
  // ---------------------------------------------------------------------------

  Widget _buildImageCard() {
    final imageUrl = widget.banner.sliderFile;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (imageUrl != null && imageUrl.isNotEmpty)
          Image.network(
            imageUrl,
            fit: BoxFit.cover,

            loadingBuilder: (
              context,
              child,
              loadingProgress,
            ) {
              if (loadingProgress == null) {
                return child;
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },

            errorBuilder: (
              context,
              error,
              stackTrace,
            ) {
              return const Center(
                child: Icon(
                  Icons.broken_image,
                  size: 50,
                ),
              );
            },
          )
        else
          const Center(
            child: Icon(
              Icons.image_not_supported,
              size: 50,
            ),
          ),

        // Dark overlay so text is easier to read.
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.75),
              ],
            ),
          ),
        ),

        _buildBannerContent(),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // VIDEO BANNER
  // ---------------------------------------------------------------------------

  Widget _buildVideoCard() {
    final videoController = _videoController;

    // API currently doesn't provide a video URL.
    if (widget.banner.videoFile == null ||
        widget.banner.videoFile!.isEmpty) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.black,
            child: const Center(
              child: Icon(
                Icons.video_library_outlined,
                color: Colors.white,
                size: 60,
              ),
            ),
          ),

          _buildBannerContent(),
        ],
      );
    }

    // Video is still loading.
    if (videoController == null ||
        !videoController.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // Video
        FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: videoController.value.size.width,
            height: videoController.value.size.height,
            child: VideoPlayer(videoController),
          ),
        ),

        // Dark overlay.
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.75),
              ],
            ),
          ),
        ),

        _buildBannerContent(),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // TEXT + BUTTON
  // ---------------------------------------------------------------------------

  Widget _buildBannerContent() {
    final title = widget.banner.title;
    final description = widget.banner.description;
    final buttonLabel = widget.banner.buttonLabel;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null && title.isNotEmpty)
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

          if (description != null && description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          if (buttonLabel != null && buttonLabel.isNotEmpty) ...[
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: widget.onExplore,
              child: Text(buttonLabel),
            ),
          ],
        ],
      ),
    );
  }
}