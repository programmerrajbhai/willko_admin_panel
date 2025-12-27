import 'package:get/get.dart';
import '../../data/services/api_client.dart';
import '../../core/values/api_constants.dart';
import '../../data/models/dashboard_model.dart';

class HomeController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();

  var isLoading = true.obs;
  var selectedFilter = 'monthly'.obs; // ডিফল্ট ফিল্টার

  // সেফ ইনিশিয়ালাইজেশন
  var stats = DashboardModel(
      cards: DashboardCards(),
      chartData: [],
      recentOrders: [],
      growth: GrowthMetrics(),
      topPerformers: TopPerformers()
  ).obs;

  @override
  void onInit() {
    fetchDashboardStats();
    super.onInit();
  }

  // ফিল্টার আপডেট মেথড
  void updateFilter(String filter) {
    selectedFilter.value = filter;
    fetchDashboardStats();
  }

  void fetchDashboardStats() async {
    isLoading.value = true;
    try {
      // PHP API তে ফিল্টার প্যারামিটার পাঠানো হচ্ছে
      final response = await _apiClient.getData(
          "${ApiConstants.dashboardStats}?filter=${selectedFilter.value}"
      );

      if (response.statusCode == 200 && response.body['status'] == 'success') {
        stats.value = DashboardModel.fromJson(response.body['dashboard']);
      }
    } catch (e) {
      print("Error fetching stats: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ম্যানুয়াল রিফ্রেশ
  Future<void> refreshData() async {
    fetchDashboardStats();
  }
}