class UtmModel {
  final List<String> medium;
  final List<String> source;
  final List<String> campaign;
  final String accessToken;
  final String baseUrl;

  UtmModel({
    required this.medium,
    required this.source,
    required this.campaign,
    required this.accessToken,
    this.baseUrl = '',
  });

  UtmModel copyWith({
    List<String>? medium,
    List<String>? source,
    List<String>? campaign,
    String? accessToken,
    String? baseUrl,
  }) {
    return UtmModel(
      medium: medium ?? this.medium,
      source: source ?? this.source,
      campaign: campaign ?? this.campaign,
      accessToken: accessToken ?? this.accessToken,
      baseUrl: baseUrl ?? this.baseUrl,
    );
  }
}
