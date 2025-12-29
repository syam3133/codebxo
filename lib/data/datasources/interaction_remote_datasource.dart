import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final FirebaseAuth auth;
  
  InteractionRemoteDataSourceImpl({
    required this.firestore,
    required this.auth,
  });
  
  @override
  Future<List<InteractionModel>> getInteractionList(String clientId) async {
    try {
      // First get the current user
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        throw ServerException('User not authenticated');
      }
      
      // Get the user's clients to find the one with matching clientId
      final clientsSnapshot = await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(currentUser.uid)
          .collection(FirebaseConstants.clientsCollection)
          .where(FieldPath.documentId, isEqualTo: clientId)
          .limit(1)
          .get();
      
      if (clientsSnapshot.docs.isEmpty) {
        return []; // Return empty list if client not found
      }
      
      final clientDoc = clientsSnapshot.docs.first;
      
      // Now get interactions for this client
      final interactionsSnapshot = await clientDoc.reference
          .collection(FirebaseConstants.interactionsCollection)
          .orderBy(FirebaseConstants.createdAtField, descending: true)
          .get();
      
      return interactionsSnapshot.docs
          .map((doc) => InteractionModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw ServerException('Failed to get interactions: $e');
    }
  }
  
  @override
  Future<InteractionModel> addInteraction(InteractionModel interaction) async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        throw ServerException('User not authenticated');
      }
      
      // Create the interaction document
      final docRef = await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(currentUser.uid)
          .collection(FirebaseConstants.clientsCollection)
          .doc(interaction.clientId)
          .collection(FirebaseConstants.interactionsCollection)
          .add(interaction.toJson());
      
      // Get the created document
      final docSnapshot = await docRef.get();
      return InteractionModel.fromJson(docSnapshot.data()!, docSnapshot.id);
    } catch (e) {
      throw ServerException('Failed to add interaction: $e');
    }
  }
  
  @override
  Future<InteractionModel> updateInteraction(InteractionModel interaction) async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        throw ServerException('User not authenticated');
      }
      
      await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(currentUser.uid)
          .collection(FirebaseConstants.clientsCollection)
          .doc(interaction.clientId)
          .collection(FirebaseConstants.interactionsCollection)
          .doc(interaction.id)
          .update(interaction.toJson());
      
      return interaction;
    } catch (e) {
      throw ServerException('Failed to update interaction: $e');
    }
  }
  
  @override
  Future<void> deleteInteraction(String interactionId) async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        throw ServerException('User not authenticated');
      }
      
      // Find the interaction document
      final interactionsSnapshot = await firestore
          .collectionGroup(FirebaseConstants.interactionsCollection)
          .where(FieldPath.documentId, isEqualTo: interactionId)
          .limit(1)
          .get();
      
      if (interactionsSnapshot.docs.isEmpty) {
        throw ServerException('Interaction not found');
      }
      
      await interactionsSnapshot.docs.first.reference.delete();
    } catch (e) {
      throw ServerException('Failed to delete interaction: $e');
    }
  }
}