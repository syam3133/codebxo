import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/client_model.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/constants/firebase_constants.dart';

abstract class ClientRemoteDataSource {
  Future<List<ClientModel>> getClientList(String userId);
  Future<ClientModel> getClientById(String clientId);
  Future<ClientModel> addClient(ClientModel client);
  Future<ClientModel> updateClient(ClientModel client);
  Future<void> deleteClient(String clientId);
  Future<List<ClientModel>> searchClients(String userId, String query);
}

class ClientRemoteDataSourceImpl implements ClientRemoteDataSource {
  final FirebaseFirestore firestore;
  
  ClientRemoteDataSourceImpl({required this.firestore});
  
  @override
  Future<List<ClientModel>> getClientList(String userId) async {
    try {
      final snapshot = await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(userId)
          .collection(FirebaseConstants.clientsCollection)
          .orderBy(FirebaseConstants.createdAtField, descending: true)
          .get();
      
      return snapshot.docs
          .map((doc) => ClientModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<ClientModel> getClientById(String clientId) async {
    try {
      // We need to find which user owns this client
      // In a real app, you might store the userId in the client document
      // For simplicity, we'll assume the current user is the owner
      
      final snapshot = await firestore
          .collectionGroup(FirebaseConstants.clientsCollection)
          .where(FieldPath.documentId, isEqualTo: clientId)
          .limit(1)
          .get();
      
      if (snapshot.docs.isEmpty) {
        throw ServerException('Client not found');
      }
      
      final doc = snapshot.docs.first;
      return ClientModel.fromJson(doc.data(), doc.id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<ClientModel> addClient(ClientModel client) async {
    try {
      final docRef = await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(client.userId)
          .collection(FirebaseConstants.clientsCollection)
          .add(client.toJson());
      
      // Get the created document
      final docSnapshot = await docRef.get();
      return ClientModel.fromJson(docSnapshot.data()!, docSnapshot.id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<ClientModel> updateClient(ClientModel client) async {
    try {
      await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(client.userId)
          .collection(FirebaseConstants.clientsCollection)
          .doc(client.id)
          .update(client.toJson());
      
      return client;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<void> deleteClient(String clientId) async {
    try {
      // Similar to getClientById, we need to find which user owns this client
      final snapshot = await firestore
          .collectionGroup(FirebaseConstants.clientsCollection)
          .where(FieldPath.documentId, isEqualTo: clientId)
          .limit(1)
          .get();
      
      if (snapshot.docs.isEmpty) {
        throw ServerException('Client not found');
      }
      
      final doc = snapshot.docs.first;
      await doc.reference.delete();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<List<ClientModel>> searchClients(String userId, String query) async {
    try {
      // Firestore doesn't support full-text search natively
      // For a simple implementation, we'll search by client name
      // In a real app, you might use Algolia or another search service
      
      final snapshot = await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(userId)
          .collection(FirebaseConstants.clientsCollection)
          .where(FirebaseConstants.clientNameField, isGreaterThanOrEqualTo: query)
          .where(FirebaseConstants.clientNameField, isLessThanOrEqualTo: query + '\uf8ff')
          .orderBy(FirebaseConstants.clientNameField)
          .get();
      
      return snapshot.docs
          .map((doc) => ClientModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}