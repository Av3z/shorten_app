abstract class NetworkManager {
  Future<T> get<T>(String url, {Map<String, String>? headers});
  Future<T> post<T>(String url, {Map<String, String>? headers, dynamic body});
  Future<T> put<T>(String url, {Map<String, String>? headers, dynamic body});
  Future<T> delete<T>(String url, {Map<String, String>? headers});
}
