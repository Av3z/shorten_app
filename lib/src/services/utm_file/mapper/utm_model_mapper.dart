import 'package:shorten_app/src/services/utm_file/domain/utm_model.dart';

abstract class UtmModelMapper {
  static UtmModel fromJson(Map<String, dynamic> map) {
    return UtmModel(
      medium: List<String>.from(map['medium']),
      source: List<String>.from(map['source']),
      campaign: List<String>.from(map['campaign']),
      domains: List<String>.from(map['domains'] ?? []),
      accessToken: map['access_token'],
      baseUrl: map['base_url'],
    );
  }

  static Map<String, dynamic> toJson(UtmModel model) {
    return {
      'medium': model.medium,
      'source': model.source,
      'campaign': model.campaign,
      'access_token': model.accessToken,
      'base_url': model.baseUrl,
      'domains': model.domains,
    };
  }
}
