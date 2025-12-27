import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/api_client.dart';
import '../../core/values/api_constants.dart';

class ProvidersController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();

  var isLoading = true.obs;
  var providersList = <dynamic>[].obs;

  @override
  void onInit() {
    fetchProviders();
    super.onInit();
  }

  void fetchProviders() async {
    isLoading.value = true;
    try {
      final response = await _apiClient.getData(ApiConstants.providersList);
      if (response.statusCode == 200 && response.body['status'] == 'success') {
        providersList.value = response.body['data'];
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void deleteProvider(int id) async {
    try {
      final response = await _apiClient.postData(ApiConstants.providerDelete, {"id": id});
      if (response.statusCode == 200 && response.body['status'] == 'success') {
        fetchProviders();
        Get.snackbar("Success", "Provider deleted successfully");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to delete");
    }
  }

  // নতুন প্রোভাইডার যোগ করার মেথড (AddProviderView থেকে কল হবে)
  Future<bool> addProvider(Map<String, String> data) async {
    try {
      // এখানে মাল্টিপার্ট ফাইল আপলোড লজিক বসাতে হবে যদি ছবি থাকে
      // সিম্পল টেক্সট ডাটার জন্য postData যথেষ্ট
      final response = await _apiClient.postData(ApiConstants.providerAdd, data);

      if (response.statusCode == 200 && response.body['status'] == 'success') {
        fetchProviders();
        return true;
      } else {
        Get.snackbar("Error", response.body['message'] ?? "Failed");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Connection error");
      return false;
    }
  }
}