import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/banner_model.dart';

class BannerService {
  static const String apiUrl =
      'https://phplaravel-1214193-6702770.cloudwaysapps.com/api/v1/settings/config';

  // Use your Basic Authentication credentials here.
  static const String username = 'nwzttzrqtp';
  static const String password = 'mX2MukRfpC';

  Future<List<BannerModel>> getBanners() async {
    final credentials = base64Encode(utf8.encode('$username:$password'));

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Basic $credentials',
        'Accept': 'application/json',
      },
    );

    print('========================================');
    print('BANNER API STATUS: ${response.statusCode}');
    print('========================================');

    if (response.statusCode != 200) {
      print('BANNER API BODY: ${response.body}');

      throw Exception('Banner API failed: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid API response format.');
    }

    // Your API has "banners" directly at the root.
    final bannersJson = decoded['banners'];

    if (bannersJson == null) {
      throw Exception('No "banners" field found in API response.');
    }

    if (bannersJson is! List) {
      throw Exception('"banners" is not a list.');
    }

    final banners = bannersJson
        .whereType<Map<String, dynamic>>()
        .map((json) => BannerModel.fromJson(json))
        .where((banner) => banner.target == 'mobile')
        .toList();

    banners.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    print('TOTAL BANNERS: ${banners.length}');

    return banners;
  }
}
