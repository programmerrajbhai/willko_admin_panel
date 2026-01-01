import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'providers_controller.dart';
import 'add_provider_view.dart';
import 'provider_details_view.dart';
import '../../core/values/api_constants.dart';

class ProvidersView extends StatelessWidget {
  const ProvidersView({super.key});

  @override
  Widget build(BuildContext context) {
    // কন্ট্রোলার ইনিশিয়ালাইজ করা
    final controller = Get.put(ProvidersController());

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Manage Providers", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Add New"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
        onPressed: () => Get.to(() => AddProviderView()),
      ),
      body: RefreshIndicator(
        onRefresh: controller.fetchProviders,
        child: Obx(() {
          if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
          if (controller.providersList.isEmpty) return const Center(child: Text("No Providers Found"));

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.providersList.length,
            itemBuilder: (ctx, i) {
              var item = controller.providersList[i];
              return _buildProviderCard(item, controller);
            },
          );
        }),
      ),
    );
  }

  Widget _buildProviderCard(dynamic item, ProvidersController controller) {
    String status = item['status'] ?? 'pending';
    Color statusColor = status == 'active' ? Colors.green : (status == 'blocked' ? Colors.red : Colors.orange);

    String? imageUrl = item['image_url'];
    // ইমেজ URL চেক
    if (imageUrl == null && item['image'] != null && item['image'].toString().isNotEmpty) {
      imageUrl = ApiConstants.imageBaseUrl + item['image'];
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey[200],
          backgroundImage: (imageUrl != null) ? NetworkImage(imageUrl) : null,
          child: (imageUrl == null) ? const Icon(Icons.person, color: Colors.grey) : null,
        ),
        title: Text(item['name'] ?? "No Name", style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item['phone'] ?? "", style: TextStyle(color: Colors.grey[600], fontSize: 13)),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: statusColor.withOpacity(0.5)),
              ),
              child: Text(status.toUpperCase(), style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            int id = int.parse(item['id'].toString());
            if (value == 'details') Get.to(() => ProviderDetailsView(provider: item));
            else if (value == 'delete') controller.confirmDelete(id);
            else controller.updateStatus(id, value);
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: "details", child: Row(children: [Icon(Icons.visibility, color: Colors.blue), SizedBox(width: 8), Text("Details")])),
            if (status != 'active') const PopupMenuItem(value: "active", child: Row(children: [Icon(Icons.check, color: Colors.green), SizedBox(width: 8), Text("Approve")])),
            if (status != 'blocked') const PopupMenuItem(value: "blocked", child: Row(children: [Icon(Icons.block, color: Colors.red), SizedBox(width: 8), Text("Block")])),
            const PopupMenuDivider(),
            const PopupMenuItem(value: "delete", child: Row(children: [Icon(Icons.delete, color: Colors.grey), SizedBox(width: 8), Text("Delete")])),
          ],
        ),
        onTap: () => Get.to(() => ProviderDetailsView(provider: item)),
      ),
    );
  }
}