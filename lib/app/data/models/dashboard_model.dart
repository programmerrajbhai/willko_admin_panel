class DashboardModel {
  final DashboardCards cards;
  final List<ChartData> chartData;
  final List<RecentOrder> recentOrders;
  final GrowthMetrics growth;
  final TopPerformers topPerformers;

  DashboardModel({
    required this.cards,
    required this.chartData,
    required this.recentOrders,
    required this.growth,
    required this.topPerformers,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      cards: DashboardCards.fromJson(json['cards'] ?? {}),
      chartData: (json['chart_data'] as List? ?? [])
          .map((e) => ChartData.fromJson(e))
          .toList(),
      recentOrders: (json['recent_orders'] as List? ?? [])
          .map((e) => RecentOrder.fromJson(e))
          .toList(),
      growth: GrowthMetrics.fromJson(json['growth'] ?? {}),
      topPerformers: TopPerformers.fromJson(json['top_performers'] ?? {}),
    );
  }
}

class DashboardCards {
  final double totalRevenue;
  final double netProfit;
  final int totalOrders;
  final int pendingOrders;
  final int completedOrders;
  final double marketDue;

  DashboardCards({
    this.totalRevenue = 0.0,
    this.netProfit = 0.0,
    this.totalOrders = 0,
    this.pendingOrders = 0,
    this.completedOrders = 0,
    this.marketDue = 0.0,
  });

  factory DashboardCards.fromJson(Map<String, dynamic> json) {
    return DashboardCards(
      totalRevenue: double.tryParse(json['total_revenue'].toString()) ?? 0.0,
      netProfit: double.tryParse(json['net_profit'].toString()) ?? 0.0,
      totalOrders: int.tryParse(json['total_orders'].toString()) ?? 0,
      pendingOrders: int.tryParse(json['pending_orders'].toString()) ?? 0,
      completedOrders: int.tryParse(json['completed_orders'].toString()) ?? 0,
      marketDue: double.tryParse(json['market_due'].toString()) ?? 0.0,
    );
  }
}

class ChartData {
  final String date;
  final double sales;

  ChartData({required this.date, required this.sales});

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      date: json['date'] ?? '',
      sales: double.tryParse(json['sales'].toString()) ?? 0.0,
    );
  }
}

class RecentOrder {
  final int id;
  final String serviceName;
  final String customerName;
  final double price;
  final String status;
  final String date;

  RecentOrder({
    required this.id,
    required this.serviceName,
    required this.customerName,
    required this.price,
    required this.status,
    required this.date,
  });

  factory RecentOrder.fromJson(Map<String, dynamic> json) {
    return RecentOrder(
      id: int.tryParse(json['id'].toString()) ?? 0,
      serviceName: json['service_name'] ?? 'Unknown',
      customerName: json['customer_name'] ?? 'Guest',
      price: double.tryParse(json['total_price'].toString()) ?? 0.0,
      status: json['status'] ?? 'pending',
      date: json['created_at'] ?? '',
    );
  }
}

class GrowthMetrics {
  final int newCustomers;
  final int newProviders;
  final int totalCustomers;
  final int totalProviders;

  GrowthMetrics({
    this.newCustomers = 0,
    this.newProviders = 0,
    this.totalCustomers = 0,
    this.totalProviders = 0,
  });

  factory GrowthMetrics.fromJson(Map<String, dynamic> json) {
    return GrowthMetrics(
      newCustomers: int.tryParse(json['new_customers'].toString()) ?? 0,
      newProviders: int.tryParse(json['new_providers'].toString()) ?? 0,
      totalCustomers: int.tryParse(json['total_customers'].toString()) ?? 0,
      totalProviders: int.tryParse(json['total_providers'].toString()) ?? 0,
    );
  }
}

class TopPerformers {
  final String topService;
  final String topProvider;

  TopPerformers({this.topService = "N/A", this.topProvider = "N/A"});

  factory TopPerformers.fromJson(Map<String, dynamic> json) {
    return TopPerformers(
      topService: json['top_service'] ?? "N/A",
      topProvider: json['top_provider'] ?? "N/A",
    );
  }
}