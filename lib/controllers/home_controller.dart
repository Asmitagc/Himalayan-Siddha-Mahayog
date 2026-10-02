import 'package:flutter/foundation.dart';

import '../models/banner_model.dart';
import '../models/user_model.dart';
import '../services/banner_service.dart';

class HomeController extends ChangeNotifier {
  final BannerService _bannerService = BannerService();

  UserModel _user = UserModel(
    id: 'user_001',
    name: 'Asmita GC',
    profileImageUrl: null,
    unreadNotifications: 3,
  );

  UserModel get user => _user;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  List<BannerModel> banners = [];

  bool isLoading = false;

  String? errorMessage;

  int currentPage = 0;

  Future<void> loadBanners() async {
    if (isLoading) {
      return;
    }

    isLoading = true;
    errorMessage = null;

    notifyListeners();

    try {
      final loadedBanners = await _bannerService.getBanners();

      banners = loadedBanners;

      // Reset page after loading.
      if (banners.isEmpty) {
        currentPage = 0;
      } else if (currentPage >= banners.length) {
        currentPage = 0;
      }

      debugPrint('Loaded ${banners.length} banners.');
    } catch (e) {
      banners = [];
      currentPage = 0;

      errorMessage = e.toString();

      debugPrint('Banner loading error: $e');
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  Future<void> retry() async {
    await loadBanners();
  }

  void changePage(int index) {
    if (index < 0 || index >= banners.length) {
      return;
    }

    currentPage = index;

    notifyListeners();
  }
}
