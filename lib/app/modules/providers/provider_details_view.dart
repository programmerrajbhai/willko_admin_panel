import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'providers_controller.dart';
import '../../core/values/api_constants.dart';

class ProviderDetailsView extends StatefulWidget {
  final dynamic provider;
  const ProviderDetailsView({super.key, required this.provider});

  @override
  State<ProviderDetailsView> createState() => _ProviderDetailsViewState();
}

class _ProviderDetailsViewState extends State<ProviderDetailsView> {
  final ProvidersController controller = Get.find<ProvidersController>();

  @override
  void initState() {
    super.initState();
    // পেজ লোড হলে হিস্ট্রি কল করবে
    _loadData();
  }

  // ডাটা লোড/রিফ্রেশ ফাংশন
  Future<void> _loadData() async {
    await controller.fetchProviderDetails(int.parse(widget.provider['id'].toString()));
  }

  @override
  Widget build(BuildContext context) {
    var p = widget.provider;
    String? imageUrl = p['image_url'];
    // ইমেজ URL চেক (যদি লিস্ট থেকে আসে বা ডিটেইলস থেকে)
    if (imageUrl == null && p['image'] != null && p['image'].toString().isNotEmpty) {
      imageUrl = ApiConstants.imageBaseUrl + p['image'];
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(p['name'] ?? "Details"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadData, // রিফ্রেশ করলে এই ফাংশন কল হবে
        color: Colors.blueAccent,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(), // কন্টেন্ট কম হলেও যাতে রিফ্রেশ কাজ করে
          child: Column(
            children: [
              // ১. প্রোফাইল হেডার
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Hero(
                      tag: 'provider_${p['id']}',
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: (imageUrl != null) ? NetworkImage(imageUrl) : null,
                        child: (imageUrl == null) ? const Icon(Icons.person, size: 50, color: Colors.grey) : null,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(p['name'] ?? "Unknown", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    Text(p['phone'] ?? "", style: TextStyle(color: Colors.grey[600])),

                    const SizedBox(height: 15),

                    // স্ট্যাটাস এবং পাসওয়ার্ড চেঞ্জ বাটন
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.blue.withOpacity(0.5))
                          ),
                          child: Text((p['status'] ?? 'Unknown').toUpperCase(), style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: () => controller.showChangePasswordDialog(int.parse(p['id'].toString())),
                          icon: const Icon(Icons.lock_reset, size: 16, color: Colors.white),
                          label: const Text("Change Pass", style: TextStyle(color: Colors.white, fontSize: 12)),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: const StadiumBorder()),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // ২. ইনকাম স্ট্যাটস
              Obx(() => Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statItem("Total Income", "৳${controller.totalIncome.value}", Icons.attach_money, Colors.green),
                    _statItem("Total Jobs", "${controller.providerHistory.length}", Icons.work, Colors.orange),
                  ],
                ),
              )),

              const SizedBox(height: 20),

              // ৩. রিসেন্ট জবস হেডার
              const Padding(
                padding: EdgeInsets.only(left: 20, bottom: 10),
                child: Align(alignment: Alignment.centerLeft, child: Text("Recent Jobs", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              ),

              // ৪. কাজের লিস্ট (Job History)
              Obx(() {
                if (controller.isHistoryLoading.value) {
                  return const Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator());
                }
                if (controller.providerHistory.isEmpty) {
                  return Container(
                    height: 100,
                    alignment: Alignment.center,
                    child: const Text("No job history found", style: TextStyle(color: Colors.grey)),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(), // বাইরের স্ক্রল কাজ করবে
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: controller.providerHistory.length,
                  itemBuilder: (ctx, i) {
                    var job = controller.providerHistory[i];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.cleaning_services, color: Colors.blue),
                        ),
                        title: Text(job['service_name'] ?? "Service"),
                        subtitle: Text("Customer: ${job['customer_name'] ?? 'N/A'}\nDate: ${job['created_at'] ?? ''}"),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("৳${job['total_price'] ?? 0}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 15)),
                            const SizedBox(height: 4),
                            Text((job['status'] ?? '').toUpperCase(), style: TextStyle(fontSize: 10, color: (job['status'] == 'completed') ? Colors.green : Colors.grey)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statItem(String label, String value, IconData icon, Color color) {
    return Column(children: [Icon(icon, color: color, size: 30), const SizedBox(height: 5), Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12))]);
  }
}