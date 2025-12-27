import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/data/services/api_client.dart';
import 'app/core/theme/app_colors.dart';
import 'app/data/storage/storage_service.dart'; // StorageService ইম্পোর্ট করতে হবে

// পেজ ইম্পোর্ট
import 'app/modules/auth/login_view.dart';
import 'app/modules/home/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); // স্টোরেজ মেমোরি লোড করা
  Get.put(ApiClient());

  runApp(
    GetMaterialApp(
      title: "Wilko Admin",
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
      ),

      // === ফিক্স: লগিন চেক করা ===
      // যদি আগে লগিন করা থাকে (Token আছে), তবে সরাসরি HomeView তে যাবে
      // নাহলে LoginView তে যাবে
      home: StorageService.isLoggedIn ? const HomeView() : LoginView(),
    ),
  );
}