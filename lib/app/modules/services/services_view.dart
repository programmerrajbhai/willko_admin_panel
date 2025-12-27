import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'services_controller.dart';
import '../../core/values/api_constants.dart';

class ServicesView extends StatelessWidget {
  const ServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ServicesController());

    return Scaffold(
      appBar: AppBar(title: const Text("Services")),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());

        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: controller.servicesList.length,
          itemBuilder: (ctx, i) {
            var item = controller.servicesList[i];
            return Card(
              child: ListTile(
                leading: Container(
                  width: 50, height: 50,
                  child: item['image'] != null
                      ? Image.network(ApiConstants.imageBaseUrl + item['image'], fit: BoxFit.cover)
                      : const Icon(Icons.image),
                ),
                title: Text(item['name'] ?? ""),
                subtitle: Text("৳${item['price']} • ${item['category_name'] ?? ''}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => controller.deleteService(int.parse(item['id'].toString())),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}