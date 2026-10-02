import 'package:flutter/material.dart';

import '../controllers/home_controller.dart';
import '../models/banner_model.dart';
import '../widgets/course_card.dart';
import '../widgets/home_header.dart';
import '../widgets/page_indicator.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeController controller;
  late final PageController pageController;

  @override
  void initState() {
    super.initState();

    controller = HomeController();

    pageController = PageController(
      viewportFraction: 0.88,
    );

    controller.addListener(_onControllerChanged);

    controller.loadBanners();
  }


  void _onControllerChanged() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }


  @override
  void dispose() {
    controller.removeListener(_onControllerChanged);

    controller.dispose();

    pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F2),

      body: SafeArea(
        child: Column(
          children: [
            HomeHeader(
              user: controller.user,
            ),

            const SizedBox(height: 20),

            _buildBannerSlider(),

            const SizedBox(height: 25),

            if (!controller.isLoading &&
                controller.errorMessage == null &&
                controller.banners.isNotEmpty)
              PageIndicator(
                itemCount: controller.banners.length,
                currentIndex: controller.currentPage,
              ),
          ],
        ),
      ),
    );
  }


  Widget _buildBannerSlider() {


    if (controller.isLoading) {
      return const SizedBox(
        height: 320,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }


    if (controller.errorMessage != null) {
      return _buildErrorState();
    }

    if (controller.banners.isEmpty) {
      return _buildEmptyState();
    }


    return SizedBox(
      height: 320,

      child: PageView.builder(
        controller: pageController,

        // Manual swipe only.
        itemCount: controller.banners.length,

        onPageChanged: (index) {
          controller.changePage(index);
        },

        itemBuilder: (context, index) {
          final BannerModel banner =
              controller.banners[index];

          return CourseCard(
            banner: banner,

            isActive:
                controller.currentPage == index,

            onExplore: () {
              _handleExplore(banner);
            },
          );
        },
      ),
    );
  }

  Widget _buildErrorState() {
    return SizedBox(
      height: 320,

      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              const Icon(
                Icons.cloud_off,
                size: 50,
                color: Colors.grey,
              ),

              const SizedBox(height: 15),

              const Text(
                'Unable to load banners',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                _cleanErrorMessage(
                  controller.errorMessage,
                ),
                textAlign: TextAlign.center,

                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: controller.retry,

                icon: const Icon(
                  Icons.refresh,
                ),

                label: const Text(
                  'Retry',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildEmptyState() {
    return const SizedBox(
      height: 320,

      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(
              Icons.image_not_supported_outlined,
              size: 50,
              color: Colors.grey,
            ),

            SizedBox(height: 12),

            Text(
              'No banners available',
              style: TextStyle(
                fontSize: 17,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _cleanErrorMessage(String? error) {
    if (error == null || error.isEmpty) {
      return 'Something went wrong. Please try again.';
    }

    return error.replaceFirst(
      'Exception: ',
      '',
    );
  }


  void _handleExplore(BannerModel banner) {
    final navigation = banner.buttonNavigation;

    if (navigation == null || navigation.isEmpty) {
      return;
    }

    debugPrint(
      'Explore clicked: $navigation',
    );

  }
}