import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../data/services/api_client.dart';
import '../../core/values/api_constants.dart';
import '../../data/storage/storage_service.dart';

class ProvidersController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();

  // লিস্ট ভেরিয়েবল
  var isLoading = true.obs;
  var providersList = <dynamic>[].obs;

  // ডিটেইলস ভেরিয়েবল
  var isHistoryLoading = false.obs;
  var providerHistory = <dynamic>[].obs;
  var totalIncome = 0.0.obs;
  var currentDue = 0.0.obs; // [NEW] বকেয়া টাকার ভেরিয়েবল

  // ইমেজ পিকার
  var selectedImage = Rxn<File>();
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    fetchProviders();
    super.onInit();
  }

  // ১. সব প্রোভাইডার লোড করা
  Future<void> fetchProviders() async {
    isLoading.value = true;
    try {
      final response = await _apiClient.getData(ApiConstants.providersList);
      if (response.statusCode == 200 && response.body['status'] == 'success') {
        providersList.value = response.body['data'];
      }
    } catch (e) {
      print("Error fetching providers: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ২. ছবি সিলেক্ট করা
  void pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  // ৩. নতুন প্রোভাইডার সেভ করা (ইমেজসহ)
  Future<void> saveProvider({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "All fields are required", backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

    try {
      var uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.providerAdd);
      var request = http.MultipartRequest('POST', uri);

      String token = StorageService.getToken() ?? '';
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['phone'] = phone;
      request.fields['password'] = password;

      if (selectedImage.value != null) {
        var pic = await http.MultipartFile.fromPath("image", selectedImage.value!.path);
        request.files.add(pic);
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      Get.back(); // লোডিং বন্ধ

      if (response.statusCode == 200) {
        fetchProviders();
        Get.back(); // পেজ বন্ধ
        Get.snackbar("Success", "Provider added successfully", backgroundColor: Colors.green, colorText: Colors.white);
        selectedImage.value = null;
      } else {
        Get.snackbar("Error", "Failed to add provider");
      }
    } catch (e) {
      Get.back();
      Get.snackbar("Error", "Connection Error: $e");
    }
  }

  // ৪. ডিটেইলস এবং হিস্ট্রি আনা (সাথে Due Amount)
  Future<void> fetchProviderDetails(int id) async {
    isHistoryLoading.value = true;
    providerHistory.clear();
    totalIncome.value = 0.0;
    currentDue.value = 0.0; // রিসেট

    try {
      String url = "${ApiConstants.providerHistory}?id=$id";
      final response = await _apiClient.getData(url);

      if (response.statusCode == 200 && response.body['status'] == 'success') {
        providerHistory.value = response.body['data'];

        // [UPDATE] ইনকাম এবং ডিউ পার্স করা
        totalIncome.value = double.tryParse(response.body['total_income'].toString()) ?? 0.0;
        currentDue.value = double.tryParse(response.body['current_due'].toString()) ?? 0.0;
      }
    } catch (e) {
      print("History Error: $e");
    } finally {
      isHistoryLoading.value = false;
    }
  }

  // ৫. স্ট্যাটাস আপডেট (Approve/Block)
  void updateStatus(int id, String newStatus) async {
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
    try {
      final response = await _apiClient.postData(ApiConstants.providerUpdate, {
        "id": id,
        "status": newStatus
      });
      Get.back();
      if (response.statusCode == 200 && response.body['status'] == 'success') {
        Get.snackbar("Success", "Status updated to $newStatus", backgroundColor: Colors.green, colorText: Colors.white);
        fetchProviders();
      } else {
        Get.snackbar("Failed", response.body['message'] ?? "Error");
      }
    } catch (e) {
      Get.back();
      Get.snackbar("Error", "Connection Error");
    }
  }

  // ৬. পাসওয়ার্ড পরিবর্তন
  void changePassword(int id, String newPassword) async {
    if (newPassword.length < 6) {
      Get.snackbar("Error", "Password must be at least 6 chars");
      return;
    }
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
    try {
      final response = await _apiClient.postData(ApiConstants.providerUpdate, {
        "id": id,
        "password": newPassword
      });
      Get.back();
      if (response.statusCode == 200 && response.body['status'] == 'success') {
        Get.back(); // ডায়ালগ বন্ধ
        Get.snackbar("Success", "Password changed successfully", backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Error", "Failed to update password");
      }
    } catch (e) {
      Get.back();
      Get.snackbar("Error", "Connection Error");
    }
  }

  void showChangePasswordDialog(int id) {
    final passCtrl = TextEditingController();
    Get.defaultDialog(
      title: "Change Password",
      content: Column(
        children: [
          const Text("Enter new password:"),
          const SizedBox(height: 10),
          TextField(controller: passCtrl, decoration: const InputDecoration(border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock))),
        ],
      ),
      textConfirm: "Update",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.blueAccent,
      onConfirm: () => changePassword(id, passCtrl.text),
    );
  }

  // ৭. ডিলিট প্রোভাইডার
  void confirmDelete(int id) {
    Get.defaultDialog(
        title: "Delete Provider?",
        middleText: "This cannot be undone. Are you sure?",
        textConfirm: "Delete",
        textCancel: "Cancel",
        confirmTextColor: Colors.white,
        buttonColor: Colors.red,
        onConfirm: () async {
          Get.back();
          Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
          try {
            final response = await _apiClient.postData(ApiConstants.providerDelete, {"id": id});
            Get.back();
            if (response.statusCode == 200 && response.body['status'] == 'success') {
              fetchProviders();
              Get.snackbar("Deleted", "Provider removed successfully");
            }
          } catch (e) {
            Get.back();
            Get.snackbar("Error", "Failed to delete");
          }
        }
    );
  }
}