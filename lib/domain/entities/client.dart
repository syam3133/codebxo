class Client {
  final String id;
  final String userId;
  final String clientName;
  final String phoneNumber;
  final String? companyName;
  final String businessType;
  final bool usingSystem;
  final String customerPotential;
  final double latitude;
  final double longitude;
  final String? address;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  Client({
    required this.id,
    required this.userId,
    required this.clientName,
    required this.phoneNumber,
    this.companyName,
    required this.businessType,
    required this.usingSystem,
    required this.customerPotential,
    required this.latitude,
    required this.longitude,
    this.address,
    required this.createdAt,
    required this.updatedAt,
  });
}