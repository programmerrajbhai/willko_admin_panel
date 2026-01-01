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
      backgroundColor: Colors.grey.shade100, // সফট ব্যাকগ্রাউন্ড
      appBar: AppBar(
        title: const Text("Order Details", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ১. হেডার সেকশন (ID, Date & Price)
            _buildHeaderSection(),
            const SizedBox(height: 20),

            // ২. স্ট্যাটাস এবং পেমেন্ট সেকশন
            _buildStatusSection(context),
            const SizedBox(height: 20),

            // ৩. কাস্টমার এবং সার্ভিস ডিটেইলস
            _buildInfoSection(
              title: "Customer & Service",
              children: [
                _buildDetailRow(Icons.person, "Customer", order.customerName),
                _buildDetailRow(Icons.phone, "Phone", order.customerPhone, isPhone: true),
                const Divider(height: 24),
                _buildDetailRow(Icons.cleaning_services, "Service", order.serviceName),
              ],
            ),
            const SizedBox(height: 20),

            // ৪. প্রোভাইডার সেকশন (অ্যাসাইন লজিক সহ)
            _buildProviderSection(context),
            const SizedBox(height: 30),

            // ৫. অ্যাকশন বাটন (অর্ডার স্ট্যাটাস আপডেট)
            const Text("Update Order Status", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(child: _actionBtn("Confirm", Colors.blue.shade600, Icons.check, () => controller.updateStatus(order.id, 'confirmed'))),
                const SizedBox(width: 10),
                Expanded(child: _actionBtn("Complete", Colors.green.shade600, Icons.done_all, () => controller.updateStatus(order.id, 'completed'))),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: _actionBtn("Cancel Order", Colors.red.shade400, Icons.cancel, () => controller.updateStatus(order.id, 'cancelled'), isFullWidth: true),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widgets ---

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _boxDecoration(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Order #${order.id}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(order.date.split(" ")[0], style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  "৳${order.totalPrice}",
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary)
              ),
            ],
          ),
          const Text("Total Amount", style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildStatusSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Order Status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Order Status", style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 5),
                _statusBadge(order.status, _getStatusColor(order.status)),
              ],
            ),
          ),
          Container(width: 1, height: 40, color: Colors.grey.shade300), // Vertical Divider
          const SizedBox(width: 20),
          // Payment Status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Payment", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    // পেমেন্ট এডিট বাটন (যদি Unpaid থাকে)
                    if (order.paymentStatus == 'unpaid')
                      InkWell(
                        onTap: () => _showPaymentDialog(context),
                        child: const Icon(Icons.edit, size: 16, color: Colors.blue),
                      ),
                  ],
                ),
                const SizedBox(height: 5),
                _statusBadge(
                    order.paymentStatus,
                    order.paymentStatus == 'paid' ? Colors.green : Colors.redAccent
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderSection(BuildContext context) {
    bool hasProvider = order.providerId != null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.badge, size: 20, color: Colors.orange),
              SizedBox(width: 10),
              Text("Provider Info", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(height: 24),
          if (hasProvider) ...[
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.two_wheeler, color: Colors.purple),
              ),
              title: Text(order.providerName ?? "Unknown", style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("Assigned Provider"),
              trailing: IconButton(
                icon: const Icon(Icons.change_circle_outlined, color: Colors.blue),
                tooltip: "Change Provider",
                onPressed: () => _showAssignDialog(context),
              ),
            ),
          ] else ...[
            const Text("No provider assigned yet.", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Assign Provider"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => _showAssignDialog(context),
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildInfoSection({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ...children
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {bool isPhone = false}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 18, color: Colors.grey.shade700),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 2),
            Text(value, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: isPhone ? Colors.blue : Colors.black87)),
          ],
        ),
      ],
    );
  }

  // অ্যাকশন বাটন উইজেট
  Widget _actionBtn(String text, Color color, IconData icon, VoidCallback onTap, {bool isFullWidth = false}) {
    return ElevatedButton.icon(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
      ),
      icon: Icon(icon, size: 18),
      label: Text(text),
    );
  }

  // স্ট্যাটাস ব্যাজ ডিজাইন
  Widget _statusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4)),
      ],
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

  // --- Dialogs ---

  void _showAssignDialog(BuildContext context) {
    if (controller.providersList.isEmpty) controller.fetchProviders();

    Get.defaultDialog(
      title: "Select Provider",
      titlePadding: const EdgeInsets.only(top: 20),
      contentPadding: const EdgeInsets.all(20),
      content: SizedBox(
        height: 250,
        width: 300,
        child: Obx(() => controller.providersList.isEmpty
            ? const Center(child: Text("No providers available"))
            : ListView.separated(
          itemCount: controller.providersList.length,
          separatorBuilder: (ctx, i) => const Divider(),
          itemBuilder: (ctx, i) {
            var p = controller.providersList[i];
            bool isSelected = p.id == order.providerId;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(p.name, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
              trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.green) : null,
              onTap: () => controller.assignProvider(order.id, p.id),
            );
          },
        )),
      ),
    );
  }

  // নতুন: পেমেন্ট স্ট্যাটাস চেঞ্জ ডায়ালগ
  void _showPaymentDialog(BuildContext context) {
    Get.defaultDialog(
      title: "Confirm Payment",
      middleText: "Mark this order as PAID?",
      textConfirm: "Yes, Paid",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.green,
      onConfirm: () {
        Get.back(); // Close dialog
        // আপনার কন্ট্রোলারে এই মেথডটি থাকতে হবে (যা আমরা আগেই যোগ করেছি)
        controller.updatePaymentStatus(order.id, 'paid');
      },
    );
  }
}