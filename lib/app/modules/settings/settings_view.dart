import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'settings_controller.dart';
import '../../core/theme/app_colors.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("App Settings", style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: controller.tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: "General", icon: Icon(Icons.tune)),
            Tab(text: "Security", icon: Icon(Icons.security)),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());

        return TabBarView(
          controller: controller.tabController,
          children: [
            // Tab 1: General Settings Form
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildSectionTitle("App Configuration"),
                  const SizedBox(height: 15),
                  _buildTextField("Site Title", Icons.web, controller.titleCtrl),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(child: _buildTextField("Currency (e.g. BDT)", Icons.attach_money, controller.currencyCtrl)),
                      const SizedBox(width: 15),
                      Expanded(child: _buildTextField("VAT (%)", Icons.percent, controller.vatCtrl, isNumber: true)),
                    ],
                  ),
                  const SizedBox(height: 30),

                  _buildSectionTitle("Support Info"),
                  const SizedBox(height: 15),
                  _buildTextField("Support Phone", Icons.phone, controller.phoneCtrl, isNumber: true),
                  const SizedBox(height: 15),
                  _buildTextField("Support Email", Icons.email, controller.emailCtrl),

                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.updateSettings,
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                      child: const Text("SAVE CHANGES", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),

            // Tab 2: Security (Change Password)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Icon(Icons.lock_reset, size: 80, color: Colors.orange),
                  const SizedBox(height: 20),
                  const Text("Change Password", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Text("Enter a new password to update your account security.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 40),

                  _buildTextField("New Password", Icons.lock_outline, controller.newPassCtrl, isPass: true),
                  const SizedBox(height: 15),
                  _buildTextField("Confirm Password", Icons.lock, controller.confirmPassCtrl, isPass: true),

                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.changePassword,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                      child: const Text("UPDATE PASSWORD", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController ctrl, {bool isNumber = false, bool isPass = false}) {
    return TextField(
      controller: ctrl,
      obscureText: isPass,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}