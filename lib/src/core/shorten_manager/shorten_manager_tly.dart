import 'dart:convert';

import 'package:shorten_app/src/core/network_manager/network_manager.dart';
import 'package:shorten_app/src/core/shorten_manager/shorten_manager.dart';

class ShortenManagerTly extends ShortenManager {
  final NetworkManager networkManager;

  ShortenManagerTly(this.networkManager);
  @override
  Future<String> shorten(String url, {Map<String, String>? headers, body}) async {
    try {
      final response = await networkManager.post(url, headers: headers, body: body);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Erro ao encurtar URL');
      }

      final data = jsonDecode(response.body);

      return data['short_url'];
    } catch (e) {
      rethrow;
    }
  }
}
