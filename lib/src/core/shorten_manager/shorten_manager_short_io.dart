import 'dart:convert';

import 'package:shorten_app/src/core/network_manager/network_manager.dart';
import 'package:shorten_app/src/core/shorten_manager/shorten_manager.dart';

class ShortenManagerShortIo extends ShortenManager {
  final NetworkManager networkManager;

  ShortenManagerShortIo(this.networkManager);

  @override
  Future<Map<String, dynamic>> shorten(String url, {Map<String, String>? headers, body}) async {
    try {
      final response = await networkManager.post(url, headers: headers, body: body);

      print('headers: $headers');
      print('Body: $body');

      print('Response: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Erro ao encurtar URL');
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<T> updateLink<T>(String url, {Map<String, String>? headers, body}) async {
    try {
      final response = await networkManager.post(url, headers: headers, body: body);
      return jsonDecode(response.body) as T;
    } catch (e) {
      throw Exception('Erro ao atualizar link: $e');
    }
  }
}
