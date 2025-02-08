import 'package:shorten_app/src/core/network_manager/network_manager.dart';
import 'package:http/http.dart' as http;

class NetworkManagerHttp extends NetworkManager {
  @override
  Future<T> delete<T>(String url, {Map<String, String>? headers}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<T> get<T>(String url, {Map<String, String>? headers}) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<T> post<T>(String url, {Map<String, String>? headers, body}) async {
    final response = await http.post(Uri.parse(url), headers: headers, body: body);
    return response as T;
  }

  @override
  Future<T> put<T>(String url, {Map<String, String>? headers, body}) {
    // TODO: implement put
    throw UnimplementedError();
  }
}
