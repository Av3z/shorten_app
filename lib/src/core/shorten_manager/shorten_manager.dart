abstract class ShortenManager {
  Future<Map<String, dynamic>> shorten(String url, {Map<String, String>? headers, body});
  Future<T> updateLink<T>(String url, {Map<String, String>? headers, body});
}
