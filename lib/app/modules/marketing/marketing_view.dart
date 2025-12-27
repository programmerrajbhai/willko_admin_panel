import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'marketing_controller.dart';
import '../../core/theme/app_colors.dart';

class MarketingView extends StatelessWidget {
  const MarketingView({super.key});

  @override
  Widget build(BuildContext context) {
    // কন্ট্রোলার লোড করা
    final controller = Get.put(MarketingController());

    return Scaffold(
      backgroundColor: Colors.grey[50], // হালকা ব্যাকগ্রাউন্ড কালার
      appBar: AppBar(
        title: const Text("Marketing Campaign", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        bottom: TabBar(
          controller: controller.tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          tabs: const [
            Tab(text: "Banners", icon: Icon(Icons.image_outlined)),
            Tab(text: "Coupons", icon: Icon(Icons.local_offer_outlined)),
            Tab(text: "Notify", icon: Icon(Icons.notifications_active_outlined)),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: [
          // ------------------------------------------
          // 1. Banners Tab (Grid View + Preview)
          // ------------------------------------------
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return Stack(
              children: [
                if (controller.bannersList.isEmpty)
                  _buildEmptyState("No Active Banners", Icons.broken_image_outlined),

                GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // পাশাপাশি ২টা
                    childAspectRatio: 1.5, // সাইজ রেশিও
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: controller.bannersList.length,
                  itemBuilder: (ctx, i) {
                    var item = controller.bannersList[i];
                    return _buildBannerCard(item, controller);
                  },
                ),

                // ইমেজ আপলোডিং লোডার (Uploading...)
                if (controller.isUploading.value)
                  Container(
                    color: Colors.black.withOpacity(0.6),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(height: 15),
                          Text("Uploading Banner...", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  )
              ],
            );
          }),

          // ------------------------------------------
          // 2. Coupons Tab (List View)
          // ------------------------------------------
          Obx(() {
            if (controller.couponsList.isEmpty) {
              return _buildEmptyState("No Coupons Available", Icons.local_activity_outlined);
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.couponsList.length,
              itemBuilder: (ctx, i) {
                var item = controller.couponsList[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.grey.shade200, blurRadius: 6, offset: const Offset(0, 3))
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.confirmation_number, color: Colors.orange),
                    ),
                    title: Text(
                        item['code'],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1.1)
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text("Discount: ৳${item['discount_amount']} • Valid: ${item['valid_until']}"),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => controller.deleteCoupon(int.parse(item['id'].toString())),
                    ),
                  ),
                );
              },
            );
          }),

          // ------------------------------------------
          // 3. Notification Tab (Input Form)
          // ------------------------------------------
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Push Notification", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 8),
                const Text("Send offers and updates to all users instantly.", style: TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 30),

                _buildTextField("Notification Title", Icons.title, (val) {}, isTitle: true),
                const SizedBox(height: 20),
                _buildTextField("Message Body", Icons.message, (val) {}, maxLines: 4),

                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      controller.sendNotification("Special Offer", "Get 50% off on AC Service!");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.send_rounded),
                    label: const Text("SEND NOTIFICATION", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
        ],
      ),

      // ------------------------------------------
      // Floating Action Button (FAB)
      // ------------------------------------------
      floatingActionButton: Obx(() => controller.tabIndex.value != 2
          ? FloatingActionButton.extended(
        onPressed: () => _handleFabAction(context, controller),
        backgroundColor: AppColors.primary,
        elevation: 4,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          controller.tabIndex.value == 0 ? "Upload Banner" : "Create Coupon",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      )
          : const SizedBox()),
    );
  }

  // ==========================================
  // Custom Widgets & Helper Methods
  // ==========================================

  // 🔥 ১. ব্যানার কার্ড উইজেট (প্রিভিউ সহ)
  Widget _buildBannerCard(dynamic item, MarketingController controller) {
    final String imageUrl = item['image_url'] ?? '';
    final String heroTag = "banner_${item['id']}"; // ইউনিক ট্যাগ

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))
        ],
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // ইমেজ (ট্যাপ করলে ফুল স্ক্রিন হবে)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => _showFullImage(imageUrl, heroTag),
                child: Hero(
                  tag: heroTag,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey.shade100,
                        child: const Center(child: Icon(Icons.image, color: Colors.grey, size: 40)),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.broken_image, color: Colors.red)),
                  ),
                ),
              ),
            ),

            // ডিলিট বাটন (গ্লাসমরফিজম স্টাইল)
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => controller.deleteBanner(int.tryParse(item['id'].toString()) ?? 0),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.85),
                      shape: BoxShape.circle,
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                    ),
                    child: const Icon(Icons.delete, color: Colors.white, size: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 ২. ফুল স্ক্রিন ইমেজ ভিউয়ার (Zoomable)
  void _showFullImage(String imageUrl, String heroTag) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // ব্যাকগ্রাউন্ড (ক্লিক করলে বন্ধ হবে)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(color: Colors.black.withOpacity(0.9)),
              ),
            ),

            // ইমেজ (জুম করা যাবে)
            Center(
              child: Hero(
                tag: heroTag,
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Image.network(imageUrl),
                ),
              ),
            ),

            // ক্লোজ বাটন
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white, size: 30),
                onPressed: () => Get.back(),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: true,
    );
  }

  // ৩. এম্পটি স্টেট (ডাটা না থাকলে দেখাবে)
  Widget _buildEmptyState(String text, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
            child: Icon(icon, size: 60, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 15),
          Text(text, style: TextStyle(color: Colors.grey.shade500, fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // ৪. টেক্সট ফিল্ড ডিজাইন
  Widget _buildTextField(String label, IconData icon, Function(String) onChanged, {int maxLines = 1, bool isTitle = false}) {
    return TextField(
      maxLines: maxLines,
      onChanged: onChanged,
      style: TextStyle(fontSize: 16, fontWeight: isTitle ? FontWeight.bold : FontWeight.normal),
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: true,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Icon(icon, color: AppColors.primary),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
      ),
    );
  }

  // ৫. FAB অ্যাকশন হ্যান্ডলার
  void _handleFabAction(BuildContext context, MarketingController controller) {
    if (controller.tabIndex.value == 0) {
      controller.pickAndUploadBanner();
    } else if (controller.tabIndex.value == 1) {
      final codeCtrl = TextEditingController();
      final amountCtrl = TextEditingController();
      Get.defaultDialog(
        title: "Create New Coupon",
        titleStyle: const TextStyle(fontWeight: FontWeight.bold),
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          children: [
            TextField(controller: codeCtrl, decoration: const InputDecoration(labelText: "Code (e.g. SUMMER50)", border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: amountCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Discount Amount", border: OutlineInputBorder())),
          ],
        ),
        textConfirm: "Create",
        textCancel: "Cancel",
        confirmTextColor: Colors.white,
        buttonColor: AppColors.primary,
        onConfirm: () => controller.addCoupon(codeCtrl.text, amountCtrl.text, "2025-12-31"),
      );
    }
  }
}