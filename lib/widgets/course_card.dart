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

  bool _videoError = false;

  @override
  void initState() {
    super.initState();

    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    if (widget.banner.sliderType != 'video') {
      return;
    }

    final videoUrl = widget.banner.videoFile;

    if (videoUrl == null || videoUrl.isEmpty) {
      return;
    }

    try {
      final controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));

      _videoController = controller;

      await controller.initialize();

      if (!mounted) {
        controller.dispose();
        return;
      }

      await controller.setLooping(true);

      if (widget.isActive) {
        await controller.play();
      }

      setState(() {});
    } catch (e) {
      debugPrint('Video initialization error: $e');

      if (!mounted) {
        return;
      }

      setState(() {
        _videoError = true;
      });
    }
  }

  @override
  void didUpdateWidget(covariant CourseCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    final videoController = _videoController;

    if (videoController == null || !videoController.value.isInitialized) {
      return;
    }

    // Became active.
    if (widget.isActive && !oldWidget.isActive) {
      videoController.play();
    }

    // Became inactive.
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
    final type = widget.banner.sliderType.toLowerCase();

    if (type == 'video') {
      return _buildVideoCard();
    }

    return _buildImageCard();
  }

  Widget _buildImageCard() {
    final imageUrl = widget.banner.sliderFile;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),

      child: Stack(
        fit: StackFit.expand,

        children: [
          if (imageUrl != null && imageUrl.isNotEmpty)
            Image.network(
              imageUrl,

              fit: BoxFit.cover,

              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }

                return const Center(child: CircularProgressIndicator());
              },

              errorBuilder: (context, error, stackTrace) {
                return _buildImageError();
              },
            )
          else
            _buildImageError(),

          _buildGradient(),

          _buildBannerContent(),
        ],
      ),
    );
  }

  Widget _buildVideoCard() {
    final videoController = _videoController;

    final videoUrl = widget.banner.videoFile;

    if (videoUrl == null || videoUrl.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),

        child: Stack(
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

            _buildGradient(),

            _buildBannerContent(),
          ],
        ),
      );
    }

    if (_videoError) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),

        child: Stack(
          fit: StackFit.expand,

          children: [
            Container(
              color: Colors.black,

              child: const Center(
                child: Icon(Icons.error_outline, color: Colors.white, size: 55),
              ),
            ),

            _buildGradient(),

            _buildBannerContent(),
          ],
        ),
      );
    }

    if (videoController == null || !videoController.value.isInitialized) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),

        child: Container(
          color: Colors.black,

          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),

      child: Stack(
        fit: StackFit.expand,

        children: [
          FittedBox(
            fit: BoxFit.cover,

            child: SizedBox(
              width: videoController.value.size.width,

              height: videoController.value.size.height,

              child: VideoPlayer(videoController),
            ),
          ),

          _buildGradient(),

          _buildBannerContent(),
        ],
      ),
    );
  }

  Widget _buildGradient() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,

          colors: [Colors.transparent, Colors.black.withOpacity(0.80)],
        ),
      ),
    );
  }

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
          if (title.isNotEmpty)
            Text(
              title,

              maxLines: 2,

              overflow: TextOverflow.ellipsis,

              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

          if (description != null && description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),

              child: Text(
                description,

                maxLines: 3,

                overflow: TextOverflow.ellipsis,

                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),

          if (buttonLabel != null && buttonLabel.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16),

              child: ElevatedButton(
                onPressed: widget.onExplore,

                child: Text(buttonLabel),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageError() {
    return Container(
      color: Colors.grey.shade200,

      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 55,
          color: Colors.grey,
        ),
      ),
    );
  }
}
