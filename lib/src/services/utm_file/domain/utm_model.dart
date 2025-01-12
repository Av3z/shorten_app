class UtmModel {
  final List<String> medium;
  final List<String> source;
  final List<String> campaign;

  UtmModel({
    required this.medium,
    required this.source,
    required this.campaign,
  });

  UtmModel copyWith({
    List<String>? medium,
    List<String>? source,
    List<String>? campaign,
  }) {
    return UtmModel(
      medium: medium ?? this.medium,
      source: source ?? this.source,
      campaign: campaign ?? this.campaign,
    );
  }
}
