import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'finance_controller.dart';
import '../../core/theme/app_colors.dart';

class FinanceView extends StatelessWidget {
  const FinanceView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FinanceController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Finance & Due"),
        bottom: TabBar(
          controller: controller.tabController,
          tabs: const [
            Tab(text: "Due List"),
            Tab(text: "Transactions"),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: [
          // 1. Due List Tab
          Obx(() => ListView.builder(
            itemCount: controller.dueList.length,
            itemBuilder: (ctx, i) {
              var item = controller.dueList[i];
              return Card(
                color: Colors.red.shade50,
                child: ListTile(
                  title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Phone: ${item['phone']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("৳${item['current_due']}", style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                        onPressed: () => _showCollectDialog(controller, item['id']),
                        child: const Text("Collect"),
                      )
                    ],
                  ),
                ),
              );
            },
          )),

          // 2. Transactions History Tab
          Obx(() => ListView.builder(
            itemCount: controller.transactions.length,
            itemBuilder: (ctx, i) {
              var item = controller.transactions[i];
              return ListTile(
                leading: const Icon(Icons.history, color: Colors.grey),
                title: Text("Received from ${item['provider_name']}"),
                subtitle: Text(item['created_at']),
                trailing: Text("+৳${item['amount']}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
              );
            },
          )),
        ],
      ),
    );
  }

  void _showCollectDialog(FinanceController controller, dynamic providerId) {
    final amountCtrl = TextEditingController();
    Get.defaultDialog(
        title: "Collect Money",
        content: TextField(
          controller: amountCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Enter Amount", prefixText: "৳"),
        ),
        textConfirm: "Confirm",
        onConfirm: () => controller.collectMoney(int.parse(providerId.toString()), amountCtrl.text)
    );
  }
}