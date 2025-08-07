import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shorten_app/src/services/utm_file/domain/utm_model.dart';
import 'package:shorten_app/src/services/utm_file/mapper/utm_model_mapper.dart';

class UTMFileService {
  final String filePath = 'assets/config.json';

  Future<UtmModel> _readUTMJson() async {
    final String content = await rootBundle.loadString(filePath);
    final decoded = json.decode(content) as Map<String, dynamic>;
    return UtmModelMapper.fromJson(decoded);
  }

  Future<List<String>> readUTMs(String type) async {
    final utmData = await _readUTMJson();
    switch (type) {
      case 'medium':
        return utmData.medium;
      case 'source':
        return utmData.source;
      case 'campaign':
        return utmData.campaign;
      case 'access_token':
        return [utmData.accessToken];
      case 'base_url':
        return [utmData.baseUrl];
      case 'domains':
        return utmData.domains;
      default:
        throw Exception('Tipo de UTM inválido: $type');
    }
  }
}
