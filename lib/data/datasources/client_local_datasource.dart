import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/interaction_model.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/constants/firebase_constants.dart';

abstract class InteractionRemoteDataSource {
  Future<List<InteractionModel>> getInteractionList(String clientId);
  Future<InteractionModel> addInteraction(InteractionModel interaction);
  Future<InteractionModel> updateInteraction(InteractionModel interaction);
  Future<void> deleteInteraction(String interactionId);
}

class InteractionRemoteDataSourceImpl implements InteractionRemoteDataSource {
  final FirebaseFirestore firestore;
  
  InteractionRemoteDataSourceImpl({required this.firestore});
  
  @override
  Future<List<InteractionModel>> getInteractionList(String clientId) async {
    try {
      final snapshot = await firestore
          .collectionGroup(FirebaseConstants.interactionsCollection)
          .where('clientId', isEqualTo: clientId)
          .orderBy(FirebaseConstants.createdAtField, descending: true)
          .get();
      
      return snapshot.docs
          .map((doc) => InteractionModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<InteractionModel> addInteraction(InteractionModel interaction) async {
    try {
      // Find the client to get the userId
      final clientSnapshot = await firestore
          .collectionGroup(FirebaseConstants.clientsCollection)
          .where(FieldPath.documentId, isEqualTo: interaction.clientId)
          .limit(1)
          .get();
      
      if (clientSnapshot.docs.isEmpty) {
        throw ServerException('Client not found');
      }
      
      final clientDoc = clientSnapshot.docs.first;
      final userId = clientDoc.data()[FirebaseConstants.userIdField];
      
      final docRef = await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(userId)
          .collection(FirebaseConstants.clientsCollection)
          .doc(interaction.clientId)
          .collection(FirebaseConstants.interactionsCollection)
          .add(interaction.toJson());
      
      // Get the created document
      final docSnapshot = await docRef.get();
      return InteractionModel.fromJson(docSnapshot.data()!, docSnapshot.id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<InteractionModel> updateInteraction(InteractionModel interaction) async {
    try {
      // Find the client to get the userId
      final clientSnapshot = await firestore
          .collectionGroup(FirebaseConstants.clientsCollection)
          .where(FieldPath.documentId, isEqualTo: interaction.clientId)
          .limit(1)
          .get();
      
      if (clientSnapshot.docs.isEmpty) {
        throw ServerException('Client not found');
      }
      
      final clientDoc = clientSnapshot.docs.first;
      final userId = clientDoc.data()[FirebaseConstants.userIdField];
      
      await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(userId)
          .collection(FirebaseConstants.clientsCollection)
          .doc(interaction.clientId)
          .collection(FirebaseConstants.interactionsCollection)
          .doc(interaction.id)
          .update(interaction.toJson());
      
      return interaction;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<void> deleteInteraction(String interactionId) async {
    try {
      // Find the interaction to get the parent client and user
      final snapshot = await firestore
          .collectionGroup(FirebaseConstants.interactionsCollection)
          .where(FieldPath.documentId, isEqualTo: interactionId)
          .limit(1)
          .get();
      
      if (snapshot.docs.isEmpty) {
        throw ServerException('Interaction not found');
      }
      
      final doc = snapshot.docs.first;
      await doc.reference.delete();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}