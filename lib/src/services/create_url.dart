class CreateUrl {
  String url;
  String source;
  String campaign;
  String medium;

  CreateUrl({required this.url, this.source = "", this.campaign = "", this.medium = ""});

  String modifyUrl() {
    Uri uri = Uri.parse(url);
    Map<String, String> queryParams = Map.from(uri.queryParameters);

    String normalizeKey(String k) => k.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

    void ensureCanonical(String canonical) {
      final target = canonical.replaceAll('_', '');
      final hasCanonical = queryParams.keys.any((k) => k.toLowerCase() == canonical);
      if (hasCanonical) return;

      final altKey = queryParams.keys.firstWhere(
        (k) => normalizeKey(k) == target,
        orElse: () => '',
      );
      if (altKey.isNotEmpty) {
        queryParams[canonical] = queryParams[altKey]!;
        queryParams.remove(altKey);
      }
    }

    ensureCanonical('utm_source');
    ensureCanonical('utm_campaign');
    ensureCanonical('utm_medium');

    // Modificar utm_source, se fornecido
    if (source.isNotEmpty && source != "default") {
      queryParams['utm_source'] = source;
    }

    // Modificar utm_campaign
    if (campaign.isNotEmpty) {
      queryParams['utm_campaign'] = campaign;
    }

    // Modificar utm_medium, se fornecido
    if (medium.isNotEmpty) {
      queryParams['utm_medium'] = medium;
    }

    Uri modifiedUri = uri.replace(queryParameters: queryParams);
    return modifiedUri.toString();
  }
}
