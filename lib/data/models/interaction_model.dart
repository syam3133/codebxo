import '../../domain/entities/interaction.dart';

class InteractionModel extends Interaction {
  InteractionModel({
    required String id,
    required String clientId,
    required String interactionType,
    String? notes,
    String? clientReply,
    DateTime? followUpDate,
    required DateTime createdAt,
  }) : super(
    id: id,
    clientId: clientId,
    interactionType: interactionType,
    notes: notes,
    clientReply: clientReply,
    followUpDate: followUpDate,
    createdAt: createdAt,
  );
  
  factory InteractionModel.fromJson(Map<String, dynamic> json, String documentId) {
    return InteractionModel(
      id: documentId,
      clientId: json['clientId'] ?? '',
      interactionType: json['interactionType'] ?? '',
      notes: json['notes'],
      clientReply: json['clientReply'],
      followUpDate: json['followUpDate']?.toDate(),
      createdAt: json['createdAt']?.toDate() ?? DateTime.now(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'clientId': clientId,
      'interactionType': interactionType,
      if (notes != null) 'notes': notes,
      if (clientReply != null) 'clientReply': clientReply,
      if (followUpDate != null) 'followUpDate': followUpDate,
      'createdAt': createdAt,
    };
  }
  
  factory InteractionModel.fromEntity(Interaction interaction) {
    return InteractionModel(
      id: interaction.id,
      clientId: interaction.clientId,
      interactionType: interaction.interactionType,
      notes: interaction.notes,
      clientReply: interaction.clientReply,
      followUpDate: interaction.followUpDate,
      createdAt: interaction.createdAt,
    );
  }
}