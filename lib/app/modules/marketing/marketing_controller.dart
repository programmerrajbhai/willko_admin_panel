import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/services/api_client.dart';
import '../../core/values/api_constants.dart';

class MarketingController extends GetxController with GetSingleTickerProviderStateMixin {
  final ApiClient _apiClient = Get.find<ApiClient>();
  final ImagePicker _picker = ImagePicker();

  late TabController tabController;

  // ✅ ফিক্স: এটি অবশ্যই .obs হতে হবে
  var tabIndex = 0.obs;

  var isLoading = false.obs;
  var isUploading = false.obs;
  var bannersList = <dynamic>[].obs;
  var couponsList = <dynamic>[].obs;

  @override
  void onInit() {
    tabController = TabController(length: 3, vsync: this);

    // ✅ ফিক্স: ট্যাব চেঞ্জ হলে ভেরিয়েবল আপডেট হবে
    tabController.addListener(() {
      tabIndex.value = tabController.index;
    });

    fetchBanners();
    fetchCoupons();
    super.onInit();
  }

  // --- Banners ---
  void fetchBanners() async {
    isLoading.value = true;
    try {
      final res = await _apiClient.getData(ApiConstants.bannersList);
      if (res.statusCode == 200 && res.body['status'] == 'success') {
        bannersList.value = res.body['data'];
      }
    } catch (e) {
      print("Error fetching banners: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void pickAndUploadBanner() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        isUploading.value = true;

        // === WEB FIX START ===
        // ওয়েবে path কাজ করে না, তাই bytes পড়তে হবে
        final imageBytes = await image.readAsBytes();

        final formData = FormData({
          'image': MultipartFile(imageBytes, filename: image.name), // path এর বদলে bytes পাঠানো হলো
        });
        // === WEB FIX END ===

        final res = await _apiClient.postData(ApiConstants.bannerAdd, formData);

        if (res.statusCode == 200 && res.body['status'] == 'success') {
          Get.snackbar("Success", "Banner uploaded successfully!",
              backgroundColor: Colors.green.withOpacity(0.2), colorText: Colors.green);
          fetchBanners(); // লিস্ট রিফ্রেশ
        } else {
          Get.snackbar("Error", res.body['message'] ?? "Failed to upload",
              backgroundColor: Colors.red.withOpacity(0.2), colorText: Colors.red);
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isUploading.value = false;
    }
  }

  void deleteBanner(int id) async {
    Get.defaultDialog(
        title: "Delete Banner?",
        middleText: "Are you sure you want to remove this banner?",
        textConfirm: "Yes, Delete",
        textCancel: "No",
        confirmTextColor: Colors.white,
        onConfirm: () async {
          Get.back();
          final res = await _apiClient.postData(ApiConstants.bannerDelete, {"id": id});
          if (res.statusCode == 200) {
            fetchBanners();
            Get.snackbar("Deleted", "Banner removed successfully");
          }
        }
    );
  }

  // --- Coupons ---
  void fetchCoupons() async {
    try {
      final res = await _apiClient.getData(ApiConstants.couponsList);
      if (res.statusCode == 200) couponsList.value = res.body['data'];
    } catch (e) {
      print(e);
    }
  }

  void addCoupon(String code, String amount, String validUntil) async {
    Get.back();
    if(code.isEmpty || amount.isEmpty) return;

    final res = await _apiClient.postData(ApiConstants.couponAdd, {
      "code": code,
      "amount": amount,
      "valid_until": validUntil
    });
    if (res.statusCode == 200) {
      Get.snackbar("Success", "Coupon Created");
      fetchCoupons();
    }
  }

  void deleteCoupon(int id) async {
    final res = await _apiClient.postData(ApiConstants.couponDelete, {"id": id});
    if (res.statusCode == 200) fetchCoupons();
  }

  // --- Notification ---
  void sendNotification(String title, String body) async {
    if(title.isEmpty || body.isEmpty) {
      Get.snackbar("Error", "Title and Body required");
      return;
    }

    isLoading.value = true;
    try {
      final res = await _apiClient.postData(ApiConstants.sendNotification, {
        "title": title,
        "body": body,
        "target": "all"
      });
      if(res.statusCode == 200) {
        Get.snackbar("Sent", "Notification sent successfully!", backgroundColor: Colors.green.withOpacity(0.2));
      }
    } finally {
      isLoading.value = false;
    }
  }
}