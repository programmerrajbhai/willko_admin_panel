import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/api_client.dart';
import '../../core/values/api_constants.dart';

class SettingsController extends GetxController with GetSingleTickerProviderStateMixin {
  final ApiClient _apiClient = Get.find<ApiClient>();
  late TabController tabController;

  // General Settings Variables
  final titleCtrl = TextEditingController();
  final currencyCtrl = TextEditingController();
  final vatCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  // Password Variables
  final newPassCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();

  var isLoading = false.obs;

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    fetchSettings();
    super.onInit();
  }

  // ১. সেটিংস লোড করা
  void fetchSettings() async {
    isLoading.value = true;
    try {
      // General Settings
      final res = await _apiClient.getData(ApiConstants.settingsView);
      if (res.statusCode == 200 && res.body['status'] == 'success') {
        var data = res.body['data'];
        titleCtrl.text = data['site_title'] ?? '';
        currencyCtrl.text = data['currency'] ?? '';
        vatCtrl.text = data['vat']?.toString() ?? '0';
        phoneCtrl.text = data['support_phone'] ?? '';
        emailCtrl.text = data['support_email'] ?? '';
      }
    } catch (e) {
      print("Error fetching settings: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ২. সেটিংস আপডেট করা
  void updateSettings() async {
    isLoading.value = true;
    try {
      final res = await _apiClient.postData(ApiConstants.settingsUpdate, {
        "site_title": titleCtrl.text,
        "currency": currencyCtrl.text,
        "vat": vatCtrl.text,
        "support_phone": phoneCtrl.text,
        "support_email": emailCtrl.text,
      });

      if (res.statusCode == 200 && res.body['status'] == 'success') {
        Get.snackbar("Success", "Settings updated successfully!",
            backgroundColor: Colors.green.withOpacity(0.2));
      } else {
        Get.snackbar("Error", "Failed to update settings");
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ৩. পাসওয়ার্ড পরিবর্তন করা
  void changePassword() async {
    if (newPassCtrl.text.isEmpty || newPassCtrl.text != confirmPassCtrl.text) {
      Get.snackbar("Error", "Passwords do not match or empty", backgroundColor: Colors.red.withOpacity(0.2));
      return;
    }

    isLoading.value = true;
    try {
      final res = await _apiClient.postData(ApiConstants.updatePassword, {
        "new_password": newPassCtrl.text
      });

      if (res.statusCode == 200 && res.body['status'] == 'success') {
        Get.snackbar("Success", "Password changed successfully!");
        newPassCtrl.clear();
        confirmPassCtrl.clear();
      } else {
        Get.snackbar("Error", res.body['message'] ?? "Failed");
      }
    } finally {
      isLoading.value = false;
    }
  }
}