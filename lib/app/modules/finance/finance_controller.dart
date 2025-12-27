import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/api_client.dart';
import '../../core/values/api_constants.dart';

class FinanceController extends GetxController with GetSingleTickerProviderStateMixin {
  final ApiClient _apiClient = Get.find<ApiClient>();
  late TabController tabController;

  var isLoading = false.obs;
  var dueList = <dynamic>[].obs;
  var transactions = <dynamic>[].obs;

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    fetchDueList();
    fetchTransactions();
    super.onInit();
  }

  void fetchDueList() async {
    isLoading.value = true;
    final res = await _apiClient.getData(ApiConstants.dueList);
    if (res.statusCode == 200) dueList.value = res.body['data'];
    isLoading.value = false;
  }

  void fetchTransactions() async {
    final res = await _apiClient.getData(ApiConstants.transactions);
    if (res.statusCode == 200) transactions.value = res.body['data'];
  }

  void collectMoney(int providerId, String amount) async {
    Get.back();
    isLoading.value = true;
    try {
      final res = await _apiClient.postData(ApiConstants.collectMoney, {
        "provider_id": providerId,
        "amount": amount,
        "note": "Collected by Admin"
      });

      if (res.statusCode == 200 && res.body['status'] == 'success') {
        Get.snackbar("Success", "Money collected successfully");
        fetchDueList();
        fetchTransactions();
      } else {
        Get.snackbar("Error", res.body['message']);
      }
    } finally {
      isLoading.value = false;
    }
  }
}