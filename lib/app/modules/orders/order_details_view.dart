import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/order_model.dart';
import 'orders_controller.dart';

class OrderDetailsView extends StatelessWidget {
  final OrderModel order;
  final OrdersController controller = Get.find<OrdersController>();

  OrderDetailsView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order #${order.id}")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ১. কাস্টমার ইনফো কার্ড
            _buildInfoCard(
              title: "Customer Info",
              icon: Icons.person,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order.customerName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 16, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(order.customerPhone),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // ২. সার্ভিস ডিটেইলস
            _buildInfoCard(
              title: "Service Details",
              icon: Icons.cleaning_services,
              content: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(order.serviceName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Text("৳${order.totalPrice}", style: const TextStyle(fontSize: 18, color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Current Status:"),
                      Chip(
                        label: Text(order.status.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 12)),
                        backgroundColor: _getStatusColor(order.status),
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ৩. অ্যাকশন বাটনস (Status Change)
            const Text("Update Status", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _actionBtn("Confirm", Colors.blue, () => controller.updateStatus(order.id, 'confirmed')),
                _actionBtn("Complete", Colors.green, () => controller.updateStatus(order.id, 'completed')),
                _actionBtn("Cancel", Colors.red, () => controller.updateStatus(order.id, 'cancelled')),
              ],
            ),

            const SizedBox(height: 20),

            // ৪. প্রোভাইডার অ্যাসাইন বাটন
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.motorcycle),
                label: const Text("Assign Provider"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                onPressed: () => _showAssignDialog(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // অ্যাসাইন করার জন্য ডায়ালগ
  void _showAssignDialog(BuildContext context) {
    Get.defaultDialog(
      title: "Select Provider",
      content: SizedBox(
        height: 200,
        width: 300,
        child: Obx(() => ListView.builder(
          itemCount: controller.providersList.length,
          itemBuilder: (ctx, i) {
            var p = controller.providersList[i];
            return ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(p.name),
              onTap: () => controller.assignProvider(order.id, p.id),
            );
          },
        )),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required IconData icon, required Widget content}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(icon, color: AppColors.primary), const SizedBox(width: 10), Text(title, style: const TextStyle(fontWeight: FontWeight.bold))]),
            const Divider(),
            content,
          ],
        ),
      ),
    );
  }

  Widget _actionBtn(String text, Color color, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 20)),
      child: Text(text),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending': return Colors.orange;
      case 'confirmed': return Colors.blue;
      case 'completed': return Colors.green;
      case 'cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }
}