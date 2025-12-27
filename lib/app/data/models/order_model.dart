
class OrderModel {
  final int id;
  final String customerName;
  final String customerPhone;
  final String serviceName;
  final String serviceImage;
  final double totalPrice;
  final String status;
  final String date;
  final int? providerId; // কাকে কাজটা দেওয়া হয়েছে
  final String? providerName;

  OrderModel({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.serviceName,
    required this.serviceImage,
    required this.totalPrice,
    required this.status,
    required this.date,
    this.providerId,
    this.providerName,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      customerName: json['customer_name'] ?? 'Unknown',
      customerPhone: json['customer_phone'] ?? '',
      serviceName: json['service_name'] ?? 'Unknown Service',
      serviceImage: json['service_image'] ?? '',
      totalPrice: double.tryParse(json['total_price'].toString()) ?? 0.0,
      status: json['status'] ?? 'pending',
      date: json['created_at'] ?? '',
      providerId: int.tryParse(json['provider_id'].toString()),
      providerName: json['provider_name'],
    );
  }
}

// প্রোভাইডার লিস্ট দেখানোর জন্য ছোট মডেল
class SimpleProviderModel {
  final int id;
  final String name;
  SimpleProviderModel({required this.id, required this.name});

  factory SimpleProviderModel.fromJson(Map<String, dynamic> json) {
    return SimpleProviderModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? 'Unknown',
    );
  }
}