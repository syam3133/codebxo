import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../../../core/errors/exceptions.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(String email, String password, String name);
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> userChanges();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  
  AuthRemoteDataSourceImpl({
    required this.auth,
    required this.firestore,
  });
  
  @override
  Future<UserModel> signIn(String email, String password) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user == null) {
        throw ServerException('Login failed');
      }
      
      return await _getUserData(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Authentication failed');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<UserModel> signUp(String email, String password, String name) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user == null) {
        throw ServerException('Registration failed');
      }
      
      // Create user document in Firestore
      final userDoc = UserModel(
        id: userCredential.user!.uid,
        email: email,
        name: name,
        createdAt: DateTime.now(),
      );
      
      await firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userDoc.toJson());
      
      return userDoc;
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Registration failed');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = auth.currentUser;
      if (user == null) return null;
      return await _getUserData(user.uid);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Stream<UserModel?> userChanges() {
    return auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      return await _getUserData(user.uid);
    });
  }
  
  Future<UserModel> _getUserData(String uid) async {
    final docSnapshot = await firestore.collection('users').doc(uid).get();
    
    if (!docSnapshot.exists) {
      throw ServerException('User data not found');
    }
    
    return UserModel.fromJson(docSnapshot.data()!, docSnapshot.id);
  }
}