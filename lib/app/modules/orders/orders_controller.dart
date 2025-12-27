import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/api_client.dart';
import '../../core/values/api_constants.dart';
import '../../data/models/order_model.dart';

class OrdersController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();

  var isLoading = true.obs;
  var orderList = <OrderModel>[].obs;
  var providersList = <SimpleProviderModel>[].obs; // ড্রপডাউনের জন্য

  @override
  void onInit() {
    fetchOrders();
    fetchProviders(); // অর্ডার পেজে ঢুকেই প্রোভাইডার লিস্ট লোড করে রাখব
    super.onInit();
  }

  // ১. সব অর্ডার আনা
  void fetchOrders() async {
    isLoading.value = true;
    try {
      final response = await _apiClient.getData(ApiConstants.ordersList);
      if (response.statusCode == 200 && response.body['status'] == 'success') {
        var data = response.body['data'] as List;
        orderList.value = data.map((e) => OrderModel.fromJson(e)).toList();
      }
    } catch (e) {
      Get.snackbar("Error", "Could not fetch orders");
    } finally {
      isLoading.value = false;
    }
  }

  // ২. প্রোভাইডার লিস্ট আনা (অ্যাসাইন করার জন্য)
  void fetchProviders() async {
    try {
      final response = await _apiClient.getData(ApiConstants.providersList);
      if (response.statusCode == 200 && response.body['status'] == 'success') {
        var data = response.body['data'] as List;
        providersList.value = data.map((e) => SimpleProviderModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("Provider fetch error: $e");
    }
  }

  // ৩. অর্ডার স্ট্যাটাস আপডেট (Pending -> Completed)
  void updateStatus(int id, String newStatus) async {
    try {
      final response = await _apiClient.postData(ApiConstants.orderStatus, {
        "id": id,
        "status": newStatus
      });

      if (response.statusCode == 200 && response.body['status'] == 'success') {
        Get.snackbar("Success", "Status updated to $newStatus");
        fetchOrders(); // লিস্ট রিফ্রেশ
      } else {
        Get.snackbar("Error", "Failed to update status");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    }
  }

  // ৪. প্রোভাইডার অ্যাসাইন করা
  void assignProvider(int orderId, int providerId) async {
    Get.back(); // ডায়ালগ বন্ধ করা
    try {
      final response = await _apiClient.postData(ApiConstants.orderAssign, {
        "order_id": orderId,
        "provider_id": providerId
      });

      if (response.statusCode == 200 && response.body['status'] == 'success') {
        Get.snackbar("Success", "Provider assigned successfully");
        fetchOrders();
      } else {
        Get.snackbar("Error", response.body['message'] ?? "Failed");
      }
    } catch (e) {
      Get.snackbar("Error", "Connection error");
    }
  }

  // ৫. অর্ডার ডিলিট করা
  void deleteOrder(int id) async {
    try {
      final response = await _apiClient.postData(ApiConstants.orderDelete, {"id": id});
      if (response.statusCode == 200 && response.body['status'] == 'success') {
        Get.snackbar("Deleted", "Order removed successfully");
        fetchOrders();
      }
    } catch (e) {
      Get.snackbar("Error", "Could not delete");
    }
  }
}