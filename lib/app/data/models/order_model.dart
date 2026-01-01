class OrderModel {
  final int id;
  final String customerName;
  final String customerPhone;
  final String serviceName;
  final String serviceImage;
  final double totalPrice;
  final String status;
  final String paymentStatus; // ১. নতুন ফিল্ড (paid/unpaid)
  final String date;
  final int? providerId;
  final String? providerName;

  OrderModel({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.serviceName,
    required this.serviceImage,
    required this.totalPrice,
    required this.status,
    required this.paymentStatus, // কনস্ট্রাক্টরে অ্যাড করুন
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
      // ১. পেমেন্ট স্ট্যাটাস পার্স করা (ডিফল্ট unpaid)
      paymentStatus: json['payment_status'] ?? 'unpaid',
      date: json['created_at'] ?? '',
      providerId: int.tryParse(json['provider_id'].toString()),
      providerName: json['provider_name'],
    );
  }
}