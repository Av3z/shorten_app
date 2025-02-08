import 'dart:convert';

import 'package:shorten_app/src/core/network_manager/network_manager.dart';
import 'package:shorten_app/src/core/shorten_manager/shorten_manager.dart';

class ShortenManagerBitly extends ShortenManager {
  final NetworkManager networkManager;

  ShortenManagerBitly(this.networkManager);

  @override
  Future<String> shorten(String url, {Map<String, String>? headers, body}) async {
    final response = await networkManager.post(url, headers: headers, body: body);

    if (response.statusCode != 200) {
      throw Exception('Erro ao encurtar URL');
    }
    final data = jsonDecode(response.body);
    return data['link'];
  }
}
