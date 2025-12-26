import '../../domain/entities/interaction.dart';
import '../../../core/constants/firebase_constants.dart';

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
      interactionType: json[FirebaseConstants.interactionTypeField] ?? '',
      notes: json[FirebaseConstants.notesField],
      clientReply: json[FirebaseConstants.clientReplyField],
      followUpDate: json[FirebaseConstants.followUpDateField]?.toDate(),
      createdAt: json[FirebaseConstants.createdAtField]?.toDate() ?? DateTime.now(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'clientId': clientId,
      FirebaseConstants.interactionTypeField: interactionType,
      if (notes != null) FirebaseConstants.notesField: notes,
      if (clientReply != null) FirebaseConstants.clientReplyField: clientReply,
      if (followUpDate != null) FirebaseConstants.followUpDateField: followUpDate,
      FirebaseConstants.createdAtField: createdAt,
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