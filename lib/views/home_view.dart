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

    pageController = PageController(viewportFraction: 0.88);

    controller.addListener(_onControllerChanged);
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
            HomeHeader(user: controller.user),

            const SizedBox(height: 20),

            SizedBox(
              height: 320,

              child: PageView.builder(
                controller: pageController,

                itemCount: controller.courses.length,

                onPageChanged: (index) {
                  controller.changePage(index);
                },

                itemBuilder: (context, index) {
                  final course = controller.courses[index];

                  return CourseCard(
                    course: course,

                    isActive: controller.currentPage == index,

                    onExplore: () {
                      controller.exploreCourse(course);
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            PageIndicator(
              itemCount: controller.courses.length,

              currentIndex: controller.currentPage,
            ),
          ],
        ),
      ),
    );
  }
}
