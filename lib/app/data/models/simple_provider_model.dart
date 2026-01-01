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