import '../../domain/entities/client.dart';

class ClientModel extends Client {
  ClientModel({
    required String id,
    required String userId,
    required String clientName,
    required String phoneNumber,
    String? companyName,
    required String businessType,
    required bool usingSystem,
    required String customerPotential,
    required double latitude,
    required double longitude,
    String? address,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
    id: id,
    userId: userId,
    clientName: clientName,
    phoneNumber: phoneNumber,
    companyName: companyName,
    businessType: businessType,
    usingSystem: usingSystem,
    customerPotential: customerPotential,
    latitude: latitude,
    longitude: longitude,
    address: address,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
  
  factory ClientModel.fromJson(Map<String, dynamic> json, String documentId) {
    return ClientModel(
      id: documentId,
      userId: json['userId'] ?? '',
      clientName: json['clientName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      companyName: json['companyName'],
      businessType: json['businessType'] ?? '',
      usingSystem: json['usingSystem'] ?? false,
      customerPotential: json['customerPotential'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      address: json['address'],
      createdAt: json['createdAt']?.toDate() ?? DateTime.now(),
      updatedAt: json['updatedAt']?.toDate() ?? DateTime.now(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'clientName': clientName,
      'phoneNumber': phoneNumber,
      if (companyName != null) 'companyName': companyName,
      'businessType': businessType,
      'usingSystem': usingSystem,
      'customerPotential': customerPotential,
      'latitude': latitude,
      'longitude': longitude,
      if (address != null) 'address': address,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
  
  factory ClientModel.fromEntity(Client client) {
    return ClientModel(
      id: client.id,
      userId: client.userId,
      clientName: client.clientName,
      phoneNumber: client.phoneNumber,
      companyName: client.companyName,
      businessType: client.businessType,
      usingSystem: client.usingSystem,
      customerPotential: client.customerPotential,
      latitude: client.latitude,
      longitude: client.longitude,
      address: client.address,
      createdAt: client.createdAt,
      updatedAt: client.updatedAt,
    );
  }
}