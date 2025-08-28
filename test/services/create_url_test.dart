import 'package:flutter_test/flutter_test.dart';
import 'package:shorten_app/src/services/create_url.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('normalize utmsource (utmsource -> utm_source) and apply overrides', () {
    const original = 'https://example.com/path?utmsource=oldSource&utm-campaign=oldCamp&utm%20medium=oldMed';
    final modified = CreateUrl(
      url: original,
      source: 'wp_channels',
      campaign: 'pr2',
      medium: 'fmkt',
    ).modifyUrl();

    final uri = Uri.parse(modified);
    final params = uri.queryParameters;

    expect(params['utm_source'], 'wp_channels');
    expect(params['utm_campaign'], 'pr2');
    expect(params['utm_medium'], 'fmkt');
  });

  test('does not overwrite utm_source when source == "default"', () {
    const original = 'https://example.com/path?utm_source=originalSource&utm_campaign=camp';
    final modified = CreateUrl(
      url: original,
      source: 'default',
      campaign: '',
      medium: '',
    ).modifyUrl();

    final uri = Uri.parse(modified);
    final params = uri.queryParameters;

    expect(params['utm_source'], 'originalSource');
    expect(params['utm_campaign'], 'camp');
  });

  test('adds utm params when none exist', () {
    const original = 'https://example.com/path';
    final modified = CreateUrl(
      url: original,
      source: 's1',
      campaign: 'c1',
      medium: 'm1',
    ).modifyUrl();

    final uri = Uri.parse(modified);
    final params = uri.queryParameters;

    expect(params['utm_source'], 's1');
    expect(params['utm_campaign'], 'c1');
    expect(params['utm_medium'], 'm1');
  });

  test('fixes keys with spaces or dashes and preserves other params', () {
    const original = 'https://example.com/path?utm-source=old&utm%20medium=old2';
    final modified = CreateUrl(
      url: original,
      source: 'src',
      medium: 'mm',
    ).modifyUrl();

    final uri = Uri.parse(modified);
    final params = uri.queryParameters;

    expect(params['utm_source'], 'src');
    expect(params['utm_medium'], 'mm');
  });

  test('normalize various forms of utm_source and pick the canonical one', () {
    const original = 'https://example.com/path?utmsource=one&utm%20campaign=two&utm-medium=three';
    final modified = CreateUrl(
      url: original,
      source: 'teste_source',
      campaign: 'teste_campaign',
      medium: 'teste_medium',
    ).modifyUrl();

    final uri = Uri.parse(modified);
    final params = uri.queryParameters;

    expect(params.containsKey('utm_source'), isTrue);
    expect(params['utm_source'], 'teste_source');
    expect(params.containsKey('utm_campaign'), isTrue);
    expect(params['utm_campaign'], 'teste_campaign');
    expect(params.containsKey('utm_medium'), isTrue);
    expect(params['utm_medium'], 'teste_medium');

    expect(params.containsKey('utmsource'), isFalse);
    expect(params.containsKey('utm%20campaign'), isFalse);
    expect(params.containsKey('utm-medium'), isFalse);
  });

  test('preserves other params and normalizes utm_medium variations', () {
    const original = 'https://example.com/path?utm%20medium=oldMedium';
    final modified = CreateUrl(
      url: original,
      source: '',
      campaign: '',
      medium: 'newMedium',
    ).modifyUrl();

    final uri = Uri.parse(modified);
    final params = uri.queryParameters;

    expect(params['utm_medium'], 'newMedium');
  });

  test('adds utm params to plain URL and produces correct query string', () {
    const original = 'https://example.com/path';
    final modified = CreateUrl(
      url: original,
      source: 's1',
      campaign: 'c1',
      medium: 'm1',
    ).modifyUrl();

    final uri = Uri.parse(modified);

    // check values
    final params = uri.queryParameters;
    expect(params['utm_source'], 's1');
    expect(params['utm_campaign'], 'c1');
    expect(params['utm_medium'], 'm1');

    expect(uri.query, 'utm_source=s1&utm_campaign=c1&utm_medium=m1');
  });

  test('ensures utm order is source, campaign, medium', () {
    const original = 'https://example.com/path';
    final modified = CreateUrl(
      url: original,
      source: 'S',
      campaign: 'C',
      medium: 'M',
    ).modifyUrl();

    final uri = Uri.parse(modified);

    final params = uri.queryParameters;

    expect(params.keys.elementAt(0), 'utm_source');
    expect(params.keys.elementAt(1), 'utm_campaign');
    expect(params.keys.elementAt(2), 'utm_medium');
  });
}
