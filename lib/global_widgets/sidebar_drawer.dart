import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/core/theme/app_colors.dart';
import '../app/data/storage/storage_service.dart';
import '../app/modules/auth/login_view.dart';
import '../app/modules/finance/finance_view.dart';
import '../app/modules/marketing/marketing_view.dart';
import '../app/modules/orders/orders_list_view.dart';
import '../app/modules/providers/providers_view.dart';
import '../app/modules/services/services_view.dart';
import '../app/modules/settings/settings_view.dart';

class SidebarDrawer extends StatelessWidget {
  const SidebarDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primary),
            accountName: const Text("Admin", style: TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: const Text("admin@willko.com"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: AppColors.primary, size: 40),
            ),
          ),


          // Menu Items
          _buildMenuItem(Icons.dashboard, "Dashboard", () => Get.back()), // Close drawer on same page
          // এই লাইনটি খুঁজে আপডেট করুন:
          _buildMenuItem(Icons.shopping_cart, "Orders", () {
            Get.back(); // ড্রয়ার বন্ধ
            Get.to(() => const OrdersListView()); // অর্ডারে যাওয়া
          }),
          // Providers
          _buildMenuItem(Icons.people, "Providers", () {
            Get.back();
            Get.to(() => const ProvidersView());
          }),

// Services
          _buildMenuItem(Icons.category, "Services", () {
            Get.back();
            Get.to(() => const ServicesView());
          }),


          // Marketing
          _buildMenuItem(Icons.campaign, "Marketing", () {
            Get.back();
            Get.to(() => const MarketingView());
          }),

// Finance
          _buildMenuItem(Icons.attach_money, "Finance", () {
            Get.back();
            Get.to(() => const FinanceView());
          }),
          // Settings আইটেমটি আপডেট করুন
          _buildMenuItem(Icons.settings, "Settings", () {
            Get.back();
            Get.to(() => const SettingsView());
          }),
          const Divider(),
          _buildMenuItem(Icons.logout, "Logout", () {
            StorageService.clear();
            Get.offAll(() => LoginView());
          }, isDanger: true),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, {bool isDanger = false}) {
    return ListTile(
      leading: Icon(icon, color: isDanger ? Colors.red : AppColors.textLight),
      title: Text(
          title,
          style: TextStyle(
              color: isDanger ? Colors.red : AppColors.textDark,
              fontWeight: isDanger ? FontWeight.bold : FontWeight.normal
          )
      ),
      onTap: onTap,
    );
  }
}