import 'dart:convert';

import 'package:shorten_app/src/core/network_manager/network_manager.dart';
import 'package:shorten_app/src/core/shorten_manager/shorten_manager.dart';

class ShortenManagerBitly extends ShortenManager {
  final NetworkManager networkManager;

  ShortenManagerBitly(this.networkManager);

  @override
  Future<Map<String, dynamic>> shorten(String url, {Map<String, String>? headers, body}) async {
    try {
      final response = await networkManager.post(url, headers: headers, body: body);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Erro ao encurtar URL');
      }

      final data = jsonDecode(response.body);
      return data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<T> updateLink<T>(String url, {Map<String, String>? headers, body}) {
    throw UnimplementedError('updateLink method is not implemented');
  }
}
