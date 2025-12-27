import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'providers_controller.dart';
import 'add_provider_view.dart';
import '../../core/values/api_constants.dart';

class ProvidersView extends StatelessWidget {
  const ProvidersView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProvidersController());

    return Scaffold(
      appBar: AppBar(title: const Text("Providers")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Get.to(() => AddProviderView()),
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());

        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: controller.providersList.length,
          itemBuilder: (ctx, i) {
            var item = controller.providersList[i];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: item['image'] != null
                      ? NetworkImage(ApiConstants.imageBaseUrl + item['image'])
                      : null,
                  child: item['image'] == null ? const Icon(Icons.person) : null,
                ),
                title: Text(item['name'] ?? "No Name"),
                subtitle: Text(item['phone'] ?? ""),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => controller.deleteProvider(int.parse(item['id'].toString())),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}