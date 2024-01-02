class Employee {
  final int id;
  final String name;
  final String qrCode;

  Employee({required this.id, required this.name, required this.qrCode});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'qrCode': qrCode,
    };
  }
}
