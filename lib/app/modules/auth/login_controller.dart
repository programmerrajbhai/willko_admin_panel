import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/api_client.dart';
import '../../data/storage/storage_service.dart';
import '../../core/values/api_constants.dart';
import '../home/home_view.dart';

class LoginController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Error", "Email and Password required",
          backgroundColor: Colors.red.withOpacity(0.2));
      return;
    }

    isLoading.value = true;

    try {
      final response = await _apiClient.postData(ApiConstants.login, {
        "email": emailController.text.trim(),
        "password": passwordController.text
      });

      if (response.statusCode == 200 && response.body['status'] == 'success') {
        var data = response.body['data'];

        await StorageService.saveToken(data['token']);
        await StorageService.saveUser(data);

        // === ডাইরেক্ট নেভিগেশন ===
        // Get.offAll() ব্যবহার করছি যাতে ব্যাক বাটনে চাপলে আর লগিন পেজে না আসে
        Get.offAll(() => const HomeView());

        Get.snackbar("Success", "Welcome Back!");
      } else {
        Get.snackbar("Login Failed", response.body['message'] ?? "Unknown Error",
            backgroundColor: Colors.red.withOpacity(0.2));
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }
}