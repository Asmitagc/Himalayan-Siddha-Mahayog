import '../models/course_model.dart';
import '../models/user_model.dart';
import 'package:flutter/foundation.dart';

class HomeController extends ChangeNotifier {
  UserModel _user = UserModel(
    id: 'user_001',
    name: 'Asmita GC',
    profileImageUrl: null,
    unreadNotifications: 3,
  );

  UserModel get user => _user;

  final List<CourseModel> _courses = [
    CourseModel(
      id: 'course_01',
      title: 'New course: Pranayam',
      subtitle: 'Breath practice for begineers',
      mediaPath: 'assets/images/pranayam.png',
    ),

    CourseModel(
      id: 'video_01',
      title: 'Himalayan Siddha Mahayog',
      subtitle: 'Watch our introduction',
      mediaPath: 'assets/videos/pkras.mp4',
      isVideo: true,
    ),

    CourseModel(
      id: 'course_02',
      title: 'Meditation',
      subtitle: 'Discover your inner silence',
      mediaPath: 'assets/images/pranayam.png',
    ),
  ];
  List<CourseModel> get courses => List.unmodifiable(_courses);

  int _currentPage = 0;
  int get currentPage => _currentPage;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  void changePage(int index) {
    if (index < 0 || index >= _courses.length) {
      return;
    }
    _currentPage = index;

    notifyListeners();
  }

  void exploreCourse(CourseModel course) {
    debugPrint('Explore course: ${course.title}}');
  }
}
