import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/members/data/repositories/user_repository.dart';
import '../../features/members/data/repositories/user_repository_impl.dart';
import '../../features/home/data/repositories/post_repository.dart';
import '../../features/home/data/repositories/post_repository_impl.dart';

/// Firebase Auth provider
/// Lazy initialization to ensure Firebase is initialized first
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  if (Firebase.apps.isEmpty) {
    throw Exception(
        'Firebase not initialized. Call Firebase.initializeApp() first.');
  }
  return FirebaseAuth.instance;
});

/// Firebase Firestore provider
/// Lazy initialization to ensure Firebase is initialized first
final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  if (Firebase.apps.isEmpty) {
    throw Exception(
        'Firebase not initialized. Call Firebase.initializeApp() first.');
  }
  return FirebaseFirestore.instance;
});

/// User repository provider
/// Provides UserRepository implementation
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final auth = ref.watch(firebaseAuthProvider);
  return UserRepositoryImpl(firestore: firestore, auth: auth);
});

/// Post repository provider
/// Provides PostRepository implementation
final postRepositoryProvider = Provider<PostRepository>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return PostRepositoryImpl(firestore: firestore);
});
