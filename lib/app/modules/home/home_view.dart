import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../global_widgets/sidebar_drawer.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/dashboard_model.dart';
import 'home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final isDesktop = MediaQuery.of(context).size.width >= 1000;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6), // Professional Light Grey
      appBar: isDesktop ? null : AppBar(
        title: const Text("Dashboard", style: TextStyle(color: Color(0xFF111827), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Color(0xFF111827)),
      ),
      drawer: const SidebarDrawer(),
      body: Row(
        children: [
          if (isDesktop) const SizedBox(width: 260, child: SidebarDrawer()),
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.refreshData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: const Center(child: CircularProgressIndicator())
                    );
                  }

                  var data = controller.stats.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header & Filter Chips
                      _buildHeaderWithFilter(controller),
                      const SizedBox(height: 24),

                      // Main Stats Cards
                      _buildStatsGrid(data.cards, isDesktop),
                      const SizedBox(height: 24),

                      // Chart & Extra Info
                      if (isDesktop)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 2, child: _buildSalesChartSection(data.chartData, controller.selectedFilter.value)),
                            const SizedBox(width: 24),
                            Expanded(flex: 1, child: _buildRightSideWidgets(data)),
                          ],
                        )
                      else
                        Column(
                          children: [
                            _buildSalesChartSection(data.chartData, controller.selectedFilter.value),
                            const SizedBox(height: 24),
                            _buildRightSideWidgets(data),
                          ],
                        ),

                      const SizedBox(height: 24),
                      _buildRecentOrders(data.recentOrders),
                      const SizedBox(height: 30),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Header with Filter Chips ---
  Widget _buildHeaderWithFilter(HomeController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Overview", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
            const SizedBox(height: 4),
            Text("Here is your store's performance overview.", style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          ],
        ),
        // Filter Buttons
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: ["weekly", "monthly", "yearly"].map((filter) {
              bool isSelected = controller.selectedFilter.value == filter;
              return InkWell(
                onTap: () => controller.updateFilter(filter),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    filter.capitalizeFirst!,
                    style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[600],
                        fontWeight: FontWeight.w600,
                        fontSize: 13
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  // --- Stats Grid ---
  Widget _buildStatsGrid(DashboardCards cards, bool isDesktop) {
    final currency = NumberFormat.currency(symbol: "৳", decimalDigits: 0);

    List<Widget> stats = [
      _buildStatCard("Total Revenue", currency.format(cards.totalRevenue), Icons.attach_money, const Color(0xFF4F46E5), Colors.white),
      _buildStatCard("Net Profit", currency.format(cards.netProfit), Icons.pie_chart, const Color(0xFF10B981), Colors.white),
      _buildStatCard("Total Orders", cards.totalOrders.toString(), Icons.shopping_bag_outlined, const Color(0xFFF59E0B), Colors.white),
      _buildStatCard("Market Due", currency.format(cards.marketDue), Icons.account_balance_wallet, const Color(0xFFEF4444), Colors.white),
    ];

    if (isDesktop) {
      return Row(children: stats.map((e) => Expanded(child: Padding(padding: const EdgeInsets.only(right: 16), child: e))).toList());
    } else {
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.4,
        children: stats,
      );
    }
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color iconColor, Color bg) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(color: Colors.grey[500], fontSize: 13, fontWeight: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: iconColor.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 20),
              )
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
        ],
      ),
    );
  }

  // --- Sales Chart Section ---
  Widget _buildSalesChartSection(List<ChartData> chartData, String filter) {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Sales Analytics (${filter.capitalizeFirst})", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Icon(Icons.bar_chart, color: Colors.grey[400]),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(child: _buildChart(chartData)),
        ],
      ),
    );
  }

  Widget _buildChart(List<ChartData> chartData) {
    if (chartData.isEmpty || (chartData.length == 1 && chartData[0].sales == 0)) {
      return const Center(child: Text("No sales data for this period", style: TextStyle(color: Colors.grey)));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1000,
          getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade100, strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < chartData.length) {
                  // খুব বেশি ডাটা হলে কিছু লেবেল স্কিপ করা হবে
                  if (chartData.length > 10 && index % 2 != 0) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(chartData[index].date, style: TextStyle(color: Colors.grey[500], fontSize: 10)),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: chartData.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.sales)).toList(),
            isCurved: true,
            color: AppColors.primary,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(show: true, color: AppColors.primary.withOpacity(0.1)),
          ),
        ],
      ),
    );
  }

  // --- Right Side Widgets (Top Performers & Growth) ---
  Widget _buildRightSideWidgets(DashboardModel data) {
    return Column(
      children: [
        // Top Performers Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Top Performers", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 15),
              _buildPerformerRow("Top Service", data.topPerformers.topService, Icons.star, Colors.orange),
              const Divider(height: 20),
              _buildPerformerRow("Top Provider", data.topPerformers.topProvider, Icons.person, Colors.blue),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Growth Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("New Growth", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildGrowthItem("New Users", data.growth.newCustomers.toString()),
                  Container(width: 1, height: 40, color: Colors.white24),
                  _buildGrowthItem("New Providers", data.growth.newProviders.toString()),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildPerformerRow(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 18)),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ])
      ],
    );
  }

  Widget _buildGrowthItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  // --- Recent Orders ---
  Widget _buildRecentOrders(List<RecentOrder> orders) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Recent Transactions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orders.length,
            separatorBuilder: (c, i) => Divider(height: 1, color: Colors.grey.shade100),
            itemBuilder: (context, index) {
              var order = orders[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    CircleAvatar(backgroundColor: Colors.blue.shade50, child: const Icon(Icons.receipt, color: Colors.blue, size: 20)),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(order.serviceName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text(order.customerName, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                      ]),
                    ),
                    Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text("৳${order.price}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      _statusBadge(order.status),
                    ]),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'completed': color = Colors.green; break;
      case 'pending': color = Colors.orange; break;
      case 'cancelled': color = Colors.red; break;
      default: color = Colors.blue;
    }
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
      child: Text(status.toUpperCase(), style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}