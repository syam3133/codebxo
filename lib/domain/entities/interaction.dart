class Interaction {
  final String id;
  final String clientId;
  final String interactionType;
  final String? notes;
  final String? clientReply;
  final DateTime? followUpDate;
  final DateTime createdAt;
  
  Interaction({
    required this.id,
    required this.clientId,
    required this.interactionType,
    this.notes,
    this.clientReply,
    this.followUpDate,
    required this.createdAt,
  });
}