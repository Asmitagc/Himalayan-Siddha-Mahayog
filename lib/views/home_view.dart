import 'package:flutter/material.dart';

import '../controllers/home_controller.dart';
import '../widgets/home_header.dart';
import '../widgets/course_card.dart';
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

    // Same viewport fraction as your original project.
    pageController = PageController(viewportFraction: 0.88);

    controller.addListener(_onControllerChanged);

    // Load banners from Laravel API.
    controller.loadBanners();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
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
            // Existing user header.
            HomeHeader(user: controller.user),

            const SizedBox(height: 20),

            _buildBannerSlider(),

            const SizedBox(height: 25),

            // Existing PageIndicator API.
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
    // -------------------------------------------------------------------------
    // LOADING
    // -------------------------------------------------------------------------

    if (controller.isLoading) {
      return const SizedBox(
        height: 320,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // -------------------------------------------------------------------------
    // ERROR
    // -------------------------------------------------------------------------

    if (controller.errorMessage != null) {
      return SizedBox(
        height: 320,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(controller.errorMessage!, textAlign: TextAlign.center),
          ),
        ),
      );
    }

    // -------------------------------------------------------------------------
    // NO BANNERS
    // -------------------------------------------------------------------------

    if (controller.banners.isEmpty) {
      return const SizedBox(
        height: 320,
        child: Center(child: Text('No banners available')),
      );
    }

    // -------------------------------------------------------------------------
    // BANNER SLIDER
    // -------------------------------------------------------------------------

    return SizedBox(
      height: 320,
      child: PageView.builder(
        controller: pageController,

        // Number of API banners.
        itemCount: controller.banners.length,

        // Manual swipe only.
        onPageChanged: (index) {
          controller.changePage(index);
        },

        itemBuilder: (context, index) {
          final banner = controller.banners[index];

          return CourseCard(
            banner: banner,

            // Only the banner currently in front is active.
            isActive: controller.currentPage == index,

            onExplore: () {
              _handleExplore(banner);
            },
          );
        },
      ),
    );
  }

  void _handleExplore(dynamic banner) {
    // We can connect button_navigation here later.
    //
    // For example:
    // banner.buttonNavigation == 'login'
  }
}
