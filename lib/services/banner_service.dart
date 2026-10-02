import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/banner_model.dart';

class BannerService {
  static const String apiUrl =
      'https://phplaravel-1214193-6702770.cloudwaysapps.com/api/v1/settings/config';

  static const String username = 'nwzttzrqtp';
  static const String password = 'mX2MukRfpC';

  Future<List<BannerModel>> getBanners() async {
    try {
      final credentials = base64Encode(utf8.encode('$username:$password'));

      final response = await http
          .get(
            Uri.parse(apiUrl),
            headers: {
              'Authorization': 'Basic $credentials',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw Exception('Banner API failed: ${response.statusCode}');
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        throw Exception('Invalid API response format.');
      }

      final bannersJson = decoded['banners'];

      if (bannersJson == null) {
        throw Exception('No "banners" field found in API response.');
      }

      if (bannersJson is! List) {
        throw Exception('"banners" is not a list.');
      }


      print('========================================');
      print('TOTAL BANNERS FROM API: ${bannersJson.length}');
      print('========================================');

      for (final banner in bannersJson) {
        print('-----------------------------');
        print('ID: ${banner['id']}');
        print('TITLE: ${banner['title']}');
        print('SLIDER TYPE: ${banner['slider_type']}');
        print('SLIDER FILE: ${banner['slider_file']}');
        print('VIDEO FILE: ${banner['video_file']}');
        print('TARGET: ${banner['banner_target']}');
        print('STATUS: ${banner['status']}');
        print('DISPLAY ORDER: ${banner['display_order']}');
      }

      print('========================================');

      final banners = bannersJson
          .whereType<Map<String, dynamic>>()
          .map((json) => BannerModel.fromJson(json))
          .where((banner) => banner.target == 'mobile' && banner.status == 1)
          .toList();

      banners.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

      return banners;
    } on TimeoutException {
      throw Exception('Banner API request timed out.');
    } on http.ClientException catch (e) {
      throw Exception('Unable to connect to the server: $e');
    }
  }
}
