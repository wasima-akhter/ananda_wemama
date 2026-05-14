import 'package:http/http.dart' as http;

abstract class BaseApiService {
  Future<dynamic> getFromApI(String url, String? reqName, {Map<String, String>? headers});

  Future<Map?> postToApI(String url, String? reqName, var data, {Map<String, String>? headers});

  Future<Map?> putToApI(String url, String? reqName, var data, {Map<String, String>? headers});

  Future<Map?> deleteToApI(String url, String? reqName, var data, {Map<String, String>? headers});

  Future<Map?> postToApIwithFiles(String? reqName, http.MultipartRequest request);

  Future<Map?> uploadFile(String? reqName, http.MultipartRequest request);
}
