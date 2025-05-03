import 'dart:convert';

import 'package:shorten_app/src/core/network_manager/network_manager.dart';
import 'package:shorten_app/src/core/shorten_manager/shorten_manager.dart';

class ShortenManagerShortIo extends ShortenManager {
  final NetworkManager networkManager;

  ShortenManagerShortIo(this.networkManager);

  @override
  Future<String> shorten(String url, {Map<String, String>? headers, body}) async {
    try {
      final response = await networkManager.post(url, headers: headers, body: body);

      print('headers: $headers');
      print('Body: $body');

      print('Response: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        print('Status Code: ${response.statusCode}');
        throw Exception('Erro ao encurtar URL');
      }

      final data = jsonDecode(response.body);
      return data['shortURL'];
    } catch (e) {
      rethrow;
    }
  }
}
