import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/order_model.dart';
import 'orders_controller.dart';
import 'order_details_view.dart';

class OrdersListView extends StatelessWidget {
  const OrdersListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrdersController());

    return Scaffold(
      backgroundColor: Colors.grey.shade100, // ব্যাকগ্রাউন্ড একটু হালকা ধূসর
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text("All Orders", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchOrders(),
          )
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.orderList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 10),
                Text("No orders found", style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => controller.fetchOrders(),
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: controller.orderList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              var order = controller.orderList[index];
              return _buildOrderCard(context, order);
            },
          ),
        );
      }),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order) {
    return InkWell(
      onTap: () => Get.to(() => OrderDetailsView(order: order)),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header: Order ID and Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "#${order.id}",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ),
                  Text(
                    order.date.split(" ")[0], // শুধু তারিখ দেখাবে, সময় বাদ দিয়ে
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
              const Divider(height: 20),

              // 2. Service Info & Price
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service Image or Icon placeholder
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      image: order.serviceImage.isNotEmpty
                          ? DecorationImage(image: NetworkImage(order.serviceImage), fit: BoxFit.cover)
                          : null,
                    ),
                    child: order.serviceImage.isEmpty
                        ? const Icon(Icons.cleaning_services, color: Colors.blue)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.serviceName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.person, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                order.customerName,
                                style: const TextStyle(color: Colors.grey, fontSize: 13),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "৳${order.totalPrice}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green, // টাকার রঙ সবুজ
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 12),

              // 3. Status Badges
              Row(
                children: [
                  _statusBadge(order.status, _getStatusColor(order.status)),
                  const SizedBox(width: 8),
                  _statusBadge(
                      order.paymentStatus,
                      order.paymentStatus == 'paid' ? Colors.teal : Colors.redAccent,
                      isOutlined: true
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // স্ট্যাটাস চিপ/ব্যাজ ডিজাইন
  Widget _statusBadge(String text, Color color, {bool isOutlined = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isOutlined ? Colors.transparent : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return Colors.orange;
      case 'confirmed': return Colors.blue;
      case 'completed': return Colors.green;
      case 'cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }
}