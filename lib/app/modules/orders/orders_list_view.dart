import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import 'orders_controller.dart';
import 'order_details_view.dart';

class OrdersListView extends StatelessWidget {
  const OrdersListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrdersController());

    return Scaffold(
      appBar: AppBar(title: const Text("All Orders")),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());

        if (controller.orderList.isEmpty) {
          return const Center(child: Text("No orders found", style: TextStyle(color: Colors.grey)));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: controller.orderList.length,
          itemBuilder: (context, index) {
            var order = controller.orderList[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Text("#${order.id}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                title: Text(order.serviceName, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("${order.customerName} • ${order.status.toUpperCase()}"),
                trailing: Text("৳${order.totalPrice}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                onTap: () => Get.to(() => OrderDetailsView(order: order)),
              ),
            );
          },
        );
      }),
    );
  }
}