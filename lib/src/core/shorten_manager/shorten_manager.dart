abstract class ShortenManager {
  Future<String> shorten(String url, {Map<String, String>? headers, body});
}
