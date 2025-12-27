import 'package:get/get.dart';
import '../../data/services/api_client.dart';
import '../../core/values/api_constants.dart';

class ServicesController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();

  var isLoading = true.obs;
  var servicesList = <dynamic>[].obs;
  var categoriesList = <dynamic>[].obs;

  @override
  void onInit() {
    fetchServices();
    super.onInit();
  }

  void fetchServices() async {
    isLoading.value = true;
    try {
      final res = await _apiClient.getData(ApiConstants.servicesList);
      if (res.statusCode == 200) servicesList.value = res.body['data'];

      // ক্যাটাগরিও লোড করে রাখি (dropdown এর জন্য লাগবে)
      final catRes = await _apiClient.getData(ApiConstants.categoriesList);
      if (catRes.statusCode == 200) categoriesList.value = catRes.body['data'];

    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void deleteService(int id) async {
    try {
      final res = await _apiClient.postData(ApiConstants.serviceDelete, {"id": id});
      if (res.statusCode == 200) fetchServices();
    } catch (e) {
      Get.snackbar("Error", "Failed to delete");
    }
  }
}