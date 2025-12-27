import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../../core/values/api_constants.dart';
import '../storage/storage_service.dart';

class ApiClient extends GetConnect {

  @override
  void onInit() {
    // Base URL সেটআপ
    httpClient.baseUrl = ApiConstants.baseUrl;

    // টাইমআউট সেটিং (৩০ সেকেন্ড)
    httpClient.timeout = const Duration(seconds: 30);

    // সব রিকোয়েস্টে অটোমেটিক টোকেন বসানো
    httpClient.addRequestModifier<dynamic>((request) {
      final token = StorageService.getToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      // JSON ফরম্যাট নিশ্চিত করা
      request.headers['Accept'] = 'application/json';

      if (kDebugMode) {
        print('➡️ [${request.method}] ${request.url}');
      }
      return request;
    });

    // রেস্পন্স লগ করা (Debug এর জন্য)
    httpClient.addResponseModifier((request, response) {
      if (kDebugMode) {
        print('⬅️ [${response.statusCode}] ${response.bodyString}');
      }
      return response;
    });

    super.onInit();
  }

  // সাধারণ GET Request
  Future<Response> getData(String uri, {Map<String, dynamic>? query}) async {
    try {
      return await get(uri, query: query);
    } catch (e) {
      return Response(statusCode: 500, statusText: e.toString());
    }
  }

  // সাধারণ POST Request
  Future<Response> postData(String uri, dynamic body) async {
    try {
      return await post(uri, body);
    } catch (e) {
      return Response(statusCode: 500, statusText: e.toString());
    }
  }
}