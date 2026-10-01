import 'package:flutter/foundation.dart';

import '../models/banner_model.dart';
import '../models/user_model.dart';
import '../services/banner_service.dart';

class HomeController extends ChangeNotifier {
  final BannerService _bannerService = BannerService();

  // ---------------------------------------------------------------------------
  // USER
  // ---------------------------------------------------------------------------

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

  // ---------------------------------------------------------------------------
  // BANNERS
  // ---------------------------------------------------------------------------

  List<BannerModel> banners = [];

  bool isLoading = false;
  String? errorMessage;

  // ---------------------------------------------------------------------------
  // PAGE
  // ---------------------------------------------------------------------------

  int currentPage = 0;

  // ---------------------------------------------------------------------------
  // LOAD BANNERS FROM API
  // ---------------------------------------------------------------------------

  Future<void> loadBanners() async {
    isLoading = true;
    errorMessage = null;

    notifyListeners();

    try {
      banners = await _bannerService.getBanners();

      // Make sure the page is valid after loading.
      if (banners.isEmpty) {
        currentPage = 0;
      } else if (currentPage >= banners.length) {
        currentPage = 0;
      }

      debugPrint(
        'Loaded ${banners.length} banners',
      );
    } catch (e) {
      errorMessage = e.toString();

      debugPrint(
        'Banner loading error: $e',
      );
    }

    isLoading = false;

    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // CHANGE SLIDER PAGE
  // ---------------------------------------------------------------------------

  void changePage(int index) {
    if (index < 0 || index >= banners.length) {
      return;
    }

    currentPage = index;

    notifyListeners();
  }
}