import 'package:dio/dio.dart';

abstract class HttpClient {
  Future<dynamic> post(String urlEnpoint, Map<String, dynamic> body);
  Future<dynamic> get(String urlEnpoint);
}

class DioClient implements HttpClient {
  final Dio dio;
  DioClient({required this.dio});
  @override
  Future<dynamic> post(String urlEnpoint, Map<String, dynamic> body) async {
    final dynamic response = await dio.post(urlEnpoint, data: body);
    return response.data;
  }

  @override
  Future get(String urlEnpoint) async {
    final dynamic response = await dio.get(urlEnpoint);
    return response.data;
  }
}
