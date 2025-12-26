import '../../domain/entities/client.dart';
import '../../../core/constants/firebase_constants.dart';

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
      userId: json[FirebaseConstants.userIdField] ?? '',
      clientName: json[FirebaseConstants.clientNameField] ?? '',
      phoneNumber: json[FirebaseConstants.phoneNumberField] ?? '',
      companyName: json[FirebaseConstants.companyNameField],
      businessType: json[FirebaseConstants.businessTypeField] ?? '',
      usingSystem: json[FirebaseConstants.usingSystemField] ?? false,
      customerPotential: json[FirebaseConstants.customerPotentialField] ?? '',
      latitude: (json[FirebaseConstants.latitudeField] ?? 0.0).toDouble(),
      longitude: (json[FirebaseConstants.longitudeField] ?? 0.0).toDouble(),
      address: json[FirebaseConstants.addressField],
      createdAt: json[FirebaseConstants.createdAtField]?.toDate() ?? DateTime.now(),
      updatedAt: json[FirebaseConstants.updatedAtField]?.toDate() ?? DateTime.now(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      FirebaseConstants.userIdField: userId,
      FirebaseConstants.clientNameField: clientName,
      FirebaseConstants.phoneNumberField: phoneNumber,
      if (companyName != null) FirebaseConstants.companyNameField: companyName,
      FirebaseConstants.businessTypeField: businessType,
      FirebaseConstants.usingSystemField: usingSystem,
      FirebaseConstants.customerPotentialField: customerPotential,
      FirebaseConstants.latitudeField: latitude,
      FirebaseConstants.longitudeField: longitude,
      if (address != null) FirebaseConstants.addressField: address,
      FirebaseConstants.createdAtField: createdAt,
      FirebaseConstants.updatedAtField: updatedAt,
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