import 'package:flutter_test/flutter_test.dart';
import 'package:shorten_app/src/services/create_url.dart';

void main() {
  group('teste modified url', () {
    CreateUrl? createUrl;
    const url = 'https://example.com/page';

    setUp(() {
      createUrl = CreateUrl(
        url: url,
        source: 'teste_source',
        campaign: 'teste_campaign',
        medium: 'teste_medium',
      );
    });

    test('should create correctly url modified', () {
      final modifiedUrl = createUrl?.modifyUrl();
      expect(modifiedUrl, 'https://example.com/page?utm_source=teste_source&utm_campaign=teste_campaign&utm_medium=teste_medium');
    });

    test('should create correctly url modified with correctly the order (source, campaign, medium)', () {
      final modifiedUrl = createUrl?.modifyUrl();

      expect(modifiedUrl, 'https://example.com/page?utm_source=teste_source&utm_campaign=teste_campaign&utm_medium=teste_medium');

      final uri = Uri.parse(modifiedUrl!);
      final queryParams = uri.queryParameters;

      // validar se o primeiro query param é o utm_source
      expect(queryParams.keys.elementAt(0), 'utm_source');

      // validar se o segundo query param é o utm_campaign
      expect(queryParams.keys.elementAt(1), 'utm_campaign');

      // validar se o terceiro query param é o utm_medium
      expect(queryParams.keys.elementAt(2), 'utm_medium');
    });
  });
}
